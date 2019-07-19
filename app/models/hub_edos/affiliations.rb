module HubEdos
  class Affiliations < Student
    include HubEdos::CachedProxy
    include Cache::UserCacheExpiry

    def url
      "#{@settings.base_url}/#{@campus_solutions_id}/affiliation"
    end

    def mock_request
      # TODO We currently force the HubEdos integration through a UID-to-CSID translation, and we don't have LDAP
      # fixtures to support that. That should be remedied as part of the V2 transition.
      super.merge(uri_matching: "#{@settings.base_url}/.*/affiliation")
    end

    def json_filename
      'hub_affiliations.json'
    end

    def whitelist_fields
      %w(affiliations identifiers confidential)
    end

  end
end
