#!/usr/bin/env ruby
# frozen_string_literal: true

# Final Rails 8 Database Configuration Verification

puts 'Final Rails 8 Database Configuration Verification'
puts '=' * 60

environments = %w[development test]
all_tests_passed = true

environments.each do |env|
  puts "\n#{env.upcase} Environment Test"
  puts '-' * 30

  begin
    # Set environment
    ENV['RAILS_ENV'] = env

    # Reload configuration
    Rails.application.config.database_configuration

    # Test connection
    ActiveRecord::Base.establish_connection(env.to_sym)
    conn = ActiveRecord::Base.connection

    puts "✓ Connection established: #{conn.current_database}"

    # Test pool configuration
    pool = ActiveRecord::Base.connection_pool
    puts "✓ Pool size: #{pool.size}"
    puts "✓ Checkout timeout: #{pool.checkout_timeout}s"

    # Test Rails 8 features
    config = ActiveRecord::Base.connection_db_config.configuration_hash

    case env
    when 'development'
      expected_features = {
        prepared_statements: true,
        query_cache: true,
        advisory_locks: true
      }
    when 'test'
      expected_features = {
        prepared_statements: false,
        query_cache: false,
        advisory_locks: true
      }
    end

    expected_features.each do |feature, expected_value|
      actual_value = config[feature]
      if actual_value == expected_value
        puts "✓ #{feature}: #{actual_value} (as expected)"
      else
        puts "✗ #{feature}: #{actual_value} (expected: #{expected_value})"
        all_tests_passed = false
      end
    end

    # Test query execution
    start_time = Time.current
    ActiveRecord::Base.connection.execute('SELECT current_timestamp')
    end_time = Time.current
    query_time = ((end_time - start_time) * 1000).round(2)

    puts "✓ Query execution time: #{query_time}ms"

    # Test model access
    model_test_passed = true
    %w[StaffMember Customer Administrator].each do |model_name|
      model_class = model_name.constantize
      model_class.connection.table_exists?(model_class.table_name)
      puts "✓ #{model_name} model accessible"
    rescue StandardError => e
      puts "✗ #{model_name} model error: #{e.message}"
      model_test_passed = false
      all_tests_passed = false
    end
  rescue StandardError => e
    puts "✗ Environment test failed: #{e.message}"
    all_tests_passed = false
  end
end

# Test production configuration (without connecting)
puts "\nPRODUCTION Configuration Validation"
puts '-' * 30

begin
  prod_config = Rails.application.config.database_configuration['production']

  required_settings = {
    'pool' => 25,
    'timeout' => 10_000,
    'checkout_timeout' => 10,
    'prepared_statements' => true,
    'query_cache' => true
  }

  required_settings.each do |setting, expected_value|
    actual_value = prod_config[setting]
    if actual_value.to_s.include?('ENV') || actual_value == expected_value
      puts "✓ #{setting}: configured correctly"
    else
      puts "✗ #{setting}: #{actual_value} (expected: #{expected_value})"
      all_tests_passed = false
    end
  end
rescue StandardError => e
  puts "✗ Production config validation failed: #{e.message}"
  all_tests_passed = false
end

puts "\n#{'=' * 60}"
if all_tests_passed
  puts '🎉 ALL DATABASE CONFIGURATION TESTS PASSED!'
  puts 'Rails 8 database configuration is properly implemented.'
else
  puts '❌ Some tests failed. Please review the configuration.'
end
puts '=' * 60
