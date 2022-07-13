class String
  def is_i?
    /\A[-+]?\d+\z/ === self
  end
end

class Integer
  def is_i?
    true
  end
end