module FiveHundredAPI
  require 'rest_client'
  BASE_URL = "https://api.500px.com/v1/photos?consumer_key=#{ENV['FIVEHUNDREDPX_KEY']}"
  
  def self.get_photos(given_opts={})
    opts = default_opts.merge(given_opts)
    request_string = BASE_URL + build_endpoint_string(opts)
    puts "Requesting URL:\n #{request_string}"
    JSON.parse(RestClient.get(request_string))
  end

  private

  def self.build_endpoint_string(opts)
    opts.inject("") do |result, opt|
      result += "&#{opt[0]}=#{opt[1]}"
    end
  end

  def self.default_opts
    {
      rpp:            100,
      image_size:     3,
      sort:           'created_at'
    }
  end
end