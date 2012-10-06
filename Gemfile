source 'http://rubygems.org'

gem 'capistrano'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'font-awesome-rails', git: 'git://github.com/mrnugget/font-awesome-rails.git'
gem 'jquery-rails'
gem 'rails'
gem 'sqlite3'

group :production do
  gem 'mysql2'
end

group :assets do
  gem 'uglifier'
end

group :development do
  gem 'annotate'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'turn', '0.8.2', require: false
end

# http://stackoverflow.com/questions/6282307/rails-3-1-execjs-and-could-not-find-a-javascript-runtime
gem 'execjs'
gem 'therubyracer'
