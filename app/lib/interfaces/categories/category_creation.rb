class Interfaces::Categories::CategoryCreation
  include StaffTracker::Recorder

  attr_reader :category

  def initialize params
    self.category = Category.new(params)
  end

  def create!
    check_authorization
    category.save!

    record(
      :create,
      "category",
      category.id
    )
    
    return category
  end

  private
  attr_writer :category

  def check_authorization
    raise Errors::Unauthorized unless Current.user.is_authorized_to_create_category?
end
