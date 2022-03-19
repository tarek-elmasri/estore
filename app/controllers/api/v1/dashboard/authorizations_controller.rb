class Api::V1::Dashboard::AuthorizationsController < Api::V1::Dashboard::Base

  before_action :authorize_update
  before_action :set_records
  before_action :check_user_rule

  def update 
    return kill_authorization if params[:rule] == "user"

    Authorization.transaction do
      @user.update!(rule: params[:rule])
      @auth.update!(authorization_params) 
      Current.user.staff_actions.create(type: :update_authorization , model: :user , model_id: @user.id )
    end

    respond({rule: @user.rule, user_id: @user.id, authorization: @auth })

    rescue ActiveRecord::RecordInvalid => e
      respond_unprocessable(e.message)
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

  def check_user_rule
    # rule parameter is available
    unless params[:rule] || User::DEFAULT_RULES.include?(params[:rule])
      respond_unprocessable({rule: I18n.t('errors.authorization.invalid_rule')})
    end
  end
  
  def kill_authorization    
    @user.update(rule: "user")
    @user.authorization&.destroy
    Current.user.staff_actions.create(type: :update_authorization, model: :user , model_id: @user.id)
    respond({rule: "user"})
  end
  
end