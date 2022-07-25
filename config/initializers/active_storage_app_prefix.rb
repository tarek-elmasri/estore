

ActiveSupport.on_load(:active_storage_blob) do
  def key
    self[:key] ||= "#{Current.user.rule}/#{self.class.generate_unique_secure_token}"
  end
end