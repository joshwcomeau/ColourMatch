class System::GetImageDimensions
  def self.call(query_string)
    # So, this may seem like a pointless service, but I'm mainly using it for 
    # being able to give a name to this backtick terminal method.

    # using backticks (`) differs from using system() in that backticks RETURN whatever the
    # system returns. system() will output to STDOUT, but will return true/false.

    `#{query_string}`
  end
end