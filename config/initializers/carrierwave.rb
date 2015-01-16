CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: "AWS",
    aws_access_key_id: ENV["COLOURMATCH_AMAZON_KEY"],
    aws_secret_access_key: ENV["COLOURMATCH_AMAZON_SECRET"]
  }
  config.fog_directory = 'colourmatch'
end