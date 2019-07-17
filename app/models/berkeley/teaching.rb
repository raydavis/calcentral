module Berkeley
  class Teaching < UserSpecificModel

    def merge(data)
      feed = EdoOracle::UserCourses::All.new(user_id: @uid).get_all_campus_courses
      # TODO Legacy terms are currently used only to prop up automated tests - dump or rewrite!
      feed.merge!  CampusOracle::UserCourses::All.new(user_id: @uid).get_all_campus_courses if Settings.features.allow_legacy_fallback
      teaching_semesters = format_teaching_semesters feed
      if teaching_semesters.present?
        data[:teachingSemesters] = teaching_semesters
        data[:pastSemestersTeachingCount] = teaching_semesters.select {|sem| sem[:timeBucket] == 'past'}.length
        data[:pastSemestersTeachingLimit] = teaching_semesters.length - data[:pastSemestersTeachingCount] + 1;
      end
    end

    # Our bCourses Canvas integration occasionally needs to create an Academics Teaching Semesters
    # list based on an explicit set of CCNs.
    def courses_list_from_ccns(term_yr, term_code, ccns)
      proxy = EdoOracle::UserCourses::SelectedSections.new({user_id: @uid})
      feed = proxy.get_selected_sections(term_yr, term_code, ccns)
      format_teaching_semesters(feed, true)
    end

    def format_teaching_semesters(sections_data, ignore_roles = false)
      teaching_semesters = []
      # The campus courses data is organized by semesters, with course offerings under them.
      sections_data.keys.sort.reverse_each do |term_key|
        teaching_semester = Concerns::AcademicsModule.semester_info term_key
        sections_data[term_key].each do |course|
          next unless ignore_roles || (course[:role] == 'Instructor')
          course_info = Concerns::AcademicsModule.course_info_with_multiple_listings course
          course_info.merge! enrollment_limits(course)
          if course_info[:sections].count { |section| section[:is_primary_section] } > 1
            Concerns::AcademicsModule.merge_multiple_primaries(course_info, course[:course_option])
          end
          Concerns::AcademicsModule.append_with_merged_crosslistings(teaching_semester[:classes], course_info)
        end
        teaching_semesters << teaching_semester unless teaching_semester[:classes].empty?
      end
      teaching_semesters
    end

    def enrollment_limits(course)
      {
        enrollLimit: course[:enroll_limit],
        waitlistLimit: course[:waitlist_limit]
      }
    end

    def merge_canvas_sites(data)
      if Canvas::Proxy.access_granted?(@uid) && (canvas_sites = Canvas::MergedUserSites.new(@uid).get_feed)
        included_course_sites = {}
        canvas_sites[:courses].each do |course_site|
          if (merged_courses = course_site_merge(data, course_site))
            included_course_sites[course_site[:id]] = merged_courses
          end
        end
        canvas_sites[:groups].each do |group_site|
          if (linked_id = group_site[:course_id]) && (linked_classes = included_course_sites[linked_id])
            group_entry = group_site_entry(group_site, linked_classes[:source])
            linked_classes[:role_and_slugs].each do |role_and_slug|
              if (linked_term = data[:teachingSemesters].find { |term| term[:slug] == linked_classes[:term_slug] })
                if linked_term[:classes] && (linked_class = linked_term[:classes].select { |c| c[:slug] == role_and_slug[:slug] }.first)
                  linked_class[:class_sites].try(:<<, group_entry)
                end
              end
            end
          end
        end
      end
      data
    end

    # Returns the list (if any) of campus classes which include this Canvas course site.
    # This is then referred to for any Canvas group sites associated with the course site.
    def course_site_merge(data, course_site)
      merged_courses = nil
      if (term_yr = course_site[:term_yr]) && (term_cd = course_site[:term_cd]) &&
        (term_slug = Berkeley::TermCodes.to_slug(term_yr, term_cd))
        if (site_sections = course_site[:sections])
          campus_terms = data[:teachingSemesters]
          if campus_terms.present? && (matching_term = campus_terms.find { |t| t[:slug] == term_slug })
            # Compare CCNs as parsed integers to avoid mismatches on prefixed zeroes.
            site_ccns = site_sections.collect {|s| s[:ccn].to_i}
            campus_courses = matching_term[:classes]
            campus_courses.each do |course|
              linked_ccns = []
              course[:sections].each do |s|
                if site_ccns.include? s[:ccn].to_i
                  linked_ccns << {ccn: s[:ccn]}
                  # In the case of multiple primaries, expose the minimum data needed to make a section association.
                  if course[:multiplePrimaries]
                    primary_to_associate = s[:is_primary_section] ? s : course[:sections].find { |prim| prim[:slug] == s[:associatedWithPrimary] }
                    if primary_to_associate
                      primary_to_associate[:siteIds] ||= []
                      primary_to_associate[:siteIds] << course_site[:id]
                    end
                  end
                end
              end
              if linked_ccns.present?
                course[:class_sites] ||= []
                site_entry = Concerns::AcademicsModule.course_site_entry(course_site)
                # Do not expose course site integrations to students, since Canvas does not expose
                # section IDs.
                site_entry[:sections] = linked_ccns
                course[:class_sites] << site_entry
                merged_courses ||= {
                  term_slug: matching_term[:slug],
                  source: course_site[:name],
                  role_and_slugs: []
                }
                merged_courses[:role_and_slugs] << {role_key: :teachingSemesters, slug: course[:slug]}
              end
            end
          end
        end
      end
      merged_courses
    end

    def group_site_entry(group_site, source)
      {
        emitter: group_site[:emitter],
        id: group_site[:id],
        name: group_site[:name],
        siteType: 'group',
        site_url: group_site[:site_url],
        source: source
      }
    end

  end
end
