class CreateAuthorizations < ActiveRecord::Migration[6.1]
  def change
    create_table :authorizations, id: :uuid do |t|
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid
      t.string :collection

      t.timestamps
    end
  end
end
