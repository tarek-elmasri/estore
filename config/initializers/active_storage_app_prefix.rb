  # Rails.configuration.to_prepare do
  #   ActiveStorage::Blob.class_eval do
  #     #before_create :generate_key_with_prefix
  
  #     def generate_key_with_prefix
  #       self.key = if prefix
  #         File.join prefix, self.class.generate_unique_secure_token
  #       else
  #         self.class.generate_unique_secure_token
  #       end
  #     end
  
  #     def prefix
  #       "demo"
  #     end
  #   end
  # end
# Rails.configuration.to_prepare do
#   module ActiveStorageKeyExtenstion
#     def key
#       self.key = File.join "demo", self.class.generate_unique_secure_token
#     end
#   end


#   ActiveStorage::Blob.include ActiveStorageKeyExtenstion
# end