source 'https://rubygems.org'

ruby '~> 2.3.8'

# Gems for metrics to use
gem 'project_metrics', git: 'https://github.com/an-ju/project_metrics.git'
gem 'project_metric_base', git: 'https://github.com/an-ju/project_metric_base'
gem 'project_metric_code_climate', git: 'https://github.com/an-ju/project_metric_code_climate.git'
gem 'project_metric_cycle_time', git: 'https://github.com/an-ju/project_metric_cycle_time.git'
gem 'project_metric_heroku_status', git: 'https://github.com/an-ju/project_metric_heroku_status.git'
gem 'project_metric_point_estimation', git: 'https://github.com/an-ju/project_metric_point_estimation.git'
gem 'project_metric_story_overall', git: 'https://github.com/an-ju/project_metric_story_overall.git'
gem 'project_metric_test_coverage', git: 'https://github.com/an-ju/project_metric_test_coverage.git'
gem 'project_metric_pull_requests', git: 'https://github.com/an-ju/project_metric_pull_requests.git'
gem 'project_metric_tracker_activities', git: 'https://github.com/an-ju/project_metric_tracker_activities'
gem 'project_metric_travis_ci', git: 'https://github.com/an-ju/project_metric_travis_ci.git'
gem 'project_metric_github_branch', git: 'https://github.com/an-ju/project_metric_github_branch.git'
gem 'project_metric_github_files', git: 'https://github.com/an-ju/project_metric_github_files.git'
gem 'project_metric_github_flow', git: 'https://github.com/an-ju/project_metric_github_flow.git'
gem 'project_metric_github_use', git: 'https://github.com/an-ju/project_metric_github_use.git'
gem 'project_metric_point_distribution', git: 'https://github.com/an-ju/project_metric_point_distribution.git'
gem 'project_metric_commit_message', git: 'https://github.com/an-ju/project_metric_commit_message.git'

# Securely store secrets, including symmetric encrypt key for attr_encrypted
gem 'attr_encrypted'
gem 'figaro'

gem 'rake'
gem 'rails', '~> 5.2.0'
# gem 'rails', '4.2.6'

gem "bootsnap", ">= 1.1.0", require: false

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'haml'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'timecop'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Authorization and authentification
gem 'devise'
gem 'cancan'
gem 'omniauth-github'

gem 'json'

gem 'bootstrap-sass', '~> 3.3.6'
gem "font-awesome-rails"
gem 'bootswatch-rails', '~>3.3.5'
gem 'jquery-ui-rails'
gem 'jquery-turbolinks'
# gem 'sprockets-rails', '~> 3.1.1', require: 'sprockets/railtie'
gem 'webpacker'
gem 'tailwindcss', '~> 0.2.0'

gem 'newrelic_rpm'
gem 'pg', '~> 0.15'

gem 'puma', '~> 3.11'

group :development, :test do
  gem 'sqlite3', '~> 1.3.6'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem "jasmine"
  gem 'jasmine-jquery-rails'
  gem 'rb-readline'
end

group :test do
  gem 'rspec-rails'
  gem 'rspec_junit_formatter'
  gem 'cucumber-rails', require: false
  gem 'cucumber-rails-training-wheels'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'phantomjs', :require => 'phantomjs/poltergeist'
  gem 'rails-controller-testing'
  gem 'simplecov'
  gem 'launchy'
  gem 'poltergeist'
  gem 'vcr'
  gem 'webmock'
  gem 'codeclimate-test-reporter', require: nil
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

group :production do
  gem 'rails_12factor'
end
