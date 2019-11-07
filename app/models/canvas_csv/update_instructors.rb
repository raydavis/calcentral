module CanvasCsv
  class UpdateInstructors < Base

    # Performs Canvas import of updated instructor assignments.
    # The job should not be run more than once-per-hour, since each run might download full lists of
    # Canvas site sections for multiple terms.
    def run
      current_time = Time.now.utc

      # Guard against nil columns.
      last_sync = [Synchronization.get.last_instructor_sync, 1.days.ago].compact.max
      logger.warn "Querying SISEDO for instructor updates since #{last_sync.utc}"

      # Loop around currently-maintained terms.

      # Download latest list of Canvas site sections for matching terms.

    end

  end
end
