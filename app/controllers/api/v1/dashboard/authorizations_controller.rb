class Api::V1::Dashboard::AuthorizationsController < Api::V1::Dashboard::Base
  before_action :set_records

  def update
    @auth.update!(authorization_params)
  end

  private 

  def set_records
    @auth = Authorization.where(user_id: params[:user_id]).first_or_initialize
  end

  def authorization_params
    params.require(:authorization).permit(* Authorization::TYPES)
  end
#   before_action :authorize_update
#   before_action :set_records
#   before_action :check_user_rule

#   def update 
#     if params[:rule]== "user"
#       return kill_authorization if params[:rule] == "user"
#     elsif params[:rule] == "admin"
#       return admin_authorization if params[:rule] == "admin"
#     elsif params[:rule] == "staff"
#       return staff_authorization if params[:rule] == "staff"
#     end
#   end

#   private
#   def authorization_params
#     params.require(:authorization).permit( *Authorization::TYPES)
#   end

#   def set_records
#     @user = User.find(params[:user_id])
#     @auth = Authorization.where(user_id: params[:user_id]).first_or_initialize
#   end

#   def authorize_update
#     return respond_forbidden unless Current.user.is_authorized_to_update_authorization?
#   end

#   def check_user_rule
#     # rule parameter is available
#     unless params[:rule] || User::DEFAULT_RULES.include?(params[:rule])
#       respond_unprocessable({rule: I18n.t('errors.authorization.invalid_rule')})
#     end
#   end
  
#   def kill_authorization    
#     @user.update(rule: "user")
#     @user.authorization&.destroy
#     Current.user.staff_actions.create(action: :update_authorization, model: :user , model_id: @user.id)
#     respond({rule: "user" , user_id: @user.id})
#   end

#   def admin_authorization
#     @user.update(rule: "admin")
#     @user.authorization&.destroy
#     Current.user.staff_actions.create(action: :update_authorization, model: :user ,model_id: @user.id )
#     respond({rule: :admin, user_id: @user.id})
#   end

#   def staff_authorization
#     Authorization.transaction do
#       @user.update!(rule: "staff")
#       @auth.update!(authorization_params) 
#       Current.user.staff_actions.create(action: :update_authorization , model: :user , model_id: @user.id )
#     end 

#     respond({rule: @user.rule, user_id: @user.id, authorization: @auth })

#     rescue ActiveRecord::RecordInvalid => e
#       respond_unprocessable(e.message)
#   end
  
end