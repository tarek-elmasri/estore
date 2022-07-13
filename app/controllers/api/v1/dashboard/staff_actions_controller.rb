class Api::V1::Dashboard::StaffActionsController < Api::V1::Dashboard::Base
  include Scopes::Dashboard::StaffActionsScopes
  
  apply_controller_scopes only: [:index]

  def index
    actions = apply_scopes(StaffAction.include_user.page(1))

    respond({
      staff_actions: serialize_resource(
                        actions,
                        each_serializer: Dashboard::StaffActionSerializer
                      ),
      pagination_details: pagination_details(actions)
    })
  end

end