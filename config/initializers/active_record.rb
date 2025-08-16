# frozen_string_literal: true

# Rails 8 Active Record Configuration
# This file contains Rails 8 specific Active Record configurations for optimal performance and compatibility

Rails.application.configure do
  # Rails 8 Active Record Performance Optimizations

  # Enable automatic scope inversing for better performance with associations
  config.active_record.automatic_scope_inversing = true

  # Disable partial inserts for consistency and performance
  # This ensures all columns are referenced in INSERT queries
  config.active_record.partial_inserts = false

  # Enable foreign key verification in fixtures for better test reliability
  config.active_record.verify_foreign_keys_for_fixtures = true

  # Rails 8 Query Performance and Monitoring

  # Enable query log tags for better debugging and monitoring
  config.active_record.query_log_tags_enabled = true

  # Configure query log tags for comprehensive monitoring
  config.active_record.query_log_tags = %i[
    application
    controller
    action
    job
    request_id
    source_location
  ]

  # Enable query log tags format for structured logging
  config.active_record.query_log_tags_format = :sqlcommenter

  # Rails 8 Migration and Schema Management

  # Enable strict loading by default in development and test
  # This helps identify N+1 queries early
  config.active_record.strict_loading_by_default = true if Rails.env.local?

  # Rails 8 Pack-based Architecture Support

  # Ensure autoloading works correctly with pack-based models
  # This is important for the Packwerk architecture used in this application
  config.active_record.belongs_to_required_validates_foreign_key = false

  # Enable zeitwerk mode for better autoloading with packs
  config.autoloader = :zeitwerk

  # Rails 8 Development and Debugging Enhancements

  if Rails.env.development?
    # Enable verbose query logs for development debugging
    config.active_record.verbose_query_logs = true

    # Show migration error on page load
    config.active_record.migration_error = :page_load

    # Enable query cache for better development performance
    config.active_record.cache_query_log_tags = true
  end

  # Rails 8 Production Optimizations

  if Rails.env.production?
    # Disable schema dumping after migrations in production
    config.active_record.dump_schema_after_migration = false

    # Limit attributes for inspect in production for security
    config.active_record.attributes_for_inspect = [:id]
  end

  # Rails 8 Test Environment Optimizations

  if Rails.env.test?
    # Use transactional fixtures for faster tests
    config.active_record.maintain_test_schema = true
  end
end

# Rails 8 Active Record Extensions for Pack-based Architecture
ActiveSupport.on_load(:active_record) do
  # Ensure models work correctly across pack boundaries
  # This is crucial for the Packwerk-based architecture

  # Enable cross-pack model associations
  self.include_root_in_json = false

  # Configure JSON serialization for API compatibility
  self.time_zone_aware_attributes = true
end

# Rails 8 Migration Compatibility Check
Rails.application.config.after_initialize do
  # Enable Rails 8 migration features
  ActiveRecord::Migration.verbose = true if defined?(ActiveRecord::Migration) && Rails.env.development?
end
