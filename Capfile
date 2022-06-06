# frozen_string_literal: true

require 'rubygems'
require 'bundler'
Bundler.setup(:deploy)

require 'semver'

require 'capistrano/setup'

require 'capistrano/deploy'

require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano-db-tasks'
require 'capistrano/shell'

require 'capistrano/rails/console'

require 'slackistrano/capistrano'
require 'capistrano/tasks'
require 'capistrano/my'
install_plugin Capistrano::My
require 'capistrano/slackistrano' # My Custom Message
require 'capistrano/rails/migrations'
require 'capistrano/rails/assets'
require 'capistrano/dotenv/tasks'
require 'capistrano/dotenv'
require 'bugsnag-capistrano' if Gem.loaded_specs.key?('bugsnag-capistrano')
require 'capistrano/sentry' if Gem.loaded_specs.key?('capistrano-sentry')

require 'capistrano/puma'
install_plugin Capistrano::Puma

# require 'capistrano/master_key'
require 'capistrano/systemd/multiservice'
install_plugin Capistrano::Systemd::MultiService.new_service('puma', service_type: 'user')
