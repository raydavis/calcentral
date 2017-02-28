namespace :database do

  def seeded?
    begin
      link_role = Links::UserRole.all.first
    rescue ActiveRecord::NoDatabaseError, ActiveRecord::StatementInvalid
    end
    if link_role.present?
      true
    else
      false
    end
  end

  task :create_if_necessary => :environment do
    if seeded?
      Rails.logger.warn 'Database has already been seeded, will not run db:setup.'
    else
      Rails.logger.warn 'Database does not exist or has not been seeded, running db:setup...'
      Rake::Task['db:schema:load'].invoke
      Rake::Task['db:seed'].invoke
    end
  end

end
