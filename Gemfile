source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails',                  '~> 5.0.0', '>= 5.0.0.1'
# Use mysql as the database for Active Record
gem 'mysql2',                 '~> 0.4.4'
# Use Puma as the app server
gem 'puma',                   '~> 3.6.0'
# Use Bcrypt to crypt password
gem 'bcrypt',         '3.1.11'

# Assets
gem 'uglifier',                 '>= 1.3.0'
gem 'turbolinks',               '~> 5.0.0'
gem 'nprogress-rails',          '~> 0.2.0.2'

## Jquery
source 'https://rails-assets.org' do
  gem 'rails-assets-jquery',           '~> 1.11'
  gem 'rails-assets-jquery-ujs',       '~> 1.0'
end

# Use SCSS for stylesheets
gem 'sass-rails',           '~> 5.0.6'
gem 'bootstrap-sass', '~> 3.3.6'

# Pager
gem 'kaminari',               '~> 0.17.0'

# Filters 
gem 'ransack',                 '~> 1.8.2'

# Responders (for DRY flash behaviour)
gem 'responders',               '~> 2.2.0'

# Forms
gem 'simple_form',                     '~> 3.3.1'
gem 'select2-rails'
gem 'select2_simple_form', github: 'lndl/select2_simple_form', tag: '0.7.3'

# Configurations
gem 'config', '~> 1.3.0'

# State machine
gem 'stateful_enum', '~> 0.4.0'

group :development do
  gem 'rails-erd',              '~> 1.4.6'
  gem 'better_errors',          '~> 1.1.0'
  gem "binding_of_caller"
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'graphviz'
end

# Test tools
group :test do
  gem 'factory_girl_rails',       '~> 4.5.0'
  gem 'rspec-rails',              '~> 3.1.0'
  gem 'nyan-cat-formatter'
  gem 'shoulda-matchers',         github: 'thoughtbot/shoulda-matchers'
  gem 'database_cleaner'
  gem 'faker'
end

