module CanvasCsv
  class Temp
    include ClassLogger

    COURSE_IDS = %w(CRS:XYZ-4A-2018-D)
    SIS_TO_CANVAS = {"CRS:XYZ-4A-2018-D"=>123}

    def self.find_appointments_and_events()
      ids = COURSE_IDS
      # sis_to_canvas_courses = sis_ids_to_canvas_course_ids ids
      sis_to_canvas_courses = SIS_TO_CANVAS
      sites_with_scheduler = []
      for id in sis_to_canvas_courses.keys
        canvas_course_id = sis_to_canvas_courses[id]
        # appts_r = Canvas::Calendar.new().course_appointment_groups(canvas_course_id)
        # appts_m = Canvas::Calendar.new().course_appointment_groups(canvas_course_id, 'manageable')
        # logger.warn "Course #{id} / #{canvas_course_id} reservable = #{appts_r}, manageable = #{appts_m}"
        events = Canvas::Calendar.new().course_calendar_events(canvas_course_id)
        logger.warn "Course #{id} / #{canvas_course_id} events = #{events}"
      end
      return sites_with_scheduler
    end


    def self.sis_ids_to_canvas_course_ids(sis_course_ids)
      sis_to_canvas = {}
      for sis_id in sis_course_ids
        resp = Canvas::Course.new(canvas_course_id: "sis_course_id:#{sis_id}").course
        if (feed = resp.fetch(:body, nil))
          sis_to_canvas[sis_id] = feed['id']
        end
      end
      sis_to_canvas
    end

    def self.find_differentiated_assignments()
      ids = COURSE_IDS
      sites_with_override_assignments = []
      for id in ids
        course_id = "sis_course_id:#{id}"
        feed = Canvas::CourseAssignments.new(course_id: course_id).course_assignments
        for assignment in feed
          if assignment['only_visible_to_overrides'] and assignment['has_overrides']
            sites_with_override_assignments << "https://bcourses.berkeley.edu/courses/#{course_id}"
            break
          end
        end
      end
      print "Sites with override assignments: #{sites_with_override_assignments}"
      return sites_with_override_assignments
    end

    def self.find_group_assignments()
      ids = COURSE_IDS
      sites_with_group_assignments = []
      for course_id in ids
        # course_id = "sis_course_id:#{id}"
        feed = Canvas::CourseAssignments.new(course_id: course_id).course_assignments
        for assignment in feed
          if assignment['group_category_id']
            sites_with_group_assignments << "https://bcourses.berkeley.edu/courses/#{course_id}"
            break
          end
        end
      end
      print "Sites with group assignments: #{sites_with_group_assignments}"
      return sites_with_group_assignments
    end

    def self.find_empty_groups()
      ids = COURSE_IDS
      sites_with_empty_groups = []
      for id in ids
        course_id = "sis_course_id:#{id}"
        resp = Canvas::CourseSections.new(course_id: course_id).groups_list
        feed = resp[:body]
        for group in feed
          if group['members_count'] == 0
            # sites_with_empty_groups << "https://bcourses.berkeley.edu/courses/#{course_id}"
            sites_with_empty_groups << "https://ucberkeley.beta.instructure.com/courses/#{course_id}"
            break
          end
        end
      end
      print "Sites with empty groups: #{sites_with_empty_groups}"
      return sites_with_empty_groups
    end

    def self.dump_group_memberships
      csv = CSV.open(
        'beta_group_memberships.tsv', 'wb',
        {
          headers: ['site_id', 'group_id', 'memberships'],
          write_headers: true,
          col_sep: "\t"
        }
      )
      ids = COURSE_IDS
      nonempty_groups = []
      for id in ids
        course_id = "sis_course_id:#{id}"
        feed = Canvas::Groups.new.course_groups course_id
        for group in feed
          if group['members_count'] > 0
            group_id = group['id']
            memberships = Canvas::Groups.new.group_memberships group_id
            nonempty_groups << memberships
            csv << [course_id, group_id, memberships.to_json]
          end
        end
      end
      csv.close
      nonempty_groups
    end

    def self.add_memberships_to_empty_groups
      rows = CSV.read('beta_group_memberships.tsv', {headers: true, col_sep:"\t"})
      changes = []
      for row in rows
        site_id = row['site_id']
        group_id = row['group_id'].to_i
        beta_memberships = JSON(row['memberships'])
        prod_memberships = Canvas::Groups.new.group_memberships group_id
        if prod_memberships.empty?
          for membership in beta_memberships
            if membership['workflow_state'] == 'accepted'
              user_id = membership['user_id']
              changes << {site_id: site_id, group_id: group_id, canvas_user_id: user_id}
              result = Canvas::Groups.new.create_membership(group_id, user_id)
              puts "Added #{user_id} to group #{group_id} : #{result}"
            end
          end
        end
      end
      changes
    end

  end
end
