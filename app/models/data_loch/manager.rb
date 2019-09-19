module DataLoch
  class Manager
    include ClassLogger

    def manage_terms_data(targets)
      # Decide which terms get the usual daily treatment.
      term_ids = get_daily_terms

      stocker = DataLoch::Stocker.new()

      # Which S3 targets have a term to move from daily to historical?
      moving_term_id, moving_targets = find_pending_transitions(targets, term_ids)

      if moving_term_id.present?
        # First, upload all of the retiring term's GPAs against all targets.
        stocker.upload_term_gpas(moving_term_id, targets)

        # Then move the now-historical snapshots from the S3 'daily' path.
        moving_targets.each do |moving_target, moving_snapshots|
          move_daily_snapshots_to_historical(moving_target, moving_snapshots)
        end
      end

      # Kick off usual nightly snapshot.
      stocker.upload_term_data(term_ids, targets)
    end

    def move_daily_snapshots_to_historical(s3_target, snapshots)
      s3 = DataLoch::S3.new(s3_target)
      snapshots.each do |from_path|
        path_end = /\/daily\/[^\/]+\/(.+)/.match(from_path)[1]
        to_path = "historical/#{path_end}"
        logger.warn "In S3 target #{s3_target}, moving #{from_path} to #{to_path}"
        s3.move(from_path, to_path)
      end
    end

    def find_pending_transitions(targets, term_ids)
      # Which S3 targets have a term to move from daily to historical?
      moving_term_id = nil
      moving_targets = {}

      targets.each do |target|
        terms_and_paths = get_retiring_term_snapshots(target, term_ids)
        if terms_and_paths.blank?
          next
        end
        if terms_and_paths.length > 1
          raise RuntimeError, "S3 target #{target} has more than one obsolete term in daily snapshots: #{terms_and_paths}"
        end
        if moving_term_id && (terms_and_paths.keys.first != moving_term_id)
          raise RuntimeError, "S3 targets #{targets} include more than one obsolete term in daily snapshots"
        end
        moving_term_id = terms_and_paths.keys.first
        moving_targets[target] = terms_and_paths[moving_term_id]
      end
      return moving_term_id, moving_targets
    end

    def get_retiring_term_snapshots(target, current_term_ids)
      oldest_term_id = current_term_ids.min
      latest_snapshots = get_newest_s3_snapshots(target)

      # What terms does it contain?
      retiring = latest_snapshots.each_with_object(Hash.new {|h, k| h[k] = []}) do |fn, hsh|
        term_id = /-(\d{4})\.gz/.match(fn)[1]
        if term_id < oldest_term_id
          hsh[term_id] << fn
        end
      end
      retiring
    end

    def get_newest_s3_snapshots(target)
      s3 = DataLoch::S3.new(target)
      all_dailies = s3.all_subpaths 'daily'

      # Find most recent daily folder.
      daily_hash = all_dailies.each_with_object(Hash.new {|h, k| h[k] = []}) do |fn, hsh|
        datestamp = /.+\/daily\/\w+-(\d{4}-\d{2}-\d{2})\//.match(fn)[1]
        hsh[datestamp] << fn
      end
      latest = daily_hash.keys().sort.reverse.first
      daily_hash[latest]
    end

    def get_daily_terms()
      today = Settings.terms.fake_now || DateTime.now
      term_ids = []
      terms = Berkeley::Terms.fetch
      # If we are between terms, 'current' is set to the upcoming term, and so its start date may be in the future.
      current_term = terms.current

      # If today is less than two weeks after the start of the current term, continue to include the previous term,
      # so that we can pick up any changes in final grades and GPAs.
      if current_term.start.advance(weeks: 2) > today
        term_ids << terms.previous.campus_solutions_id
      end

      term_ids << current_term.campus_solutions_id

      # If today is one month or less before the end of the current term, add the next term.
      if (current_term.end.advance(weeks: -4) < today) || current_term.is_summer
        term_ids << terms.next.campus_solutions_id
        # ... and if the upcoming term is Summer, add the next Fall term as well.
        if terms.next.is_summer
          term_ids << terms.future.campus_solutions_id
        end
      end

      term_ids
    end

  end
end
