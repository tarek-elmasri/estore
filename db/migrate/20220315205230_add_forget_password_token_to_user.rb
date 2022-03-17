class AddForgetPasswordTokenToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :forget_password_token, :string
    add_index :users, :forget_password_token, unique: true
  end
end
