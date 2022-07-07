class Interfaces::Items::ItemUpdate 
  include Interfaces::Items::ItemStockHandler
  include StaffTracker::Recorder

  attr_reader :item

  def initialize
    self.item = item
  end

  def update! params
    Item.transaction do
      self.item.update!(params)
      
    end
  end

  private
  attr_writer :item
end