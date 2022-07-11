class Api::V1::Dashboard::AuthorizationsController < Api::V1::Dashboard::Base
  #before_action :set_records, except: [:index]

  def update
    authorization = Authorization::AuthorizationUpdate.new(params.require(:user_id))
                                                      .update!(authorization_params)
    #@auth.update!(authorization_params)
    respond(
      serialize_resource(
        authorization,
        serializer: Dashboard::AuthorizationSerializer
      ).to_json
    )
  end

  private 

  # def set_records
  #   @auth = Authorization.where(user_id: params.require(:user_id)).first_or_initialize
  # end

  def authorization_params
    params.require(:authorization).permit(*Authorization::TYPES)
  end

  
end