module CanvasCsv
  class UpdateGuests < Base

    # Performs Canvas import of updated guest users
    def run
      sync_settings = Synchronization.get
      current_time = Time.now.utc
      logger.warn "Querying LDAP for guest updates since #{sync_settings.last_guest_user_sync.utc}"
      guests = CalnetLdap::Client.new.guests_modified_since sync_settings.last_guest_user_sync
      if guests.any?
        user_csv_rows = prepare_guest_user_csv_rows guests
        logger.warn "Sending SIS Import for #{user_csv_rows.count} guest users to Canvas"
        import_guests user_csv_rows
      else
        logger.warn 'No updates to import'
      end
      Synchronization.get.update(last_guest_user_sync: current_time)
      logger.warn "Guest synchronization completed for #{current_time} at #{Time.now.utc.to_s}"
    end

    # Transforms guest user array into data structure intended for Canvas CSV Import
    def prepare_guest_user_csv_rows(ldap_guests)
      ldap_guests.map { |guest| sis_csv_user_from_ldap_guest guest }
    end

    def sis_csv_user_from_ldap_guest(ldap_user)
      {
        'user_id' => "UID:#{ldap_user[:uid][0]}",
        'login_id' => ldap_user[:uid][0].to_s,
        'password' => nil,
        'first_name' => ldap_user[:givenname][0],
        'last_name' => ldap_user[:sn][0],
        'email' => ldap_user[:mail][0],
        'status' => 'active'
      }
    end

    def import_guests(canvas_user_rows)
      csv_filename = "#{@export_dir}/guest_user_provision-#{DateTime.now.strftime('%F')}-#{SecureRandom.hex(8)}-users.csv"
      # 'user_id,login_id,first_name,last_name,email,status'
      guest_users_csv_file = make_users_csv(csv_filename, canvas_user_rows)
      response = Canvas::SisImport.new.import_users guest_users_csv_file
      if response.blank?
        logger.error "Guest users did not import from #{guest_users_csv_file}"
        raise RuntimeError, 'Guest user import failed.'
      else
        logger.warn "Successfully imported guest users from: #{guest_users_csv_file}"
      end
    end

  end
end
