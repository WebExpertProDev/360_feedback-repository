Rails.application.configure do
  Bullet.enable = true # for N+1 queries
  # Bullet.alert = true
  Bullet.bullet_logger = true
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.quiet = true
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  
  config.action_mailer.default_url_options = { host: 'http://localhost:3000' }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :letter_opener
  
  # config.action_mailer.delivery_method = :smtp
  # ActionMailer::Base.smtp_settings = {
  #   :address => "smtp.mailgun.org",
  #   :domain  => ENV["MAILER_DOMAIN"],
  #   :port      => 587,
  #   :user_name => ENV["MAILER_USERNAME"],
  #   :password => ENV["MAILER_PASSWORD"],
  #   :authentication => 'plain'
  #   }  
end
