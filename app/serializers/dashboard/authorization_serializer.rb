class Dashboard::AuthorizationSerializer < ActiveModel::Serializer

  attributes *Authorization::TYPES

end