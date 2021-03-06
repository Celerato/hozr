# Gemfile
# =======
# Policies:
# * We do not add versioned dependencies unless needed
# * If we add versioned dependencies, we document the reason
# * We use single quotes
# * We use titles to group related gems

# Settings
# ========
source 'https://rubygems.org'

# Rails
# =====
gem 'rails', '~> 3.2'

# Unicorn
# =======
gem 'unicorn'

# Database
# ========
gem 'mysql2'

# Asset Pipeline
# ==============
gem 'less-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'therubyracer'
gem 'quiet_assets'

# CRUD
# ====
gem 'inherited_resources'
gem 'has_scope'
gem 'kaminari'
gem 'i18n_rails_helpers'

# UI
# ==
gem 'jquery-rails'
gem 'haml'
gem 'twitter-bootstrap-rails'
gem 'lyb_sidebar'
gem 'simple-navigation'

# Forms
# =====
gem 'simple_form'
gem 'select2-rails'

# Access Control
# ==============
gem 'devise', '~> 2.2' # Changed API
gem 'cancan'
gem 'lyb_devise_admin'

# Date/Time handling
gem 'validates_timeliness'

# Application Settings
gem 'ledermann-rails-settings', '~> 1.2', :require => 'rails-settings' # Changed API

# Addresses
gem 'unicode_utils'
gem 'has_vcards', '~> 0.20' # Data model changes, needs synced release with CyDoc
gem 'autocompletion'
gem 'swissmatch'
gem 'swissmatch-location', :require => 'swissmatch/location/autoload'

# Multiple Databases
gem 'use_db'

# Wysiwyg
gem 'tinymce-rails'

# Files
gem 'carrierwave'
gem 'file-column', :git => 'https://github.com/huerlisi/file_column.git'

# Images
gem 'jcrop-rails'
gem 'rmagick'

# Barcode
gem 'barby'

# PDF generation
gem 'prawn'

# Printing
gem 'cupsffi', require: !ENV['CI']

# Mail
gem 'premailer'
gem "premailer-rails"
#gem 'actionmailer-instyle', :require => 'action_mailer/in_style', :path => '../actionmailer-instyle'

# Search
gem 'thinking-sphinx'

# Development
# ===========
group :development do
  # Debugging
  gem 'better_errors', '~> 1.1.0'
  gem 'binding_of_caller'  # Needed by binding_of_caller to enable html console

  # Deployment
  gem 'capones_recipes'
end

# Dev and Test
# ============
group :development, :test do
  # Testing Framework
  gem 'rspec-rails'
  gem 'rspec-activemodel-mocks'

  # Browser
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'poltergeist'
  gem 'selenium-webdriver'

  # Matchers/Helpers
  gem 'accept_values_for'

  # Debugger
  gem 'pry-rails'
  #gem 'pry-byebug'

  # Fixtures
  gem 'database_cleaner'
  gem 'connection_pool'
  gem "factory_girl_rails"
end

# Docs
# ====
group :doc do
  # Docs
  gem 'rdoc'
end
