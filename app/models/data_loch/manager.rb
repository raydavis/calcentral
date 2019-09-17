module DataLoch
  class Manager
    include ClassLogger

    def manage_terms_data(targets)
      # Decide which terms get the usual daily treatment:
      #   - If one month or less before the end of the current term, add the future term (or terms, for Spring)
      #   - If one month or less after the start of the current term, continue to include the previous term
      term_ids = get_daily_terms

      # Look at which term IDs are included in the latest 'daily' folder.

      # Any previous terms which need to move to the 'historical' folder?

      # Look at which term GPAs are included in the 'gpa' folder.

      # Any previous terms which need an upload_term_gpas run?

      # Check for S3 moves:
      #   - If one month or more after the start of the current term, check S3 storage locations.
      #     - If previous term's courses/enrollments data is in 'daily', move it to 'historical'.
      #     - If previous term's GPA data is not in s3://la-nessie-*/sis-data/historical/gpa,
      #       run upload_term_gpas.

      # Kick off usual nightly snapshot.
    end

    def get_retiring_term_snapshots(target, current_term_ids)
      retiring = []
      oldest_term_id = current_term_ids.min
      terms_snapshots = get_newest_s3_snapshots(target)
      terms_snapshots.each do |term_id, snapshots|
        if term_id < oldest_term_id
          retiring << {term_id: term_id, paths: snapshots}
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
      latest_snapshots = daily_hash[latest]

      # What terms does it contain?
      terms_hash = latest_snapshots.each_with_object(Hash.new {|h, k| h[k] = []}) do |fn, hsh|
        term_id = /-(\d{4})\.gz/.match(fn)[1]
        hsh[term_id] << fn
      end
      terms_hash
    end

    def get_daily_terms()
      today = Settings.terms.fake_now || DateTime.now
      term_ids = []
      terms = Berkeley::Terms.fetch
      # If we are between terms, 'current' is set to the upcoming term, and so its start date may be in the future.
      current_term = terms.current

      # If today is one month or less after the start of the current term, continue to include the previous term,
      # so that we can pick up any changes in final grades and GPAs.
      if current_term.start.advance(weeks: 4) > today
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
