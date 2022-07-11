class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :paginate, -> (page=1,per_page=20) {
    page(page).per(per_page)
  }


end
