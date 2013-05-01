source "https://rubygems.org"

def darwin_only(require_as)
  RUBY_PLATFORM.include?('darwin') && require_as
end

def linux_only(require_as)
  RUBY_PLATFORM.include?('linux') && require_as
end

gem "rails", "3.2.13"

# Supported DBs
#gem "mysql2", group: :mysql
gem "pg", :group => :postgres

# Auth
gem "devise", "~> 2.1.2"
gem 'devise_invitable', '~> 1.0.0'
gem 'omniauth', "~> 1.1.1"
gem 'devise-encryptable'
gem 'omniauth-oauth2'
gem 'koala'
gem 'omniauth-facebook'
gem 'omniauth-twitter', :git => 'git://github.com/arunagw/omniauth-twitter.git'
gem 'omniauth-github'
gem 'linkedin'
gem 'omniauth-linkedin'
gem 'omniauth-google-oauth2'
gem "cancan"
gem "rolify", ">= 3.2.0"


# API
gem "grape", "~> 0.2.1"

# Format dates and times
# based on human-friendly examples
gem "stamp"

# Pagination
gem "kaminari", "~> 0.14.1"

# HAML
gem "haml-rails", "~> 0.3.5"

# Generate Fake data
gem "ffaker"

# Seed data
gem "seed-fu"

# Markdown to HTML
gem "redcarpet",     "~> 2.2.2"
gem "github-markup", "~> 0.7.4", :require => 'github/markup'

# Servers
gem "thin", '~> 1.5.0'
gem "unicorn", "~> 4.4.0"

# Decorators
gem "draper", "~> 0.18.0"

# HTTP requests
gem "httparty"

# Colored output to console
gem "colored"

# Misc
gem "foreman"
gem "git"
#gem "less-rails"
gem "jquery-rails"

group :assets do
  gem "sass-rails",   "~> 3.2.5"
  gem "coffee-rails", "~> 3.2.2"
  gem 'jquery-datatables-rails'
  gem "uglifier",     "~> 1.3.0"
  gem "raphael-rails",    "1.5.2"
end

group :development do
  gem "annotate", :git => "git://github.com/ctran/annotate_models.git"
  gem "letter_opener"
  gem 'quiet_assets', '~> 1.0.1'
  gem 'rack-mini-profiler'
  # Better errors handler
  gem 'better_errors'
  gem 'binding_of_caller'
  #gem 'metrical'
  #gem 'rails_best_practices'
  gem 'bullet'
end

group :development, :test do
  gem 'relish'
  gem 'rails-dev-tweaks'
  gem 'cucumber-rails', :require => false
  gem "rspec-rails", ">= 2.12.0"
  gem "selenium-webdriver", "~> 2.27.2"
  gem "capybara", "~> 2.0.1"
  gem "pry"
  gem "awesome_print"
  gem "database_cleaner", :github => "bmabey/database_cleaner"
  gem "launchy"
  gem 'factory_girl_rails'

  # Guard
  gem 'guard-rspec'
  gem "spork", "> 0.9.0.rc"
  gem "guard-spork"
  gem 'fuubar'
  # Notification
  gem 'rb-fsevent', :require => darwin_only('rb-fsevent')
  gem 'growl',      :require => darwin_only('growl')
  gem 'rb-inotify', :require => linux_only('rb-inotify')
end

group :test do
  gem 'simplecov', '>=0.3.8', :require => false
  gem 'email_spec'
  gem 'test_after_commit'
  gem "sunspot_test", "~> 0.4.0"
end

group :production do

end

# translation
gem 'tolk'

# versioning
gem 'paper_trail', '~> 2'
gem 'airbrake'

# image files attachments
gem 'mini_magick'
gem "carrierwave", "~> 0.7.1"
gem "fog", "~> 1.3.1"

# Background job MQ service
gem 'queue_classic'
gem "resque"
gem 'resque_mailer'


# data visulaization
gem "google_visualr", ">= 2.1.2"
gem "useragent"
gem "rdf-rdfa"

# maps
gem 'geocoder', '~> 1.1.1'
gem 'gmaps4rails', :github => 'apneadiving/Google-Maps-for-Rails'

# flat pages
gem 'high_voltage'

# twitter bootstrap
gem "breadcrumbs_on_rails"
gem 'twitter-bootstrap-rails', :github => 'seyhunak/twitter-bootstrap-rails'
gem 'bootstrap-wysihtml5-rails'

# tags and rails admin
gem "acts-as-taggable-on", "2.3.3"
gem 'rails_admin_tag_list', :github => 'kryzhovnik/rails_admin_tag_list', :ref => "1092becaa3b3a19874710910d287541563e9026b"
gem 'rails_admin', '~> 0.0.4'

# errrors for dummy
gem 'errship3'


gem "simple_form", ">= 2.0.4"

# solr and friends
gem 'sunspot_rails', :git => 'git://github.com/sunspot/sunspot.git'
gem 'sunspot_solr'

gem 'turbolinks', :github => 'rails/turbolinks'
gem 'cache_digests'
gem 'best_in_place'
#gem 'ransack'
gem "nested_form", :git => 'git://github.com/ryanb/nested_form'

gem 'rails-gallery'
#gem 'bootstrap-addons-rails'