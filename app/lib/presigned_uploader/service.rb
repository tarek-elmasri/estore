class PresignedUploader::Service

  attr_accessor :field_name, :record , :filename , :checksum, :byte_size, :content_type
  
  def initialize(name: , record_id: , record_type: , filename: , checksum: , byte_size: , content_type: )
    #self.field_name = name
    #self.errors={}
    self.filename = filename
    self.checksum = checksum
    self.byte_size = byte_size
    self.content_type = content_type
    begin
      self.record = ActiveStorage::Attachment.new(
                      name: name, record_id: record_id, record_type: record_type&.to_s.capitalize
                    ).record
    rescue 
      self.record= nil
    end
    self.field_name = name
    #raise ActiveRecord::RecordNotFound unless record
    # raise error if record doesnt respond to name
  end

  def valid?
    self.errors = {}
    validate_record
    validate_field_name
    validate_inclusion_of_model_class
    validate_content_type
    validate_byte_size

    if errors.any?
      record.errors.add(field_name, errors)
      return false
    else
      return true
    end
    
  end

  def service_url_for_direct_upload
    raise ActiveRecord::RecordInvalid.new(record) unless valid?
    blob= ActiveStorage::Blob.create_before_direct_upload!(
      filename: filename,
      checksum: checksum,
      content_type: content_type,
      byte_size: byte_size
    )

    return {
      url: blob.service_url_for_direct_upload(expires_in: 30.minutes),
      headers: blob.service_headers_for_direct_upload,
      signed_id: blob.signed_id
    }
  end

  #private
  attr_accessor :errors


  def accepted_content_types
    return unless valid_field_name?
    record.class.const_get("#{field_name.upcase}_ACCEPTED_CONTENT_TYPES")
  end

  def maximum_file_size
    return unless valid_field_name?
    record.class.const_get("#{field_name.upcase}_MAXIMUM_FILE_SIZE").to_i
  end

  def add_error(field, msg)
    errors[field] ?
      errors[field].push(msg) : errors[field] = [msg]
  end

  def validate_record
    return if record
    raise ActiveRecord::RecordNotFound
  end

  def valid_field_name?
    return true if field_name && record.respond_to?(field_name)
    false
  end

  def validate_field_name
    return if valid_field_name?
    add_error(field_name, I18n.t("errors.validations.#{record.class.to_s.downcase}.invalid_field_name_for_upload"))
  end

  def validate_inclusion_of_model_class
    return unless valid_field_name?

    return if (record.class.constants.include?("#{field_name.upcase}_MAXIMUM_FILE_SIZE".to_sym)) &&
                  (record.class.constants.include?("#{field_name.upcase}_ACCEPTED_CONTENT_TYPES".to_sym))
    
    raise ArgumentError.new("PresignedUploader::Model is not included in #{record.class.to_s.capitalize} class")
  end

  def validate_byte_size
    return unless valid_field_name?

    if byte_size.to_i > maximum_file_size
      add_error(:byte_size, I18n.t("errors.validations.#{record.class.to_s.downcase}.#{field_name}.byte_size"))
    end
  end

  def validate_content_type
    return unless valid_field_name?
    
    unless accepted_content_types.include?(content_type)
      add_error(:content_type, I18n.t("errors.validations.#{record.class.to_s.downcase}.#{field_name}.content_type"))
    end
  end

end