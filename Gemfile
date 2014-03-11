source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.13'

# PostgreSQL
gem 'pg'

# Oracle Connection
#gem 'activerecord-oracle_enhanced-adapter', '~> 1.4.0'
#gem 'ruby-oci8', '~> 2.1.0'
### gem 'ruby-oci8', --platform x86-mingw32
### gem 'ruby-oci8', platforms: :mingw32

gem 'execjs'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', platforms: :ruby
  gem 'therubyracer'
  gem 'less-rails'
  gem 'twitter-bootstrap-rails'
  gem 'uglifier', '>= 1.0.3'
end

# Erro da gem therubyracer
gem 'libv8', '~> 3.11.8'

gem 'jquery-rails'
gem 'bootstrap-sass', '~> 2.3.2.2'
gem 'devise'

gem 'rspec-rails', group: [:test, :development]

group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'guard-rspec'
end

group :development do
	# Debugger
	gem 'debugger'
end

# Pagination
gem 'kaminari'

# Encryption Engine
gem 'bcrypt-ruby'

# JSON Templating
gem 'jbuilder'

# Thin Server
gem 'thin'

# Thin Server como serviço no Windows
gem 'thin_service'

# File uploads
gem 'carrierwave'

# Wizard
gem 'fuelux-rails'

# Push Notifications
gem 'push-core'
gem 'push-gcm'
