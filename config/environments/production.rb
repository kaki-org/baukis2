# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings (ignored by Rake tasks).
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Turn on fragment caching in view templates.
  config.action_controller.perform_caching = true

  # Cache assets for far-future expiry since they are all digest stamped.
  config.public_file_server.headers = {
    'cache-control' => "public, max-age=#{1.year.to_i}",
    'expires' => 1.year.from_now.to_fs(:rfc822)
  }

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present? || ENV['RENDER'].present?

  # Compress CSS using a preprocessor.
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Enable asset compression for better performance
  config.assets.compress = true

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  config.assume_ssl = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Skip http-to-https redirect for the default health check endpoint.
  config.ssl_options = {
    redirect: { exclude: ->(request) { request.path == '/up' } },
    hsts: { expires: 1.year, subdomains: true, preload: true }
  }

  # Log to STDOUT with the current request id as a default log tag.
  config.log_tags = %i[request_id remote_ip]
  config.logger   = ActiveSupport::TaggedLogging.logger($stdout)

  # Change to "debug" to log everything (including potentially personally-identifiable information!)
  config.log_level = ENV.fetch('RAILS_LOG_LEVEL', 'info')

  # Prevent health checks from clogging up the logs.
  config.silence_healthcheck_path = '/up'

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Enable structured logging for better monitoring
  config.log_formatter = Logger::Formatter.new

  # Configure log rotation to prevent disk space issues
  if ENV['RAILS_LOG_TO_STDOUT'].blank?
    config.logger = ActiveSupport::Logger.new(
      Rails.root.join('log/production.log'),
      1, # Keep 1 old log file
      50.megabytes # Rotate when log reaches 50MB
    )
  end

  # Replace the default in-process memory cache store with a durable alternative.
  # config.cache_store = :mem_cache_store

  # Enable Redis cache store for better performance in production
  # config.cache_store = :redis_cache_store, { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/1") }

  # Replace the default in-process and non-durable queuing backend for Active Job.
  # config.active_job.queue_adapter = :resque

  # Enable performance optimizations
  config.action_controller.enable_fragment_cache_logging = true

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Set host to be used by links generated in mailer templates.
  config.action_mailer.default_url_options = {
    host: ENV.fetch('MAILER_HOST', 'example.com'),
    protocol: 'https'
  }

  # Configure mailer for production
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp

  # Specify outgoing SMTP server. Remember to add smtp/* credentials via rails credentials:edit.
  # config.action_mailer.smtp_settings = {
  #   user_name: Rails.application.credentials.dig(:smtp, :user_name),
  #   password: Rails.application.credentials.dig(:smtp, :password),
  #   address: "smtp.example.com",
  #   port: 587,
  #   authentication: :plain,
  #   enable_starttls_auto: true,
  #   open_timeout: 10,
  #   read_timeout: 10
  # }

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Only use :id for inspections in production.
  config.active_record.attributes_for_inspect = [:id]

  # Enable DNS rebinding protection and other `Host` header attacks.
  # config.hosts = [
  #   "example.com",     # Allow requests from example.com
  #   /.*\.example\.com/ # Allow requests from subdomains like `www.example.com`
  # ]
  #
  # Skip DNS rebinding protection for the default health check endpoint.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }

  # Enable Rails 8 performance optimizations
  config.action_dispatch.show_exceptions = :rescues

  # Configure session store for better security
  config.session_store :cookie_store,
                       key: '_baukis2_session',
                       secure: true,
                       httponly: true,
                       same_site: :lax

  # Enable Rails 8 asset optimizations
  config.assets.digest = true
  config.assets.debug = false

  # Configure Active Record for production performance
  config.active_record.query_log_tags_enabled = true
  config.active_record.query_log_tags = %i[
    application
    controller
    action
    job
    request_id
    source_location
  ]

  # Rails 8 production performance optimizations
  config.active_record.query_log_tags_format = :sqlcommenter
  config.active_record.strict_loading_by_default = false
end
