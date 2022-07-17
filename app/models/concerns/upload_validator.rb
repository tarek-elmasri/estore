module UploadValidator
  extend ActiveSupport::Concern

  
  class_methods do
    def has_one_file(field_name, options={})
      attr_accessor "base64_#{field_name}"
      has_one_attached field_name
     
      unless options.empty?
        
        define_method(:attachment_requirements) do
          options
        end

        #private :attachment_requirements
        
        validate :attachment_requirements
      end


    end
  end
end