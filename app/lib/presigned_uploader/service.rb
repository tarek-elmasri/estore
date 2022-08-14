
class PresignedUploader::Service < PresignedUploader::Base
  attr_accessor :filename , :checksum, :byte_size, :content_type

  DEFAULT_SERVICE_EXPIRE_TIME = 1.minute

  def initialize(filename: ,checksum: , byte_size: , content_type: ,
                  record_id: , record_type: , field_name: , skip_authorization: false)
    
    super(record_id: record_id, record_type: record_type, field_name: field_name, skip_authorization: skip_authorization)
    self.filename = filename
    self.checksum = checksum
    self.byte_size = byte_size
    self.content_type = content_type
  end

  def valid?
    self.errors = {}
    validate_standard_validators
    validate_content_type
    validate_byte_size

    if record.errors.any?
      return false
    else
      return true
    end
    
  end

  def call(expires_in: nil)
    check_authorization unless skip_authorization

    raise ActiveRecord::RecordInvalid.new(record) unless valid?
    
    blob= ActiveStorage::Blob.create_before_direct_upload!(
      key: "demo/#{ActiveStorage::Blob.generate_unique_secure_token}",
      filename: filename,
      checksum: checksum,
      content_type: content_type,
      byte_size: byte_size,
      metadata: {
        analyzed: true
      }
    )

    BlobsCleanupJob.set(wait: expires_in || DEFAULT_SERVICE_EXPIRE_TIME).perform_later(blob.id)

    return {
      url: blob.service_url_for_direct_upload(expires_in: expires_in || DEFAULT_SERVICE_EXPIRE_TIME),
      headers: blob.service_headers_for_direct_upload,
      signed_id: blob.signed_id
    }
  end

  private

  def accepted_content_types
    return unless valid_field_name?
    record.class.const_get("#{field_name.upcase}_ACCEPTED_CONTENT_TYPES")
  end

  def maximum_file_size
    return unless valid_field_name?
    record.class.const_get("#{field_name.upcase}_MAXIMUM_FILE_SIZE").to_i
  end

  def validate_byte_size
    return unless valid_field_name?

    if byte_size.to_i > maximum_file_size || byte_size.to_i == 0
      add_error(:byte_size, I18n.t("presigned_uploader.#{record.class.to_s.downcase}.byte_size"))
    end
  end

  def validate_content_type
    return unless valid_field_name?
    
    unless accepted_content_types.include?(content_type)
      add_error(:content_type, I18n.t("presigned_uploader.#{record.class.to_s.downcase}.content_type"))
    end
  end


end
