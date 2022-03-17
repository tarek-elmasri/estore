class AddModelToStaffAction < ActiveRecord::Migration[6.1]
  def change
    add_column :staff_actions, :model, :string, null:false
  end
end
