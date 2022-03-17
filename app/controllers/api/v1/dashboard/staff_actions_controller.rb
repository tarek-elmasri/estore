class Api::V1::Dashboard::StaffActionsController < Api::V1::Dashboard::Base

  def index
    actions = StaffActions.all
    respond({actions: actions})
  end

end