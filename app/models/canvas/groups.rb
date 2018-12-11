module Canvas
  class Groups < Proxy

    include Cache::UserCacheExpiry

    def groups
      self.class.fetch_from_cache(@uid) do
        paged_get request_path, as_user_id: "sis_login_id:#{@uid}"
      end
    end


    def course_groups(course_id)
      response = paged_get "courses/#{course_id}/groups"
      response[:body]
    end

    def group_memberships(group_id)
      response = paged_get "groups/#{group_id}/memberships"
      response[:body]
    end

    def create_membership(group_id, user_id)
      request_params = {
        'user_id' => user_id
      }
      wrapped_post "groups/#{group_id}/memberships", request_params
    end


    private

    def mock_json
      read_file('fixtures', 'json', 'canvas_groups.json')
    end

    def request_path
      'users/self/groups'
    end
  end
end
