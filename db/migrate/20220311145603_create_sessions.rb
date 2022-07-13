# class CreateSessions < ActiveRecord::Migration[6.1]
#   def change
#     create_table :sessions, id: :uuid do |t|
#       t.belongs_to :user, null: false, foreign_key: true, type: :uuid
#       t.string :version, null:false
#       t.timestamps
#     end
#   end
# end
