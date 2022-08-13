class PresignedUploader::RecordUpdate < PresignedUploader::Base
  attr_accessor :skip_authorization, :signed_id

  def initialize(record_id: , record_type: , field_name:, signed_id:, skip_authorization: false)
    super(record_id: record_id, record_type: record_type, field_name: field_name, skip_authorization: skip_authorization)
    self.signed_id = signed_id
    self.skip_authorization = skip_authorization
  end

  def call()
    check_authorization() unless skip_authorization
    raise ActiveRecord::RecordInvalid.new(record) unless valid?

    begin
      record.send("#{field_name}").attach(signed_id)  
      record.save!

      StaffTracker::Recorder.record(
        :update,
        record.class.to_s.downcase,
        record.id
      ) unless skip_authorization

      return record
    rescue ActiveStorage::FileNotFoundError => e
      record.errors.add(:signed_id, I18n.t('presigned_uploader.file_not_found'))
      raise ActiveRecord::RecordInvalid.new(record)
    end

  end

  def valid?
    self.errors = {}
    validate_standard_validators
    validate_presence_of_blob

    if record.errors.any?
      return false
    else
      return true
    end
    
  end


  private
  def validate_presence_of_blob
    return unless valid_field_name?
    blob = ActiveStorage::Blob.find_signed(signed_id)
    record.errors.add(:signed_id, I18n.t('presigned_uploader.blob_must_exist'))  unless blob
  end


end