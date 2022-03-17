class CreateStaffActions < ActiveRecord::Migration[6.1]
  def change
    create_table :staff_actions, id: :uuid do |t|
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid
      t.string :type, null:false

      t.timestamps
    end
  end
end
