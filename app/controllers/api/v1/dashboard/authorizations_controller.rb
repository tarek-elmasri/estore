class Api::V1::Dashboard::AuthorizationsController < Api::V1::Dashboard::Base
  before_action :set_records, except: [:index]

  def update
    @auth.update!(authorization_params)
    respond({authorization: serialize_resource(
      @auth,
      serializer: Dashboard::AuthorizationSerializer
    )})
  end

  private 

  def set_records
    @auth = Authorization.where(user_id: params.require(:user_id)).first_or_initialize
  end

  def authorization_params
    params.require(:authorization).permit(*Authorization::TYPES)
  end

  
end