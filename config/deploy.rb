# frozen_string_literal: true

lock '3.16'

set :user, 'app'
set :application, 'druzhba'

set :roles, %w[app db].freeze

if ENV['USE_LOCAL_REPO'].nil?
  set :repo_url,
      ENV.fetch('DEPLOY_REPO',
                `git remote -v | grep origin | head -1 | awk  '{ print $2 }'`.chomp)
end
set :keep_releases, 10

set :linked_files, %w[.env]
set :linked_dirs,
    %w[log node_modules tmp/pids tmp/cache tmp/sockets public/assets public/uploads public/uploads public/packs]
set :config_files, fetch(:linked_files)

set :deploy_to, -> { "/home/#{fetch(:user)}/#{fetch(:application)}" }

set :disallow_pushing, true

set :bugsnag_api_key, ENV.fetch('BUGSNAG_API_KEY', nil)

default_branch = 'main'
current_branch = `git rev-parse --abbrev-ref HEAD`.chomp

if ENV.key? 'BRANCH'
  set :branch, ENV.fetch('BRANCH')
elsif default_branch == current_branch
  set :branch, default_branch
else
  ask(:branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp })
end

set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

set :nvm_map_bins, %w[node npm yarn rake]

# Only attempt migration if db/migrate changed - not related to Webpacker, but a nice thing
set :conditionally_migrate, true

set :assets_dependencies,
    %w[
      app/assets lib/assets vendor/assets app/javascript
      yarn.lock Gemfile.lock config/routes.rb config/initializers/assets.rb
      .semver
    ]
set :keep_assets, 2
set :local_assets_dir, 'public'

set :app_version, SemVer.find.to_s
set :current_version, `git rev-parse HEAD`.strip

if Gem.loaded_specs.key?('capistrano-sentry')
  set :sentry_organization, ENV.fetch('SENTRY_ORGANIZATION', nil)
  set :sentry_release_version, -> { [fetch(:app_version), fetch(:current_version)].compact.join('-') }
  before 'deploy:starting', 'sentry:validate_config'
  after 'deploy:published', 'sentry:notice_deployment'
end

set :puma_tag, fetch(:application)
set :puma_start_task, 'systemd:puma:start'

set :assets_roles, []

set :init_system, :systemd
set :systemd_amqp_daemon_role, :app
set :systemd_amqp_daemon_instances, -> { %i[blockchain_events] }

after 'deploy:publishing', 'systemd:puma:reload-or-restart'

Rake::Task['deploy:assets:backup_manifest'].clear_actions

if defined?(Slackistrano) && ENV.fetch('SLACKISTRANO_CHANNEL', nil)
  Rake::Task['deploy:starting'].prerequisites.delete('slack:deploy:starting')
  set :slackistrano,
      klass: Slackistrano::CustomMessaging,
      channel: ENV.fetch('SLACKISTRANO_CHANNEL'), # Take it from your teamlead
      webhook: ENV.fetch('SLACKISTRANO_WEBHOOK')

  # best when 75px by 75px.
  set :slackistrano_thumb_url, 'https://bitzlato.com/wp-content/uploads/2020/12/logo.svg'
  set :slackistrano_footer_icon, 'https://github.githubassets.com/images/modules/logos_page/Octocat.png'
end

# Removed rake, bundle, gem
# Added rails.
# rake has its own dotenv requirement in Rakefile
set :dotenv_hook_commands, %w[rake rails ruby]

Capistrano::DSL.stages.each do |stage|
  after stage, 'dotenv:hook'
end

namespace :systemd do
  desc 'Statuses of systemd units on every servers'
  task :statuses do
    on roles(:all) do
      execute 'systemctl --user status'
    end
  end
end
