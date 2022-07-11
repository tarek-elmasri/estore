class Interfaces::Categories::CategoryUpdate
  include StaffTracker::Recorder

  attr_reader :category

  def initialize category
    self.category = category
  end

  def update! params
    check_authorization
    category.update!(params)

    record(
      :update,
      "category",
      category.id
    )
    
    return category
  end

  private
  attr_writer :category

  def check_authorization
    raise Errors::Unauthorized unless Current.user.is_authorized_to_update_category?
end
