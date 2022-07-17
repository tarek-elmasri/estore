class Uploader::Decoder

  attr_accessor :code
  attr_reader :file, :file_size, :content_type

  def initialize code
    self.code = code 
    build
    rescue
      nil
  end


  def decode
    build
    return self
  end


  private
  attr_writer :file, :file_size, :content_type
  
  def build
    self.file = Base64.strict_decode64(code)
    self.file_size = file.length
    self.content_type = Marcel::MimeType.for file
  rescue => exception
    self.file=nil
    self.file_size=nil
    self.content_type = nil
  end

  


end