module HubEdos
  class V2StudentsApi < BaseProxy

    include ClassLogger
    include Proxies::Mockable
    include User::Identifiers
    include SafeJsonParser

    APP_ID = 'integrationhub'
    APP_NAME = 'Integration Hub'

    def initialize(options = {})
      super(Settings.hub_edos_proxy, options)
      @sid = options[:sid]
      if @fake
        initialize_mocks
      end
    end

    def instance_key
      @sid
    end

    def mock_json
      read_file('fixtures', 'json', json_filename)
    end

    def mock_request
      super.merge(uri_matching: url)
    end

    def url
      "#{@settings.base_url}/#{@sid}"
    end

    def json_filename
      'hub_student_v2.json'
    end

    def get(opts = {})
      response = self.class.smart_fetch_from_cache(opts.merge(id: instance_key)) do
        get_internal
      end
      process_response_after_caching response
    end

    def process_response_after_caching(internal_response)
      if internal_response[:statusCode] >= 400 && !internal_response[:studentNotFound]
        internal_response[:errored] = true
      end
      internal_response
    end

    def get_internal(opts = {})
      logger.info "Fake = #{@fake}; Making request to #{url} on behalf of CS ID #{@sid}; cache expiration #{self.class.expires_in}"
      opts = opts.merge(request_options)
      response = get_response(url, opts)
      logger.debug "Remote server status #{response.code}, Body = #{response.body.force_encoding('UTF-8')}"
      if response.code == 404
        description = response.fetch('apiResponse', {}).fetch('httpStatus', {}).fetch('description', nil)
        # The V2 Students API only responds to CS IDs for known students, and so 'Not Found' is no longer a
        # condition rare enough to be worth logging.
        if description == 'Not Found'
          feed = {}
          student_not_found = true
        else
          logger.error "Unexpected 404 response for Campus Solutions ID #{@sid}: #{response}"
          feed = {}
        end
     else
        wrapped_feed = parse_response response
        feed = wrapped_feed.fetch('apiResponse', {}).fetch('response', {})
      end
      {
        statusCode: response.code,
        feed: feed,
        studentNotFound: student_not_found
      }
    end

    def request_options
      opts = {
        headers: {
          'Accept' => 'application/json'
        },
        on_error: {
          rescue_status: 404
        },
        query: {
          'inc-cntc' => true
        }
      }

      if @settings.app_id.present? && @settings.app_key.present?
        # app ID and token are used on the prod/staging Hub servers
        opts[:headers]['app_id'] = @settings.app_id
        opts[:headers]['app_key'] = @settings.app_key
      else
        # basic auth is used on Hub dev servers
        opts[:basic_auth] = {
          username: @settings.username,
          password: @settings.password
        }
      end
      opts
    end

    def parse_response(response)
      safe_json response.body.force_encoding('UTF-8')
    end

  end
end

