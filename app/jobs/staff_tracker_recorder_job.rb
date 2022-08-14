class StaffTrackerRecorderJob < ApplicationJob
  queue_as :default

  def perform(user_id: , action:  , model_name:  , model_id:)
    StaffAction.new(
      user_id: user_id,
      action: action, 
      model: model_name, 
      model_id: model_id
    ).save
  end
end
