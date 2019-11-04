class AddCanvasWhitelist < ActiveRecord::Migration
  def change
    remove_column :user_auths, :is_author
    add_column :user_auths, :is_canvas_whitelisted, :boolean, null: false, default: false
  end
end
