class Api::V1::Dashboard::UsersController < Api::V1::Dashboard::Base

  def index
    if Current.user.is_authorized_to_show_users?
      users= User.all
      respond({users: users})
    else
      respond_forbidden
    end
  end


  

end