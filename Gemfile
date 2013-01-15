#source 'http://mirror1.prod.rhcloud.com/mirror/ruby/'
source 'http://rubygems.org'

gem 'rails', '3.2.6'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', '0.10.2', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

# This version needs to be hardcoded for OpenShift compatability
gem 'thor', '= 0.14.6'

# This needs to be installed so we can run Rails console on OpenShift directly
gem 'minitest'

# Login authentication
gem 'devise'

# Bugzilla integration
gem 'taskmapper'
if File.exists? File.expand_path('../taskmapper-bugzilla')
  gem 'taskmapper-bugzilla', :path => '../taskmapper-bugzilla'
else
  gem 'taskmapper-bugzilla', :git => 'git://github.com/Ifukube/taskmapper-bugzilla.git'
end
gem 'taskmapper-github'

if File.exists? File.expand_path('../rubyzilla')
  gem 'rubyzilla', :path => '../rubyzilla'
else
  gem 'rubyzilla', :git => 'git://github.com/Ifukube/rubyzilla.git', :branch => 'taskmapper'
end

gem 'haml'
gem 'haml-rails'

gem 'compass-960-plugin', '>= 0.10.4', :require => 'ninesixty'
gem 'simple-navigation', '>= 3.3.4'

gem 'compass'
gem 'compass-rails', '~> 1.0.3'

if File.exists? File.expand_path('../alchemy')
  gem 'alchemy', :path => '../alchemy'
else
  gem 'alchemy', :git => 'git://github.com/ui-alchemy/alchemy.git', :branch => 'simple_form'
end

gem 'tire'

gem 'sidekiq'
gem 'sidekiq-status'
gem 'sinatra', require: false
gem 'slim'

# Handy when bringing in external erb
# rake haml:convert_erbs
gem 'erb2haml', :group => :development

# Stuff for i18n
gem 'gettext_i18n_rails'

#group :development do
#  gem 'debugger'
#end
