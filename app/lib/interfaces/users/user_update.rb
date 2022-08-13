class Interfaces::Users::UserUpdate
  include StaffTracker::Recorder

  attr_reader :user

  def initialize user
    self.user=user
  end

  def update! params
    authorize_update()
    authorize_rule_update(params[:rule])
    authorize_status_update(params[:status])
    User.transaction do
      user.update!(params)
      destroy_authorizations if user.is_admin? || user.is_user?
    end
  
    staff_recorder()

    return user
  end

  def data_for_avatar_upload(filename: , checksum: , byte_size: , content_type: )
    authorize_update()

    PresignedUploader::Service.new(
      field_name: :avatar,
      record_id: user.id,
      record_type: :user,
      filename: filename,
      checksum: checksum,
      byte_size: byte_size,
      content_type: content_type,
      skip_authorization: true
    ).call

  end

  def update_avatar!(signed_id)

    authorize_update()
    PresignedUploader::RecordUpdate.new(
      record_id: user.id,
      record_type: :user,
      field_name: :avatar,
      signed_id: signed_id,
      skip_authorization: true
    ).call
    staff_recorder()
    return user.reload
  end

  def destroy_avatar!
    authorize_update()

    PresignedUploader::RecordDestroy.new(
      attachment_id: user.avatar.attachment.id,
      skip_authorization: true
    ).call

    staff_recorder()
    return user.reload
  end

  private
  attr_writer :user

  def staff_recorder
    if updated_by_staff?
      record(
        :update,
        "user",
        user.id
      )
    end
  end

  def authorize_update
    raise Errors::Unauthorized unless Current.user.id == user.id || Current.user.is_authorized_to_update_user?
  end

  def rule_changed? rule
    return false unless rule
    return false if user.rule == rule
    true
  end

  def authorize_rule_update(rule)
    if rule_changed?(rule)
      #have authorization to update rule
      raise Errors::Unauthorized unless Current.user.is_authorized_to_update_authorization?
      # staff account cant change rule of an admin
      raise Errors::Unauthorized if user.is_admin? && Current.user.is_staff?
      # staff account cant raise his rule to an admin
      raise Errors::Unauthorized if rule == "admin" && Current.user.is_staff?
    end
  end

  def authorize_status_update status
    return unless status
    unless status == user.status
      raise Errors::Unauthorized unless Current.user.is_authorized_to_update_user_status?
    end
  end

  def destroy_authorizations
    user.authorization&.destroy
  end

  def updated_by_staff?
    Current.user.is_admin? || Current.user.is_staff?
  end


end