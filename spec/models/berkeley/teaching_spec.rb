describe Berkeley::Teaching do

  before do
    allow(Settings.features).to receive(:hub_term_api).and_return false
  end

  let(:instance) { described_class.new(uid) }
  let(:feed) { {}.tap { |feed| instance.merge feed } }
  let(:teaching) { feed[:teachingSemesters] }

  shared_examples 'a properly translated feed' do
    it 'should properly translate semesters' do
      expect(teaching).to have(2).items
      expect(teaching.first).to include({
        name: 'Fall 2013',
        termCode: 'D',
        termYear: '2013'
      })
    end
    it 'should properly translate sample BIOLOGY course' do
      expect(teaching[0][:classes]).to have(2).items
      bio1a = teaching[0][:classes].find { |course| course[:listings].first[:course_code] == 'BIOLOGY 1A' }
      expect(bio1a).to include({
        title: 'General Biology Lecture',
        role: 'Instructor'
      })
      expect(bio1a[:listings]).to have(1).items
      expect(bio1a[:listings].first[:dept]).to eq 'BIOLOGY'
      # Redundant fields to keep parity with student semesters feed structure
      expect(bio1a).to include({
        courseCatalog: '1A',
        course_code: 'BIOLOGY 1A',
        course_id: 'biology-1a-2013-D',
        dept: 'BIOLOGY'
      })
      expect(bio1a[:url]).to eq '/academics/teaching-semester/fall-2013/class/biology-1a-2013-D'
    end
    it 'should properly translate sample COG SCI course' do
      cogsci = teaching[0][:classes].find {|course| course[:listings].find {|listing| listing[:course_code] == 'COG SCI C147'}}
      expect(cogsci).not_to be_empty
      expect(cogsci).to include({
        title: 'Language Disorders',
        url: '/academics/teaching-semester/fall-2013/class/cog_sci-c147-2013-D'
      })
      expect(cogsci[:listings].map {|listing| listing[:dept]}).to include 'COG SCI'
    end
    it 'should properly translate section-level data' do
      bio1a = teaching[0][:classes].find { |course| course[:listings].first[:course_code] == 'BIOLOGY 1A' }
      expect(bio1a[:scheduledSectionCount]).to eq 3
      expect(bio1a[:scheduledSections]).to include({format: 'lecture', count: 1})
      expect(bio1a[:scheduledSections]).to include({format: 'discussion', count: 2})
      expect(bio1a[:sections]).to have(3).items
      expect(bio1a[:sections][0][:is_primary_section]).to eq true
      expect(bio1a[:sections][1][:is_primary_section]).to eq false
      expect(bio1a[:sections][2][:is_primary_section]).to eq false
    end
    it 'should let the past be the past' do
      expect(teaching[1][:name]).to eq 'Spring 2012'
      expect(teaching[1][:classes]).to have(2).items
      expect(teaching[1][:timeBucket]).to eq 'past'
    end
  end

  context 'academic data from Campus Solutions' do
    before do
      allow(Settings.terms).to receive(:legacy_cutoff).and_return 'fall-2009'
      expect(EdoOracle::UserCourses::All).to receive(:new).and_return double(get_all_campus_courses: edo_courses)
      expect(CampusOracle::Queries).not_to receive :get_instructing_sections
    end
    let(:uid) { '242881' }
    let(:edo_courses) do
      {
        '2013-D' => [
          {
            id: 'biology-1a-2013-D',
            slug: 'biology-1a',
            course_code: 'BIOLOGY 1A',
            term_yr: '2013',
            term_cd: 'D',
            term_id: '2138',
            dept: 'BIOLOGY',
            catid: '1A',
            course_catalog: '1A',
            emitter: 'Campus',
            name: 'General Biology Lecture',
            sections: [
              {
                ccn: '07309',
                enroll_limit: 50,
                instruction_format: 'LEC',
                is_primary_section: true,
                schedules: {oneTime: [], recurring: []},
                section_label: 'LEC 003',
                section_number: '003',
                waitlist_limit: 10
              },
              {
                ccn: '07366',
                enroll_limit: 25,
                instruction_format: 'DIS',
                is_primary_section: false,
                schedules: {oneTime: [], recurring: []},
                section_label: 'DIS 201',
                section_number: '201',
                waitlist_limit: 5
              },
              {
                ccn: '07372',
                enroll_limit: 25,
                instruction_format: 'DIS',
                is_primary_section: false,
                schedules: {oneTime: [], recurring: []},
                section_label: 'DIS 202',
                section_number: '202',
                waitlist_limit: 5
              }
            ],
            session_code: nil,
            role: 'Instructor',
            enroll_limit: 50,
            waitlist_limit: 10
          },
          {
            id: 'sumerian-c147-2013-D',
            slug: 'sumerian-c147',
            course_code: 'SUMERIAN C147',
            term_yr: '2013',
            term_cd: 'D',
            term_id: '2138',
            dept: 'SUMERIAN',
            catid: 'C147',
            course_catalog: 'C147',
            emitter: 'Campus',
            name: nil,
            sections: [
              {
                ccn: '10171',
                enroll_limit: 30,
                instruction_format: 'LEC',
                is_primary_section: true,
                schedules: {oneTime: [], recurring: []},
                section_label: 'LEC 001',
                section_number: '001',
                waitlist_limit: 0,
                cross_listing_hash: '2138-12345-LEC-001'
              }
            ],
            session_code: nil,
            role: 'Instructor',
            enroll_limit: 30,
            waitlist_limit: 0
          },
          {
            id: 'cog_sci-c147-2013-D',
            slug: 'cog_sci-c147',
            course_code: 'COG SCI C147',
            term_yr: '2013',
            term_cd: 'D',
            term_id: '2138',
            dept: 'COG SCI',
            catid: 'C147',
            course_catalog: 'C147',
            emitter: 'Campus',
            name: 'Language Disorders',
            sections: [
              {
                ccn: '16171',
                instruction_format: 'LEC',
                is_primary_section: true,
                schedules: {oneTime: [], recurring: []},
                section_label: 'LEC 001',
                section_number: '001',
                enroll_limit: 30,
                waitlist_limit: 0,
                cross_listing_hash: '2138-12345-LEC-001'
              }
            ],
            session_code: nil,
            role: 'Instructor',
            enroll_limit: 30,
            waitlist_limit: 0
          }
        ],
        '2012-B' => [
          {
            id: 'biology-1a-2012-B',
            slug: 'biology-1a',
            course_code: 'BIOLOGY 1A',
            term_yr: '2012',
            term_cd: 'B',
            term_id: '2122',
            dept: 'BIOLOGY',
            catid: '1A',
            course_catalog: '1A',
            emitter: 'Campus',
            name: 'General Biology Lecture',
            sections: [
              {
                ccn: '07366',
                enroll_limit: 25,
                instruction_format: 'DIS',
                is_primary_section: false,
                schedules: {oneTime: [], recurring: []},
                section_label: 'DIS 201',
                section_number: '201',
                waitlist_limit: 5,
              }
            ],
            session_code: nil,
            role: 'Instructor'
          },
          {
            id: 'cog_sci-c147-2012-B',
            slug: 'cog_sci-c147',
            course_code: 'COG SCI C147',
            term_yr: '2012',
            term_cd: 'B',
            term_id: '2122',
            dept: 'COG SCI',
            catid: 'C147',
            course_catalog: 'C147',
            emitter: 'Campus',
            name: 'Language Disorders',
            sections: [
              {
                ccn: '16171',
                instruction_format: 'LEC',
                is_primary_section: true,
                schedules: {oneTime: [], recurring: []},
                section_label: 'LEC 001',
                section_number: '001',
                enroll_limit: 30,
                waitlist_limit: 0
              }
            ],
            session_code: nil,
            role: 'Instructor',
            enroll_limit: 30,
            waitlist_limit: 0
          }
        ]
      }
    end
    it_should_behave_like 'a properly translated feed'
    it 'advertises Campus Solutions source' do
      expect(teaching).to all include({campusSolutionsTerm: true})
    end
    it 'merges cross-listings preserving course title' do
      language_disorders = teaching[0][:classes].find { |course| course[:title] == 'Language Disorders' }
      expect(language_disorders[:listings].map { |listing| listing[:dept]}).to match_array ['COG SCI', 'SUMERIAN']
      expect(language_disorders[:sections].map { |section| section[:ccn]}).to match_array %w(10171 16171)
    end
    it 'translates enrollment and waitlist limits' do
      bio1a = teaching[0][:classes].find { |course| course[:listings].first[:course_code] == 'BIOLOGY 1A' }
      expect(bio1a[:enrollLimit]).to eq 50
      expect(bio1a[:waitlistLimit]).to eq 10
    end
  end

  describe '#courses_list_from_ccns' do
    subject do
      Berkeley::Teaching.new(random_id).courses_list_from_ccns(term[:yr], term[:cd], (good_ccns + bad_ccns))
    end
    let(:good_ccns) { ['07309', '07366', '16171'] }
    let(:bad_ccns) { ['919191'] }
    # Lock down to a known set of sections, either in the test DB or in real campus data.
    shared_examples 'a good and proper section formatting' do
      it 'formats section information for known CCNs' do
        expect(subject.length).to eq 1
        classes_list = subject[0][:classes]
        expect(classes_list.length).to eq 2
        bio_class = classes_list[0]
        expect(bio_class[:course_code]).to eq 'BIOLOGY 1A'
        expect(bio_class[:sections].first[:courseCode]).to eq 'BIOLOGY 1A'
        expect(bio_class[:dept]).to eq 'BIOLOGY'
        sections = bio_class[:sections]
        expect(sections.length).to eq 2
        expect(sections[0][:ccn].to_i).to eq 7309
        expect(sections[0][:section_label]).to eq 'LEC 003'
        expect(sections[0][:is_primary_section]).to be_truthy
        expect(sections[1][:ccn].to_i).to eq 7366
        expect(sections[1][:is_primary_section]).to be_falsey
        cog_sci_class = classes_list[1]
        sections = cog_sci_class[:sections]
        expect(sections.length).to eq 1
        expect(sections[0][:ccn].to_i).to eq 16171
      end
    end

    context 'Campus Solutions term data' do
      before do
        allow(Settings.terms).to receive(:legacy_cutoff).and_return 'fall-2009'
        expect(EdoOracle::UserCourses::SelectedSections).to receive(:new).and_return double(get_selected_sections: edo_courses)
        expect(CampusOracle::UserCourses::SelectedSections).not_to receive :new
      end
      let(:term) { {yr: '2013', cd: 'D'} }
      let(:edo_courses) do
        {
          '2013-D' => [
            {
              id: 'biology-1a-2013-D',
              slug: 'biology-1a',
              course_code: 'BIOLOGY 1A',
              term_yr: '2013',
              term_cd: 'D',
              term_id: '2138',
              dept: 'BIOLOGY',
              catid: '1A',
              course_catalog: '1A',
              emitter: 'Campus',
              name: 'General Biology Lecture',
              sections: [
                {
                  ccn: '07309',
                  instruction_format: 'LEC',
                  is_primary_section: true,
                  schedules: {oneTime: [], recurring: []},
                  section_label: 'LEC 003',
                  section_number: '003'
                },
                {
                  ccn: '07366',
                  instruction_format: 'DIS',
                  is_primary_section: false,
                  schedules: {oneTime: [], recurring: []},
                  section_label: 'DIS 201',
                  section_number: '201'
                }
              ],
              role: 'Instructor'
            },
            {
              id: 'cog_sci-c147-2013-D',
              slug: 'cog_sci-c147',
              course_code: 'COG SCI C147',
              term_yr: '2013',
              term_cd: 'D',
              term_id: '2138',
              dept: 'COG SCI',
              catid: 'C147',
              course_catalog: 'C147',
              emitter: 'Campus',
              name: 'Language Disorders',
              sections: [
                {
                  ccn: '16171',
                  instruction_format: 'LEC',
                  is_primary_section: true,
                  schedules: {oneTime: [], recurring: []},
                  section_label: 'LEC 001',
                  section_number: '001'
                }
              ],
              role: 'Instructor'
            }
          ]
        }
      end
      include_examples 'a good and proper section formatting'
    end
  end

  describe 'merge_canvas_sites' do
    let(:uid) {rand(99999).to_s}
    let(:ccn) {rand(99999)}
    let(:course_id) {"econ-#{rand(999)}B"}
    let(:campus_course_base) do
      {
        slug: course_id,
        sections: [{
                     ccn: ccn.to_s
                   }],
        class_sites: []
      }
    end
    let(:campus_course_multiple_primaries_base) do
      {
        slug: course_id,
        multiplePrimaries: true,
        sections: [
          {ccn: ccn.to_s},
          {ccn: (ccn+1).to_s}
        ],
        class_sites: []
      }
    end
    let(:fake_term_yr) {2013}
    let(:fake_term_cd) {'D'}
    let(:teaching_classes) {[]}
    let(:fake_feed) do
      {
        teachingSemesters: [{
                              name: Berkeley::TermCodes.to_english(fake_term_yr, fake_term_cd),
                              slug: Berkeley::TermCodes.to_slug(fake_term_yr, fake_term_cd),
                              classes: teaching_classes
                            }]
      }
    end

    subject do
      Berkeley::Teaching.new(uid).merge_canvas_sites(fake_feed)
    end

    context 'with no Canvas account' do
      before {Canvas::Proxy.stub(:access_granted?).with(uid).and_return(false)}
      it 'quietly does nothing' do
        expect(subject).to eq fake_feed
      end
    end

    def it_is_a_normal_course_site_item(site)
      expect(site[:id]).to eq canvas_site_id
      expect(site[:emitter]).to eq Canvas::Proxy::APP_NAME
      expect(site[:name]).to eq canvas_site_base[:name]
      expect(site[:shortDescription]).to eq canvas_site_base[:shortDescription]
      expect(site[:siteType]).to eq 'course'
    end

    def it_is_a_linked_course_site_item(semester_role)
      sites = subject[semester_role].first[:classes].first[:class_sites]
      expect(sites).to have(1).item
      site = sites.first
      it_is_a_normal_course_site_item(site)
      expect(site[:sections].first[:ccn]).to eq ccn.to_s
    end

    context 'with Canvas course site memberships' do
      let(:canvas_site_id) { rand(99999).to_s }
      let(:canvas_site_base) do
        {
          id: canvas_site_id,
          site_url: "something/#{canvas_site_id}",
          name: "CODE #{ccn}",
          shortDescription: "A barrel of #{ccn} monkeys",
          term_yr: term_yr,
          term_cd: term_cd,
          emitter: Canvas::Proxy::APP_NAME
        }
      end
      let(:group_id) { rand(99999).to_s }
      let(:group_base) do
        {
          id: group_id,
          name: "Group #{group_id}",
          site_url: "somewhere/#{group_id}",
          emitter: Canvas::Proxy::APP_NAME
        }
      end
      before { Canvas::Proxy.stub(:access_granted?).with(uid).and_return(true) }
      before { Canvas::MergedUserSites.stub(:new).with(uid).and_return(double(get_feed: canvas_sites)) }

      context 'when the Canvas site has an academic term' do
        let(:term_yr) {fake_term_yr}
        let(:term_cd) {fake_term_cd}
        context 'when the Canvas course site matches a campus section' do
          let(:canvas_site) {canvas_site_base.merge({sections: [{ccn: ccn.to_s}]})}
          let(:canvas_sites) {{courses: [canvas_site], groups: []}}
          context 'when the user is an instructor' do
            let(:teaching_classes) {[campus_course_base]}
            it 'includes the site in the campus class item' do
              it_is_a_linked_course_site_item(:teachingSemesters)
            end

            # By default, CCN strings are filled out to five digits by prefixing zeroes.
            # However, shorter strings should still match.
            context 'when the Canvas section CCN does not prefix zero' do
              let(:ccn_int) {rand(999)}
              let(:ccn) {"00#{ccn_int}"}
              let(:canvas_site) {canvas_site_base.merge({sections: [{ccn: ccn_int.to_s}]})}
              it 'points back to campus course' do
                it_is_a_linked_course_site_item(:teachingSemesters)
              end
            end

            context 'when the Canvas group site links to a matching course site' do
              let(:group) {group_base.merge(course_id: canvas_site_id)}
              let(:canvas_sites) {{courses: [canvas_site], groups: [group]}}
              it 'is included with the campus course' do
                sites = subject[:teachingSemesters].first[:classes].first[:class_sites]
                expect(sites).to have(2).items
                site = sites.select{|s| s[:siteType] == 'group'}.first
                expect(site[:id]).to eq group_id
                expect(site[:emitter]).to eq Canvas::Proxy::APP_NAME
                expect(site[:name]).to eq group_base[:name]
                expect(site[:siteType]).to eq 'group'
                expect(site[:source]).to eq canvas_site_base[:name]
              end
            end
          end

          context 'when campus courses include multiple primaries' do
            let(:teaching_classes) {[campus_course_multiple_primaries_base]}
            it 'includes the site in the campus class item' do
              it_is_a_linked_course_site_item(:teachingSemesters)
            end
            it 'links the site to the correct primary section' do
              course = subject[:teachingSemesters].first[:classes].first
              site = course[:class_sites].first
              expect(course[:sections][0][:siteIds]).to eq [site[:id]]
              expect(course[:sections][1][:siteIds]).to eq nil
            end
          end
        end
      end

      context 'when the Canvas site does not take place in an academic term' do
        let(:term_yr) { nil }
        let(:term_cd) { nil }
        let(:canvas_sites) { {courses: [canvas_site_base], groups: []} }
        it 'does not belong in this list' do
          expect(subject).to eq fake_feed
        end
      end

    end

  end

end
