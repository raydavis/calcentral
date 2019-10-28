namespace :data_loch do

  def s3_targets
    targets = ENV['TARGETS']
    if targets.blank?
      Rails.logger.warn 'No TARGETS environment variable found - exiting.'
      abort 'Specify TARGETS as comma-separated names of S3 configurations.'
    else
      targets = targets.split(',')
    end
    return targets
  end

  desc 'Upload student-advisor and instructor-advisor relationship mappings to data loch S3'
  task :advisors => :environment do
    DataLoch::Stocker.new().upload_advisor_relationships(s3_targets)
  end

  desc 'Upload course, enrollment, and advisee data snapshots to data loch S3 (TERM_ID = 2XXX,2XXX...)'
  task :snapshot => :environment do
    targets = s3_targets
    term_ids = ENV['TERM_ID']
    advisee_data = []
    advisee_data.concat ['demographics'] if ENV['DEMOGRAPHICS']
    advisee_data.concat ['edw_demographics'] if ENV['EDW_DEMOGRAPHICS']
    advisee_data.concat ['intended_majors'] if ENV['INTENDED_MAJORS']
    advisee_data.concat ['socio_econ', 'applicant_scores'] if ENV['APPLICANT']
    if term_ids.blank? && advisee_data.blank?
      Rails.logger.error 'Neither TERM_ID nor any advisee field is specified. Nothing to upload.'
    end

    if term_ids == 'auto'
      DataLoch::Manager.new().manage_terms_data targets
    elsif term_ids.present?
      term_ids = term_ids.split(',')
      is_historical = ENV['HISTORICAL']
      DataLoch::Stocker.new().upload_term_data(term_ids, targets, is_historical)
    end

    if advisee_data.present?
      DataLoch::Stocker.new().upload_advisee_data(targets, advisee_data)
    end
  end

  desc 'Upload Term GPAs to data loch S3'
  task :term_gpas => :environment do
    term_id = ENV['TERM_ID']
    DataLoch::Stocker.new().upload_term_gpas(term_id, s3_targets)
  end

  desc 'Upload Term Definitions to data loch S3'
  task :term_definitions => :environment do
    DataLoch::Stocker.new().upload_term_definitions(s3_targets)
  end

  desc 'Upload list of undergraduate students to data loch S3'
  task :undergrads => :environment do
    DataLoch::Stocker.new().upload_undergrads(s3_targets)
  end

  desc 'Upload advising notes, topics, and attachment data to data loch S3'
  task :notes => :environment do
    DataLoch::Stocker.new().upload_advising_notes_data(s3_targets, ['notes', 'note-attachments'])
  end

  desc 'Check access to Data Loch S3'
  task :verify => :environment do
    DataLoch::Stocker.new().verify_endpoints(s3_targets)
  end

end
