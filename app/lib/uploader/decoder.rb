class Uploader::Decoder

  attr_accessor :base64 
  attr_reader :file, :file_size, :content_type, :filename

  def initialize obj={}
    obj ||= {}
    self.base64 = obj[:base64].to_s.split("base64,").last
    self.filename = obj[:filename].to_s
    build
  end


  def decode
    build
    return self
  end


  private
  attr_writer :file, :file_size, :content_type, :filename
  
  def build
    self.file = Base64.strict_decode64(base64)
    self.file_size = file.length
    self.content_type = Marcel::MimeType.for file
  rescue => exception
    self.file=nil
    self.file_size=nil
    self.content_type = nil
  end

  


end