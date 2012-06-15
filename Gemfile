source 'http://rubygems.org'

gem 'rails', '3.1.0'

gem 'haml'

gem 'jquery-rails'

gem 'will_paginate', '~> 3.0'
gem 'bootstrap-will_paginate', '0.0.5'

gem 'devise'

gem 'imdb'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
	gem 'sass-rails', "  ~> 3.1.0"
	gem 'coffee-rails', "~> 3.1.0"
	gem 'uglifier'
	gem 'therubyracer'
	gem 'twitter-bootstrap-rails'
	gem 'less'
end

group :production do
	gem 'pg'
	gem 'thin'
end

group :test, :development do
	gem 'sqlite3'
	gem 'cucumber-rails'
	gem 'cucumber-rails-training-wheels'
	gem 'database_cleaner'
	gem 'capybara'
	gem 'launchy'
	gem 'rspec-rails'
	gem 'annotate', '~> 2.4.1.beta'
	gem 'simplecov'
	gem 'autotest'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end
