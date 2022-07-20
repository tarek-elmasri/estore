module Base64FileAttachment
  extend ActiveSupport::Concern

  class_methods do
    def has_one_base64_attached(field_name, options={})
      raise ArgumentError.new("ActiveStorage must be installed") unless respond_to?(:has_one_attached)
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
      raise ArgumentError.new("ActiveStorage must be installed") unless respond_to?(:has_many_attached)
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

    def validates_attached(field_name, options={})
      validate {
          raise ArgumentError.new("#{field_name} is undefined") unless respond_to?(field_name)
          accepted_options = [:required, :max_file_size, :content_type]
          options.except(*accepted_options).map do |k,_|
          raise ArgumentError.new("#{k} is not supported")
          end
          target_field = send("#{field_name}")
          if target_field.respond_to?(:attachment)
            validate_presence_of_attachment(field_name, target_field.attachment) if options[:required]
            validate_content_type(field_name, target_field.blob , options[:content_type]) if options[:content_type]
            validate_file_size(field_name,target_field.blob, options[:max_file_size]) if options[:max_file_size]
          elsif target_field.respond_to?(:attachments)
            validate_presence_of_attachment(field_name, target_field.attachments.first) if options[:required]
            target_field.blobs.each do |blob|
              validate_content_type(field_name,blob, options[:content_type]) if options[:content_type]
              validate_file_size(field_name,blob, options[:max_file_size]) if options[:max_file_size]
            end
          else
            raise ArgumentError.new("#{field_name} is not an 'ActiveStorage' class")
          end
        end
      }

    end
  end

  private
  def validate_presence_of_attachment(field_name,attachment)
    if attachment.nil?
      errors.add("#{field_name}", I18n.t("activerecord.errors.messages.blank"))
    end
  end

  def validate_content_type(field_name,blob,accepted_content_types)
    return unless blob
    unless accepted_content_types.include?(blob.content_type)
      errors.add(field_name, I18n.t("errors.validations.#{self.class.to_s.downcase}.#{field_name}.content_type"))
    end
  end

  def validate_file_size(field_name, blob, max_file_size)
    return unless blob
    if (blob.byte_size * (3.00/4)) > max_file_size
      errors.add(field_name, I18n.t("errors.validations.#{self.class.to_s.downcase}.#{field_name}.max_file_size"))
    end
  end
end