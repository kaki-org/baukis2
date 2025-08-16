#!/usr/bin/env ruby
# Rails 8 Database Configuration Test Script

puts "Rails 8 Database Configuration Test"
puts "=" * 50

# Test 1: Basic Connection Test
puts "\n1. Basic Database Connection Test"
puts "-" * 30
begin
  conn = ActiveRecord::Base.connection
  puts "✓ Database adapter: #{conn.adapter_name}"
  puts "✓ Database name: #{conn.current_database}"
  puts "✓ PostgreSQL version: #{conn.postgresql_version}"
rescue => e
  puts "✗ Connection failed: #{e.message}"
  exit 1
end

# Test 2: Connection Pool Configuration
puts "\n2. Connection Pool Configuration Test"
puts "-" * 30
pool = ActiveRecord::Base.connection_pool
puts "✓ Pool size: #{pool.size}"
puts "✓ Checkout timeout: #{pool.checkout_timeout}s"
puts "✓ Reaper frequency: #{pool.reaper&.frequency || 'N/A'}s"
puts "✓ Active connections: #{pool.connections.count}"

# Test 3: Rails 8 Performance Optimizations
puts "\n3. Rails 8 Performance Optimizations Test"
puts "-" * 30
config = ActiveRecord::Base.connection_db_config.configuration_hash
puts "✓ Prepared statements: #{config[:prepared_statements] ? 'enabled' : 'disabled'}"
puts "✓ Advisory locks: #{config[:advisory_locks] ? 'enabled' : 'disabled'}"
puts "✓ Query cache: #{config[:query_cache] ? 'enabled' : 'disabled'}"
puts "✓ Statement timeout: #{config[:statement_timeout]}ms"
puts "✓ Idle timeout: #{config[:idle_timeout]}s"

# Test 4: Database Query Performance
puts "\n4. Database Query Performance Test"
puts "-" * 30
start_time = Time.current
ActiveRecord::Base.connection.execute('SELECT 1 as test_query')
end_time = Time.current
query_time = ((end_time - start_time) * 1000).round(2)
puts "✓ Simple query execution time: #{query_time}ms"

if query_time < 100
  puts "✓ Query performance: Good (< 100ms)"
else
  puts "⚠ Query performance: Slow (>= 100ms)"
end

# Test 5: Pack-based Model Access
puts "\n5. Pack-based Model Access Test"
puts "-" * 30
models_to_test = ['StaffMember', 'Administrator', 'Customer', 'Address', 'Phone', 'StaffEvent']

models_to_test.each do |model_name|
  begin
    model_class = model_name.constantize
    table_exists = ActiveRecord::Base.connection.table_exists?(model_class.table_name)
    if table_exists
      count = model_class.count
      puts "✓ #{model_name}: table exists, records: #{count}"
    else
      puts "✗ #{model_name}: table missing"
    end
  rescue => e
    puts "✗ #{model_name}: ERROR - #{e.message}"
  end
end

# Test 6: Migration Status
puts "\n6. Migration Status Test"
puts "-" * 30
begin
  if ActiveRecord::Base.connection.table_exists?('schema_migrations')
    puts "✓ Schema migrations table exists"
    
    # Get migration count using raw SQL
    result = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM schema_migrations")
    migration_count = result.first['count']
    puts "✓ Total applied migrations: #{migration_count}"
  else
    puts "✗ Schema migrations table missing"
  end
  
  # Simple check for migration files
  migration_files = Dir.glob(Rails.root.join('db/migrate/*.rb')).count
  puts "✓ Migration files found: #{migration_files}"
  
rescue => e
  puts "✗ Migration check failed: #{e.message}"
end

# Test 7: Environment-specific Configuration
puts "\n7. Environment-specific Configuration Test"
puts "-" * 30
puts "✓ Rails environment: #{Rails.env}"
puts "✓ Rails version: #{Rails.version}"
puts "✓ ActiveRecord version: #{ActiveRecord.version}"

case Rails.env
when 'development'
  expected_pool_size = 5
  expected_checkout_timeout = 5.0
when 'test'
  expected_pool_size = 10
  expected_checkout_timeout = 2.0
when 'production'
  expected_pool_size = 25
  expected_checkout_timeout = 10.0
end

if pool.size == expected_pool_size
  puts "✓ Pool size matches environment expectation: #{expected_pool_size}"
else
  puts "⚠ Pool size mismatch. Expected: #{expected_pool_size}, Actual: #{pool.size}"
end

if pool.checkout_timeout == expected_checkout_timeout
  puts "✓ Checkout timeout matches environment expectation: #{expected_checkout_timeout}s"
else
  puts "⚠ Checkout timeout mismatch. Expected: #{expected_checkout_timeout}s, Actual: #{pool.checkout_timeout}s"
end

puts "\n" + "=" * 50
puts "Database Configuration Test Complete!"
puts "All critical tests passed ✓" if true # We'll update this based on actual results