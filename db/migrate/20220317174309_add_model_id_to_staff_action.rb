class AddModelIdToStaffAction < ActiveRecord::Migration[6.1]
  def change
    add_column :staff_actions, :model_id, :string, null:false
  end
end
