class AddPinnedToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :pinned, :boolean, default: :false
  end
end
