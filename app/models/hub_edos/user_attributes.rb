module HubEdos
  class UserAttributes

    include User::Identifiers
    include Berkeley::UserRoles
    include ResponseWrapper
    include ClassLogger

    def initialize(options = {})
      @campus_solutions_id = options[:sid]
    end

    def self.test_data?
      Settings.hub_edos_proxy.fake.present?
    end

    def get
      wrapped_result = handling_exceptions(@campus_solutions_id) do
        edo = get_edo_feed
        result = get_ids edo
        if result
          extract_roles(edo, result)
          extract_passthrough_elements(edo, result)
          extract_names(edo, result)
          extract_emails(edo, result)
          result[:statusCode] = 200
        else
          logger.warn "Could not get Student EDO data for SID #{@campus_solutions_id}"
          result[:noStudentId] = true
        end
        result
      end
      wrapped_result[:response]
    end

    def get_ids(edo)
      identifiers = edo[:identifiers]
      if identifiers.blank?
        logger.error "No 'identifiers' found in CS attributes #{edo} for CS ID #{@campus_solutions_id}"
        {}
      else
        student_id = identifiers.select {|id| id[:type] == 'student-id'}.first
        if student_id.blank?
          logger.error "No 'student-id' found in CS Identifiers #{identifiers} for CS ID #{@campus_solutions_id}"
        else
          student_id = student_id[:id]
        end
        campus_uid = identifiers.select {|id| id[:type] == 'campus-uid'}.first
        if campus_uid.blank?
          logger.error "No 'campus-uid' found in CS Identifiers #{identifiers} for CS ID #{@campus_solutions_id}"
        else
          campus_uid = campus_uid[:id]
          @uid = campus_uid
        end
        {
          campus_solutions_id: student_id,
          ldap_uid: campus_uid
        }
      end
    end

    def get_edo_feed
      response = V2StudentsApi.new(sid: @campus_solutions_id).get
      if (feed = HashConverter.symbolize response[:feed])
        feed
      else
        nil
      end
    end

    def identifiers_check(edo)
      # CS Identifiers simply treat 'student-id' as a synonym for the Campus Solutions ID / EmplID, regardless
      # of whether the user has ever been a student. (In contrast, CalNet LDAP's 'berkeleyedustuid' attribute
      # only appears for current or former students.)
      identifiers = edo[:identifiers]
      if identifiers.blank?
        logger.error "No 'identifiers' found in CS attributes #{edo} for UID #{@uid}, CS ID #{@campus_solutions_id}"
      else
        edo_id = identifiers.select {|id| id[:type] == 'student-id'}.first
        if edo_id.blank?
          logger.error "No 'student-id' found in CS Identifiers #{identifiers} for UID #{@uid}, CS ID #{@campus_solutions_id}"
          return false
        elsif edo_id[:id] != @campus_solutions_id
          logger.error "Got student-id #{edo_id[:id]} from CS Identifiers but CS ID #{@campus_solutions_id} from Crosswalk for UID #{@uid}"
        end
      end
    end

    def extract_passthrough_elements(edo, result)
      [:names, :emails].each do |field|
        if edo[field].present?
          result[field] = edo[field]
        end
      end
    end

    def extract_names(edo, result)
      # preferred name trumps primary name if present
      find_name('PRI', edo, result) unless find_name('PRF', edo, result)
    end

    def find_name(type, edo, result)
      found_match = false
      if edo[:names].present?
        edo[:names].each do |name|
          if name[:type].present? && name[:type][:code].present?
            if name[:type][:code].upcase == 'PRI'
              result[:given_name] = name[:givenName]
              result[:family_name] = name[:familyName]
            end
            if name[:type].present? && name[:type][:code].present? && name[:type][:code].upcase == type.upcase
              result[:first_name] = name[:givenName]
              result[:last_name] = name[:familyName]
              result[:person_name] = name[:formattedName]
              found_match = true
            end
          end
        end
      end
      found_match
    end

    def extract_roles(edo, result)
      # CS Affiliations are expected to exist for any working CS ID.
      if (affiliations = edo[:affiliations])
        result[:roles] = roles_from_cs_affiliations(affiliations)
        if result[:roles].slice(:student, :exStudent, :applicant, :releasedAdmit).has_value?(true)
          result[:student_id] = @campus_solutions_id
        end
        result[:roles][:confidential] = true if edo[:confidential]
      else
        logger.error "No 'affiliations' found in CS attributes #{edo} for UID #{@uid}, CS ID #{@campus_solutions_id}"
      end
    end

    def extract_emails(edo, result)
      if edo[:emails].present?
        edo[:emails].each do |email|
          if email[:primary] == true
            result[:email_address] = email[:emailAddress]
          end
          if email[:type].present? && email[:type][:code] == 'CAMP'
            result[:official_bmail_address] = email[:emailAddress]
          end
        end
      end
    end

  end
end
