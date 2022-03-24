class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :name, null:false
      t.references :primary_category, foreign_ley: {to_table: :categories}, null: true, type: :uuid
      t.timestamps
    end
  end
end
