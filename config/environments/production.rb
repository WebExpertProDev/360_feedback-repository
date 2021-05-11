Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true
  config.read_encrypted_secrets = true
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.assets.js_compressor = :uglifier
  config.assets.compile = false
  config.log_level = :debug
  config.log_tags = [ :request_id ]
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.action_mailer.default_url_options = { host: 'https://mindgrowing360.net' }
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  config.force_ssl = true
  
  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :address => "smtp.mailgun.org",
    :domain  => ENV["MAILER_DOMAIN"],
    :port      => 587,
    :user_name => ENV["MAILER_USERNAME"],
    :password => ENV["MAILER_PASSWORD"],
    :authentication => 'plain'
  }
  # config.force_ssl = true 
end
