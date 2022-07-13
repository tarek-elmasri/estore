class AddPinnedToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :pinned, :boolean, default: false
  end
end
