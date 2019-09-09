class LegalstPlus < ActiveRecord::Migration
  def up
    if Oec::CourseCode.where(dept_code: 'LEGALST').count == 0
      update <<-SQL
        UPDATE oec_course_codes SET
          dept_code = 'LEGALST',
          include_in_oec = TRUE
          WHERE dept_name = 'LEGALST'
      SQL
      update <<-SQL
        UPDATE oec_course_codes SET
          dept_code = 'DBARC'
          WHERE dept_name = 'ENV DES'
      SQL
      update <<-SQL
        UPDATE oec_course_codes SET
          include_in_oec = TRUE
          WHERE dept_code = 'DBARC'
      SQL
      Oec::CourseCode.create(
        dept_code: 'UGIS',
        catalog_id: '189',
        dept_name: 'CALTEACH',
        include_in_oec: true
      )
    end
  end

  def down
    # Downgrades should be managed through ccadmin.
  end
end
