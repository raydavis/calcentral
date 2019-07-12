module Webcast
  class Recordings < Proxy

    def get_json_path
      'warehouse/webcast.json'
    end

    def request_internal
      return {} unless Settings.features.videos

      recordings = {
        courses: {}
      }
      response = get_json_data['courses']
      # This code works for bCourses integration, but for SIS CalCentral some extra mapping was necessary to
      # support pre-CS Course Captures: https://github.com/ets-berkeley-edu/calcentral/pull/6630 and 7533
      response.each do |course|
        year = course['year']
        semester = course['semester']
        ccn = course['ccn']
        if year && semester && ccn
          key = Webcast::CourseMedia.id_per_ccn(year, semester, course['ccn'])
          recordings[:courses][key] = {
            recordings: course['recordings'],
            youtube_playlist: course['youTubePlaylist']
          }
        end
      end
      recordings
    end

  end
end
