defined?(AssetSync) && AssetSync.configure do |config|
  config.fog_provider = 'AWS'
  config.aws_access_key_id =     'AKIAIIAJOXK5SYNQPZZA'
  config.aws_secret_access_key = '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'
  config.fog_directory =          "parkingstrasbourg-#{Rails.env}"
  config.fog_region = 'eu-west-1'
  #
  # Automatically replace files with their equivalent gzip compressed version
  # config.gzip_compression = true
  #
  # Use the Rails generated 'manifest.yml' file to produce the list of files to
  # upload instead of searching the assets directory.
  # config.manifest = true
  #
  # Fail silently.  Useful for environments such as Heroku
  # config.fail_silently = true
end
