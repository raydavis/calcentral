module User
  class Api < UserSpecificModel
    include ActiveRecordHelper
    include Cache::CachedFeed
    include Cache::UserCacheExpiry
    # Needed to expire cache entries specific to Viewing-As users alongside original user's cache.
    include Cache::RelatedCacheKeyTracker
    include ClassLogger

    def init
      use_pooled_connection {
        @calcentral_user_data ||= User::Data.where(:uid => @uid).first
      }
      @user_attributes ||= User::AggregatedAttributes.new(@uid).get_feed
      @first_login_at ||= @calcentral_user_data ? @calcentral_user_data.first_login_at : nil
      @override_name ||= @calcentral_user_data ? @calcentral_user_data.preferred_name : nil
      self
    end

    def instance_key
      Cache::KeyGenerator.per_view_as_type @uid, @options
    end

    def preferred_name
      @override_name || @user_attributes[:defaultName] || ''
    end

    def preferred_name=(val)
      if val.blank?
        val = nil
      else
        val.strip!
      end
      @override_name = val
    end

    def save
      use_pooled_connection {
        Retriable.retriable(:on => ActiveRecord::RecordNotUnique, :tries => 5) do
          @calcentral_user_data = User::Data.where(uid: @uid).first_or_create do |record|
            logger.debug "Recording first login for #{@uid}"
            record.preferred_name = @override_name
            record.first_login_at = @first_login_at
          end
          if @calcentral_user_data.preferred_name != @override_name
            @calcentral_user_data.update_attribute(:preferred_name, @override_name)
          end
        end
      }
      Cache::UserCacheExpiry.notify @uid
    end

    def update_attributes(attributes)
      init
      if attributes.has_key?(:preferred_name)
        self.preferred_name = attributes[:preferred_name]
      end
      save
    end

    def record_first_login
      init
      @first_login_at = DateTime.now
      save
    end

    def has_campus_role?
      @user_attributes[:roles].values.any?
    end

    def super_user?
      authentication_state.policy.can_administrate?
    end

    def viewer?(current_user_policy)
      current_user_policy.can_view_as?
    end

    def has_dashboard_tab?
      has_campus_role? || super_user?
    end

    def has_toolbox_tab?(policy)
      return false unless authentication_state.directly_authenticated? && authentication_state.user_auth.active?
      policy.can_administrate? || authentication_state.real_user_auth.is_viewer?
    end

    def person_names
      given_first_name = @user_attributes[:givenFirstName]
      last_name = @user_attributes[:lastName]
      given_full_name = given_first_name + ' ' + @user_attributes[:familyName]
      first_name = @user_attributes[:firstName]
      full_name = first_name + ' ' + last_name
      preferred_name = self.preferred_name
      {
        first_name: first_name,
        last_name: last_name,
        full_name: full_name,
        given_first_name: given_first_name,
        given_full_name: given_full_name,
        preferred_name: preferred_name
      }
    end

    def first_login_at
      @first_login_at
    end

    def get_feed_internal
      names = person_names
      google_mail = User::Oauth2Data.get_google_email @uid
      current_user_policy = authentication_state.policy
      is_google_reminder_dismissed = User::Oauth2Data.is_google_reminder_dismissed(@uid)
      is_google_reminder_dismissed = is_google_reminder_dismissed && is_google_reminder_dismissed.present?
      has_student_history = User::HasStudentHistory.new(@uid).has_student_history?
      has_instructor_history = User::HasInstructorHistory.new(@uid).has_instructor_history?
      roles = @user_attributes[:roles]
      logger.error "UID #{@uid} has active student role but no CS ID" if @user_attributes[:campusSolutionsId].blank? && roles[:student] && !Berkeley::Terms.fetch.current.legacy?
      directly_authenticated = authentication_state.directly_authenticated?
      # This tangled logic is a historical artifact of divergent approaches to View-As and LTI-based authentication.
      acting_as_uid = directly_authenticated ? false : authentication_state.real_user_id
      {
        actingAsUid: acting_as_uid,
        campusSolutionsID: @user_attributes[:campusSolutionsId],
        firstLoginAt: first_login_at,
        firstName: names[:first_name],
        fullName: names[:full_name],
        givenFirstName: names[:given_first_name],
        givenFullName: names[:given_full_name],
        googleEmail: google_mail,
        hasDashboardTab: has_dashboard_tab?,
        hasGoogleAccessToken: GoogleApps::Proxy.access_granted?(@uid),
        hasInstructorHistory: has_instructor_history,
        hasStudentHistory: has_student_history,
        hasToolboxTab: has_toolbox_tab?(current_user_policy),
        isDirectlyAuthenticated: directly_authenticated,
        isGoogleReminderDismissed: is_google_reminder_dismissed,
        isLegacyStudent: @user_attributes[:isLegacyStudent],
        isSuperuser: super_user?,
        isViewer: viewer?(current_user_policy),
        lastName: names[:last_name],
        officialBmailAddress: @user_attributes[:officialBmailAddress],
        primaryEmailAddress: @user_attributes[:primaryEmailAddress],
        preferredName: names[:preferred_name],
        roles: roles,
        sid: @user_attributes[:studentId],
        uid: @uid
      }
    end

  end
end
