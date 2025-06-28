# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Baukis2 is a Ruby on Rails customer management system with a packwerk-based modular architecture. It has three distinct interfaces:
- Staff Interface: `http://baukis2.lvh.me:23000/`
- Admin Interface: `http://baukis2.lvh.me:23000/admin`
- Customer Interface: `http://lvh.me:23000/mypage`

## Architecture

### Packwerk Structure
The codebase uses Packwerk to enforce modular boundaries:
- `/packs/staff/` - Staff functionality
- `/packs/admin/` - Administrative functionality
- `/packs/customer/` - Customer-facing functionality

Each pack contains its own MVC structure, routes, and tests with enforced dependencies defined in `package.yml`.

### Key Patterns
- **Form Objects**: Complex validations (e.g., `Staff::LoginForm`)
- **Presenters**: View logic separation (e.g., `StaffMemberPresenter`)
- **Service Objects**: Business logic encapsulation (e.g., `Staff::Authenticator`)
- **Concerns**: Shared functionality (`EmailHolder`, `PasswordHolder`, etc.)

## Development Commands

### Setup & Server
```bash
dip provision          # Initial setup
dip rails db:migrate   # Run migrations
dip rails db:seed      # Seed database
dip rails s            # Start server
```

### Testing
```bash
dip rspec                           # Run all tests
dip rspec spec/path/to/test_spec.rb # Run specific test
```

### Code Quality
```bash
dip rubocop        # Run linting
dip rubocop -a     # Auto-fix issues
dip brakeman       # Security analysis
```

### Package Management
```bash
dip bundle install  # Ruby dependencies
dip pnpm install    # JavaScript dependencies
dip pnpm build      # Build JavaScript
```

## Technology Stack
- Ruby 3.4.4, Rails 8.0.0
- PostgreSQL 17
- Stimulus, Turbo Rails, Webpack
- RSpec with Capybara/Playwright for testing
- Docker with dip for orchestration

## File Organization
- Pack routes: `/packs/*/config/routes/*.rb`
- Shared views: `/app/views/shared/`
- Layouts: `/app/views/layouts/` (separate for each interface)
- Seeds: `/packs/*/db/seeds/development/`
- Locales: `/config/locales/` (Japanese default)

## Testing Structure
Tests are organized within each pack's `spec/` directory. Uses RSpec, FactoryBot, and system tests with Playwright driver.