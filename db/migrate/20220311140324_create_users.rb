class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :first_name , null:false
      t.string :last_name , null:false
      t.integer :phone_no , null:false
      t.string :email, null:false
      t.string :password_digest
      t.string :rule, default: "user"
      t.string :gender, null:false
      t.string :refresh_token
      t.date :dob
      t.string :city

      t.timestamps
    end
    add_index :users, :phone_no, unique: true
    add_index :users, :email, unique: true
  end
end
