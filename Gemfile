source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'

gem 'active_link_to'
gem 'bcrypt_pbkdf', '~> 1.1'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'carrierwave'
gem 'carrierwave-bombshelter'
gem 'dotenv-rails'
gem 'ed25519', '~> 1.3'
gem 'env-tweaks'
gem 'eth'
gem 'grape'
gem 'grape-entity'
gem 'grape-swagger'
gem 'grape-swagger-entity'
gem 'grape-swagger-rails'
gem 'gravatarify', '~> 3.1'
gem 'jbuilder', '~> 2.7'
gem 'jwt'
gem 'kaminari'
gem 'mini_magick'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.6'
gem 'redis'
gem 'sass-rails', '>= 6'
gem 'sd_notify', '~> 0.1.1'
gem 'semver2', '~> 3.4'
gem 'simple_form'
gem 'slim-rails'
gem 'sorcery'
gem 'vault-rails', '~> 0.7.1'
gem 'virtus'
gem 'webpacker', '~> 5.0'

group :development, :test do
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'spring'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :deploy do
  gem 'bugsnag-capistrano', require: false
  gem 'capistrano', '~> 3.16', require: false
  gem 'capistrano3-puma', github: 'seuros/capistrano-puma'
  gem 'capistrano-bundler', require: false
  gem 'capistrano-db-tasks', require: false
  gem 'capistrano-dotenv'
  gem 'capistrano-dotenv-tasks'
  gem 'capistrano-rails', require: false
  gem 'capistrano-rails-console', require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-shell', require: false
  gem 'capistrano-systemd-multiservice', github: 'brandymint/capistrano-systemd-multiservice', require: false
  gem 'capistrano-tasks', github: 'brandymint/capistrano-tasks', require: false
  gem 'slackistrano', require: false
end
