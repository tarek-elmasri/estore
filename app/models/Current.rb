class Current < ActiveSupport::CurrentAttributes
  attribute :user_id, :user , :rule, :token, :platform

  def web_platform?
    platform == "web"
  end
  
end