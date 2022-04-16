class Session < ApplicationRecord


  belongs_to :user
  validates :version, presence: true

  def self.kill_by_user_id user_id
    return unless user_id
    where(user_id: user_id).destroy_all
  end

  def self.find_by_id_and_version!(id,version)
    find_by!(id: id, version: version)
  end

  def self.create_or_update user_id
    return unless user_id
    Session.where(user_id: user_id).first_or_initialize
            .update!(version: APP_VERSION)
    # user_session = Session.where(user_id: user_id).first_or_initialize
    # user_session.version = APP_VERSION
    # user_session.save
  end
end
