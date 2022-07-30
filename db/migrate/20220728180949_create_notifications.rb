class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.string  :msg_type, null: false
      t.boolean :seen, default: false
      t.uuid  :notifiable_id, null:false
      t.string  :notifiable_type, null:false
      t.timestamps
    end

    add_index :notifications, [:notifiable_type, :notifiable_id]
  end
end
