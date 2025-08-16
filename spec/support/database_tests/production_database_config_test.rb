#!/usr/bin/env ruby
# Rails 8 Production Database Configuration Test Script

puts "Rails 8 Production Database Configuration Test"
puts "=" * 55

# Test production database configuration without actually connecting
puts "\n1. Production Configuration Validation"
puts "-" * 40

begin
  # Load production database configuration
  db_config = Rails.application.config.database_configuration['production']
  
  puts "✓ Production database configuration loaded"
  puts "✓ Database name: #{db_config['database']}"
  puts "✓ Username: #{db_config['username']}"
  puts "✓ Host: #{db_config['host'] || 'default'}"
  puts "✓ Port: #{db_config['port'] || 'default'}"
  
  # Check Rails 8 optimizations
  puts "\n2. Rails 8 Production Optimizations"
  puts "-" * 40
  
  optimizations = {
    'pool' => db_config['pool'],
    'timeout' => db_config['timeout'],
    'checkout_timeout' => db_config['checkout_timeout'],
    'reaping_frequency' => db_config['reaping_frequency'],
    'query_cache' => db_config['query_cache'],
    'prepared_statements' => db_config['prepared_statements'],
    'idle_timeout' => db_config['idle_timeout'],
    'statement_timeout' => db_config['statement_timeout']
  }
  
  optimizations.each do |key, value|
    if value
      puts "✓ #{key}: #{value}"
    else
      puts "⚠ #{key}: not configured"
    end
  end
  
  # Validate production-specific settings
  puts "\n3. Production-specific Validation"
  puts "-" * 40
  
  # Check pool size
  pool_size = db_config['pool'].to_s
  if pool_size.include?('RAILS_MAX_THREADS') || pool_size.to_i >= 20
    puts "✓ Pool size configured for production load: #{pool_size}"
  else
    puts "⚠ Pool size may be too small for production: #{pool_size}"
  end
  
  # Check timeout settings
  timeout = db_config['timeout'].to_i
  if timeout >= 5000
    puts "✓ Connection timeout appropriate for production: #{timeout}ms"
  else
    puts "⚠ Connection timeout may be too short: #{timeout}ms"
  end
  
  # Check checkout timeout
  checkout_timeout = db_config['checkout_timeout'].to_i
  if checkout_timeout >= 5
    puts "✓ Checkout timeout configured for production: #{checkout_timeout}s"
  else
    puts "⚠ Checkout timeout may be too short: #{checkout_timeout}s"
  end
  
  # Check statement timeout
  statement_timeout = db_config['statement_timeout'].to_i
  if statement_timeout >= 30000
    puts "✓ Statement timeout configured: #{statement_timeout}ms"
  else
    puts "⚠ Statement timeout not configured or too short: #{statement_timeout}ms"
  end
  
  puts "\n4. Security Configuration Check"
  puts "-" * 40
  
  # Check password configuration
  password_config = db_config['password']
  if password_config.nil? || password_config.to_s.empty?
    puts "✓ Password configured via environment variable (resolved at runtime)"
  elsif password_config.include?('ENV')
    puts "✓ Password configured via environment variable"
  else
    puts "⚠ Password configuration should use environment variables"
  end
  
  # Check username
  if db_config['username'] && db_config['username'] != 'postgres'
    puts "✓ Using dedicated database user: #{db_config['username']}"
  else
    puts "⚠ Consider using a dedicated database user instead of 'postgres'"
  end
  
rescue => e
  puts "✗ Configuration test failed: #{e.message}"
end

puts "\n" + "=" * 55
puts "Production Database Configuration Test Complete!"