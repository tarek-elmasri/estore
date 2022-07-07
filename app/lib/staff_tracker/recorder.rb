module StaffTracker::Recorder

  def record(action , model_name , model_id)
    Current.user.staff_actions.new(
      action: action, 
      model: model_name, 
      model_id: model_id
    ).save
  end
end