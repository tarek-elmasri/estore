class Session < ApplicationRecord
  belongs_to :user

  def self.kill_by_user_id user_id
    where(user_id: user_id).delete_all
  end

  def self.find_by_id_and_version(id,version)
    find_by(id: id, version: version)
  end

  def self.create_or_update user_id
    user_session = Session.where(user_id: user_id).first_or_initialize
    user_session.version = APP_VERSION
    user_session.save
  end
end
