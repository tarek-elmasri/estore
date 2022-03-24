class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :name, null:false
      t.refrences :primary_category, foreign_ley: {to_table: :categories}, null: true
      t.timestamps
    end
  end
end
