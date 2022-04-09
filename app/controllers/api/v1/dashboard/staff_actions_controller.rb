class Api::V1::Dashboard::StaffActionsController < Api::V1::Dashboard::Base

  def index
    actions = StaffAction.all
    respond({
      staff_actions: serialize_resource(actions, each_serializer: Dashboard::StaffActionSerializer)
    })
  end

end