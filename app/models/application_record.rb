class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :paginate, -> (page=1,per_page=25) {
    page(page).per(per_page)
  }
  scope :order_by_recent, -> { order(created_at: :desc)}
  scope :of_ids,-> (ids=[]) {where(id: ids)}

  scope :match_key_with_value, -> (key, value) {where(arel_table[key].matches("%#{value}%"))}
end
