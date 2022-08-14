module StaffTracker::Recorder

  def record_action(action , model_name , model_id)
    StaffTrackerRecorderJob.perform_later(
      user_id: Current.user.id,
      action: action, 
      model_name: model_name, 
      model_id: model_id
    )
  end
end