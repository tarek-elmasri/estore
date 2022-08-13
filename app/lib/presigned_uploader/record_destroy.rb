class PresignedUploader::RecordDestroy < PresignedUploader::Base

  attr_accessor :attachment

  def initialize(attachment_id: , skip_authorization: false)
    self.attachment = ActiveStorage::Attachment.find_by(id: attachment_id)
    super(
      skip_authorization: skip_authorization
      record_type: attachment&.record_type,
      record_id: attachment&.record_id,
      field_name: attachment&.name
    )

  end

  def call
    check_authorization() unless skip_authorization
    
    raise ActiveRecord::RecordNotFound unless attachment

    attachment.purge_later

    StaffTracker::Recorder.record(
      :update,
      record.class.to_s.downcase,
      record.id
    ) unless skip_authorization


    return attachment
  end


end