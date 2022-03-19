class Api::Vi::Dashboard:AuthorizationsController < Api::V1::Dashboard::Base

  before_action :authorize_update
  before_action :set_records

  def update
    Authorization.transaction do
      @user.rule = params[:rule]
      @user.save!
      @auth.update!(authorization_params)
      Current.user.staff_actions.create(type: :update_authorization , model: :authorization , model_id: @auth.id )
    end

    rescue ActiveRecord::RecordInvalid
      respond_unprocessable({user: @user.errors, authorization: @auth.errors})
  end

  private
  def authorization_params
    params.require(:authorization).permit( *Authorization::TYPES)
  end

  def set_records
    @user = User.find_by_id(params[:user_id])
    return respond_not_found unless @user
    @auth = Authorization.where(user_id: params[:user_id]).first_or_initialize
  end

  def authorize_update
    return respond_forbidden unless Current.user.is_authorized_to_update_authorization?
  end
  
end