module PresignedUploader::Model
  extend ActiveSupport::Concern


  class_methods do
    # define_method(:validate_attachment) do |field , maximum_file_size: , accepted_content_types:, options={} |
    #   const_set "#{field.upcase}_MAXIMUM_FILE_SIZE", maximum_file_size
    #   const_set "#{field.upcase}_ACCEPTED_CONTENT_TYPES", accepted_content_types

    # end

    define_method(:has_one_file) do |field_name, file_size: , content_type: , dependent: |
      has_one_attached field_name, dependent: dependent
      const_set "#{field_name.upcase}_MAXIMUM_FILE_SIZE", file_size
      const_set "#{field_name.upcase}_ACCEPTED_CONTENT_TYPES", content_type

      define_method("#{field_name}_data") do |expires_in: 30.minutes|
        attachment = send(field_name).attachment
        return unless attachment
        return {
          attachment_id: attachment.id,
          url: attachment.url(expires_in: expires_in)
        }
      end
    end
    
    define_method(:has_many_files) do |field_name, file_size: , content_type: , dependent: |
      has_many_attached field_name, dependent: dependent
      const_set "#{field_name.upcase}_MAXIMUM_FILE_SIZE", file_size
      const_set "#{field_name.upcase}_ACCEPTED_CONTENT_TYPES", content_type
      
      define_method("#{field_name}_data") do |expires_in: 30.minutes|
        attachments = send(field_name).attachments
        #return [] unless attachments.any?
        attachments.map do |attachment|
          {
          attachment_id: attachment.id,
          url: attachment.url(expires_in: expires_in)
          }
        end
      end
    end

  end


end