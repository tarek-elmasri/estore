class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name , :last_name, :email, :phone_no, :gender, :dob, :rule

  has_one :cart
  has_one :authorization
  def cart
    {
      cart_items: ActiveModelSerializers::SerializableResource.new(@object.cart.cart_items)
    }
  end


end
