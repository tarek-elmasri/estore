class Errors::BlockedUser < Errors::CustomError

  def initialize
    super(
      "errors.authorization.blocked_user",
      "UA412",
      "401"
    )
  end
end