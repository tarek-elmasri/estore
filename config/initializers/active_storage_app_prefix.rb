
  # Rails.application.config.to_prepare do
  #   require 'active_storage/blob'
  #   class ActiveStorage::Blob
  #     def self.generate_unique_secure_token(length: MINIMUM_TOKEN_LENGTH)
  #       gust = SecureRandom.base36(length)
  #       epoch = Time.now.to_i.to_s
  #       checksum = Digest::MD5.hexdigest(gust + epoch)

  #       folder = checksum.chars.first(9).each_slice(3).to_a.map(&:join).join('/')

  #       "#{folder}/#{gust}"
  #     end
  #   end
  # end

  
  Rails.application.config.to_prepare do
    require 'active_storage/blob'
    class ActiveStorage::Blob
      def self.generate_unique_secure_token(length: MINIMUM_TOKEN_LENGTH)
        gust = SecureRandom.base36(length)

        "admin/#{gust}"
      end
    end
  end
