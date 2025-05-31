# Baukis2 Development Guidelines

This document provides guidelines and information for developers working on the Baukis2 project.

## Build/Configuration Instructions

### System Requirements
- Ruby 3.4.2
- PostgreSQL 17
- [dip](https://github.com/bibendi/dip/tree/v5.0.0#installation) for development environment management

### Setup Process
1. Install dip following the instructions at https://github.com/bibendi/dip/tree/v5.0.0#installation
2. Set up the development environment:
   ```bash
   dip provision
   dip rails db:migrate
   dip rails db:seed
   ```
3. Start the server:
   ```bash
   dip rails s
   ```

### Access URLs
- Staff interface: http://baukis2.lvh.me:23000/
- Admin interface: http://baukis2.lvh.me:23000/admin
- Customer interface: http://lvh.me:23000/mypage

### Database Reset
To reset the database and reload seed data:
```bash
dip rails db:reset
```

## Testing Information

### Running Tests
To run all tests:
```bash
dip rspec
```

To run a specific test file:
```bash
dip rspec path/to/spec_file.rb
```

### Test Structure
The project uses RSpec for testing with the following organization:
- `spec/` - Main test directory for application-wide tests
- `packs/*/spec/` - Tests specific to each pack (admin, staff, customer)

### Test Types
- **Unit Tests**: Test individual components (models, presenters, helpers)
- **Controller Tests**: Test controller actions and responses
- **Request Tests**: Test API endpoints
- **System Tests**: End-to-end tests using Capybara with Playwright

### Adding New Tests
1. Identify the appropriate location for your test:
   - For pack-specific functionality, add tests to the pack's spec directory
   - For application-wide functionality, add tests to the main spec directory
2. Follow the existing patterns for the type of test you're writing
3. Use FactoryBot for test data generation
4. Run your tests with `dip rspec path/to/your_spec.rb`

### Example Test
Here's an example of a simple test for a module:

```ruby
# spec/lib/html_builder_spec.rb
require 'rails_helper'

class TestClass
  include HtmlBuilder
end

RSpec.describe HtmlBuilder do
  let(:test_instance) { TestClass.new }

  describe '#markup' do
    it 'builds HTML with a tag and content' do
      html = test_instance.markup(:div, class: 'test') do |doc|
        doc.text 'Hello, world!'
      end
      
      expect(html).to eq '<div class="test">Hello, world!</div>'
    end
  end
end
```

## Additional Development Information

### Code Style
- The project uses RuboCop for code style enforcement
- Configuration is in `.rubocop.yml` and `.rubocop_todo.yml`
- Run RuboCop with `dip rubocop`

### Modular Architecture
- The project uses Packwerk for enforcing modular architecture
- Code is organized into packs in the `packs/` directory:
  - `admin/` - Admin interface
  - `staff/` - Staff interface
  - `customer/` - Customer interface
- Each pack has its own models, controllers, views, and tests
- Be aware of privacy boundaries between packs when writing code

### Coverage Reporting
- SimpleCov is used for code coverage reporting
- Coverage reports are generated in HTML and LCOV formats
- Reports are stored in the `coverage/` directory

### Debugging
To inspect database tables:
```ruby
dip rails r StaffMember.columns.each { |c| p [c.name, c.type ] }
```

To modify data for testing:
```ruby
dip rails r StaffMember.first.update_columns(suspended: true)
```
