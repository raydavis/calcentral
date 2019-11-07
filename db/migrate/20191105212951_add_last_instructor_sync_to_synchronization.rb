class AddLastInstructorSyncToSynchronization < ActiveRecord::Migration
  def change
    add_column :canvas_synchronization, :last_instructor_sync, :datetime
  end
end
