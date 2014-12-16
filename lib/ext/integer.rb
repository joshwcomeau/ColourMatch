class Integer
  def to_hex
    to_s(16).upcase.rjust(2, '0')
  end
end