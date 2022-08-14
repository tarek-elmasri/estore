class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name , :last_name, 
              :email, :phone_no, :gender, :dob, 
              :rule, :city, :avatar

  
  has_one :authorization, serializer: Dashboard::AuthorizationSerializer
  has_one :cart

  def avatar
    object.avatar_data
  end
end
