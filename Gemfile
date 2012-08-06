source 'http://rubygems.org'

gem 'rails'
gem 'sqlite3'

group :assets do
  gem 'uglifier'
end

gem 'jquery-rails'

gem 'bcrypt-ruby', '~> 3.0.0'

gem 'font-awesome-rails', git: 'git://github.com/mrnugget/font-awesome-rails.git'

gem 'capistrano'

group :production do
  gem 'mysql2'
end

group :development do
  gem 'annotate'
  gem 'rspec-rails'
end

group :test do
  gem 'turn', '0.8.2', :require => false
  gem 'rspec-rails'
  gem 'capybara'
  gem 'database_cleaner'
end

# http://stackoverflow.com/questions/6282307/rails-3-1-execjs-and-could-not-find-a-javascript-runtime
gem 'execjs'
gem 'therubyracer'
