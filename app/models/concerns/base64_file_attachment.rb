module Base64FileAttachment
  extend ActiveSupport::Concern

  class_methods do
    def has_one_base64_attached(field_name, options={})
      has_one_attached "#{field_name}_record", options
     
      define_method(field_name) do
        send("#{field_name}_record")
      end

      define_method("#{field_name}=") do |params|
        coder= Uploader::Decoder.new(params)
        send("#{field_name}_record=",coder.base64.nil? ? nil : {
          io: StringIO.new(coder.file || ""),
          content_type: coder.content_type,
          filename: coder.filename.blank? ? "#{self.class.to_s.downcase}_#{field_name}" : coder.filename
        })
      end
    end

    def has_many_base64_attached(field_name, options={})
      has_many_attached "#{field_name}_record", options

      define_method(field_name) do
        send("#{field_name}_record")
      end

      define_method("#{field_name}=") do |params_array|
        return unless params_array.is_a?(Array)
        attachments = []
        params_array.each_with_index do |params, i|
          coder= Uploader::Decoder.new(params)
          attachments.push({
            io: StringIO.new(coder.file || ""),
            content_type: coder.content_type,
            filename: coder.filename.blank? ? "#{self.class.to_s.downcase}_#{field_name}_#{i+1}" : coder.filename
          })
        end
        send("#{field_name}_record=", attachments)
      end
    end

    def validates_attached(field_name,option={})
      raise ArgumentError.new("#{field_name} is undefined") unless respond_to?(field_name) 
      accepted_options = [:required, :max_file_size, :content_type]
      options.except(*accepted_options).map do |k,_|
        raise ArgumentError.new("#{k} is not supported")
      end

      validate :attachment_requirements

      define_method(:attachment_requirements) do
        target_field = send("#{field_name}")
        if target_field.is_a?(ActiveStorage::Attachment::One)
          validate_presence_of_attachment(field_name,target_field.attachment) if options[:required]
         
          attachment_validator(target_field.blob)
        elsif target_field.is_a?(ActiveStorage::Attachment::Many)

        else
          raise ArgumentError.new("#{field_name} is not an 'ActiveStorage::Attachment' class")
        end
      end
      private :attachment_requirements
      

    end
  end

  private
  def validate_presence_of_attachment(field_name,attachment)
    if attachment.nil?
      errors.add("#{field_name}", I18n.t("activerecord.errors.messages.required"))
    end
  end



end