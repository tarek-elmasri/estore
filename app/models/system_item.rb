class SystemItem < ApplicationRecord
  self.table_name = 'items'

  def eleminate_stock

  end

  def is_card?
    type_name == 'card'
  end
end