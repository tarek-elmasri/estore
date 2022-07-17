module UploadValidator
  extend ActiveSupport::Concern

  
  class_methods do
    def has_one_file(field_name, options={})
      #attr_accessor "base64_#{field_name}"
      has_one_attached field_name
     
      define_method("base64_#{field_name}=") do |code|
        file_containers ||= {}
        file_containers["#{field_name}"] = {
          decoder: Uploader::Decoder.new(code),
          options: options
        }
      end

      define_method("base64_#{field_name}") do
        file_containers["#{field_name}"].code
      end

    end

    validate :attachment_requirements
  end

  private
  attr_accessor :file_containers

  def attachment_requirements

  end
end