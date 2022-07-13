class Api::V1::Dashboard::AuthorizationsController < Api::V1::Dashboard::Base

  def update
    authorization = Authorization::AuthorizationUpdate.new(params.require(:user_id))
                                                      .update!(authorization_params)
    respond(
      serialize_resource(
        authorization,
        serializer: Dashboard::AuthorizationSerializer
      ).to_json
    )
  end

  private 

  def authorization_params
    params.require(:authorization).permit(*Authorization::TYPES)
  end

  
end