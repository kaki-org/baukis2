# Pin npm packages by running ./bin/importmap

# Rails 8 importmap configuration for modern JavaScript
pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'

# Legacy support for existing jQuery-based code
pin 'jquery', to: 'https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js'

# Action Cable for WebSocket support
pin '@rails/actioncable', to: 'actioncable.esm.js'

# Pack-specific JavaScript modules
pin 'staff', to: 'staff.js'
pin 'admin', to: 'admin.js'
pin 'customer', to: 'customer.js'
