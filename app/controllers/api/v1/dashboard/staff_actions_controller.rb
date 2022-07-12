class Api::V1::Dashboard::StaffActionsController < Api::V1::Dashboard::Base

  has_scope :paginate, using: %i[page per], type: :hash, allow_blank: true
  has_scope :action_type
  has_scope :model_type_name, as: :model_name
  has_scope :of_model_id, as: :model_id
  has_scope :by_user_id
  has_scope :order_by_recent, type: :boolean, default: true
  has_scope :of_ids, as: :id
  
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