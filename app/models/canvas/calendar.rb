module Canvas
  class Calendar < Proxy

    def course_appointment_groups(canvas_course_id, scope='reservable')
      request_params = {
        'scope' => scope,
        'context_codes[]' => "course_#{canvas_course_id}",
        'include_past_appointments' => true
      }
      response = paged_get "appointment_groups", request_params
      response[:body]
    end

    def course_calendar_events(canvas_course_id)
      request_params = {
        'context_codes[]' => "course_#{canvas_course_id}",
        'all_events' => true
      }
      response = paged_get "calendar_events", request_params
      response[:body]
    end

  end
end
