module CanvasCsv
  # Provides object used to store synchronization states between campus systems and Canvas
  class Synchronization < ActiveRecord::Base
    include ActiveRecordHelper
    include ClassLogger

    self.table_name = 'canvas_synchronization'
    attr_accessible :last_guest_user_sync
    attr_accessible :latest_term_enrollment_csv_set

    # Returns single record used to store synchronization timestamp(s)
    def self.get
      count = self.count
      if count == 0
        logger.warn 'Creating initial Canvas synchronization record'
        self.create(:last_guest_user_sync => 1.days.ago.utc)
      elsif count > 1
        raise RuntimeError, 'Canvas synchronization data has more than one record!'
      end
      self.first
    end
  end
end
