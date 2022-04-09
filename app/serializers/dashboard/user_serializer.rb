class Dashboard::UserSerializer < ActiveModel::Serializer


  attributes :id, :first_name , :last_name, :email, :phone_no, :gender, :dob, :rule, :city
  
  has_one :authorization, serializer: Dashboard::AuthorizationSerializer

end