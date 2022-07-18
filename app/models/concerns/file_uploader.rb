module FileUploader
  extend ActiveSupport::Concern

  included do
    #attr_accessor :file_containers

    after_initialize { @file_containers=@file_containers || {}}
    validate :attachment_requirements

    def attachment_requirements
      @file_containers.map do |file_name,file_options|
        decoder= file_options[:decoder]

        if decoder.code
        # validates bad encoding
          unless decoder.file
            self.errors.add(file_name, I18n.t("errors.validations.#{file_name}.invalid_base64_encoding")) 
          end
          
          # validates file seize
          if file_options[:options][:max_file_size] &&
                                  (decoder.file_size || 0 ) > file_options[:options][:max_file_size]
            self.errors.add(file_name, I18n.t("errors.validations.#{file_name}.max_size_file"))
          end

          # validates content_type
          if file_options[:options][:accepted_content_types] &&
                                  !file_options[:options][:accepted_content_types].include?(decoder.content_type)
            self.errors.add(file_name, I18n.t("errors.validations.#{file_name}.accepted_content_types"))
          end

        end
      end
    end
  end
  
  class_methods do

    def has_one_file(field_name, options={})
      # --- checking implementation errors
      # checking extra params
      options.except(:required, :accepted_content_types, :max_file_size, :filename).map do |k,_|
        raise StandardError.new "'#{k}' key is not accepted for has_one_file"
      end

      if options[:filename] && !options[:filename].is_a?(String)
        raise StandardError.new("'filename must be a string")
      end
      # checking types of content type
      if options[:accepted_content_types] && !options[:accepted_content_types].is_a?(Array)
        raise StandardError.new("'accepted_content_type' must be an array of types")
      end
      #checkong types of max file size
      if options[:max_file_size] && !options[:max_file_size].is_a?(Integer)
        raise StandardError.new("'max_file_size must be an integer value of bytes")
      end
      # making sure
      raise StandardError.new('ActiveStorage is required to implement has_one_file function') unless respond_to? :has_one_attached
      # ------------

      has_one_attached field_name

      if options[:required]
        validates "base64_#{field_name}", presence: true, unless: Proc.new { |m| m.send("#{field_name}").attached?}
      end

      define_method("base64_#{field_name}=") do |code|
        decoder = Uploader::Decoder.new(code)
        
        send("#{field_name}=", {
          io: StringIO.new(decoder.file),
          content_type: decoder.content_type,
          filename: options[:filename] || "#{self.class.to_s}_#{field_name}"
        }) if decoder.file
        @file_containers ||= {}
        @file_containers["#{field_name}"] = {
          decoder: decoder,
          options: options
        }
      end

      define_method("base64_#{field_name}") do
        return nil unless @file_containers && @file_containers["#{field_name}"]
        decoder = @file_containers["#{field_name}"][:decoder]
        decoder.code
      end
    end
  end

end