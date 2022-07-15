class Interfaces::Categories::CategoryDestroy
  include StaffTracker::Recorder

  attr_reader :category

  def initialize category
    self.category = category
  end

  def destroy!
    check_authorization
    category.destroy!

    record(
      :delete,
      "category",
      category.id
    )
    
    return category
  end

  private
  attr_writer :category

  def check_authorization
    raise Errors::Unauthorized unless Current.user.is_authorized_to_delete_category?
  end
end
