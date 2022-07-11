class ItemCategory < ApplicationRecord
  #include StaffTracker::Model

  belongs_to :item
  belongs_to :category
end
