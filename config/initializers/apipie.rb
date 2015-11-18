Apipie.configure do |config|
  config.app_name                = "UsStateUniversities"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/api_docs"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.validate                = false
end
