class Api::Vi::Dashboard:AuthorizationsController < Api::V1::Dashboard::Base

  before_action :authorize_create, only: [:create]
  before_action :authorize_delete, only: [:destroy]

  def create
    auth = Authorization.new(authorization_params)

    if auth.save
      Current.user.staff_actions.create(type: :create_authorization , model: :user , model_id: authorization_params[:user_id])
      respond({authorization: auth})
    else
      respond_unprocessable(auth.errors)
    end
  end

  def destroy
    if @auth.destroy
      Current.user.staff_actions.create(type: :delete_authorization , model: :user , model_id: params[:id])
      respond_ok()
    else
      respond_unprocessable(@auth.errors)
    end
  end

  private
  def authorization_params
    params.require(:authorization).permit(:user_id,:type)
  end

  def authorize_create
    respond_forbidden unless Current.user.is_authorized_to_create_authorization?
  end

  def authorize_delete
    return respond_forbidden unless Current.user.is_authorized_to_delete_authorization?
    @auth = Authorization.find_by_id(params[:id])
    return respond_not_found unless @auth

  end

end