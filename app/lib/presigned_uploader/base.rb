class PresignedUploader::Base
  attr_accessor :field_name, :record, :skip_authorization

  def initialize(field_name: nil , record_id: nil , record_type: nil, skip_authorization: false)
    
    
    self.field_name = field_name
    if record_id && record_type && field_name
      begin
        self.record = ActiveStorage::Attachment.new(
                        name: field_name, record_id: record_id, record_type: record_type&.to_s.singularize.capitalize
                      ).record
      rescue 
        self.record= nil
      end
    end
  end


  protected
  attr_accessor :errors


  # def accepted_content_types
  #   return unless valid_field_name?
  #   record.class.const_get("#{field_name.upcase}_ACCEPTED_CONTENT_TYPES")
  # end

  # def maximum_file_size
  #   return unless valid_field_name?
  #   record.class.const_get("#{field_name.upcase}_MAXIMUM_FILE_SIZE").to_i
  # end

  def add_error(field, msg)
    record.errors.add(field, msg)
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
    add_error(:field_name, I18n.t("presigned_uploader.#{record.class.to_s.downcase}.invalid_field_name_for_upload"))
  end

  def validate_inclusion_of_model_class
    return unless valid_field_name?

    return if (record.class.constants.include?("#{field_name.upcase}_MAXIMUM_FILE_SIZE".to_sym)) &&
                  (record.class.constants.include?("#{field_name.upcase}_ACCEPTED_CONTENT_TYPES".to_sym))
    
    add_error(:record_type, I18n.t("presigned_uploader.record_not_uploadable"))
    #raise ArgumentError.new("PresignedUploader::Model is not included in #{record.class.to_s.capitalize} class")
  end

  # def validate_byte_size
  #   return unless valid_field_name?

  #   if byte_size.to_i > maximum_file_size || byte_size.to_i == 0
  #     add_error(:byte_size, I18n.t("presigned_uploader.#{record.class.to_s.downcase}.byte_size"))
  #   end
  # end

  # def validate_content_type
  #   return unless valid_field_name?
    
  #   unless accepted_content_types.include?(content_type)
  #     add_error(:content_type, I18n.t("presigned_uploader.#{record.class.to_s.downcase}.content_type"))
  #   end
  # end

  
  def check_authorization
    raise ActiveRecord::RecordNotFound unless record
    raise Errors::Unauthorized unless Current.user.send("is_authorized_to_update_#{record.class.to_s.downcase}?")
  end

  def validate_standard_validators
    validate_record
    validate_field_name
    validate_inclusion_of_model_class
  end

end