class FixTypeNameToAuthorization < ActiveRecord::Migration[6.1]
  def change
    rename_column :authorizations, :type, :collection
  end
end
