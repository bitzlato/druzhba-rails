# frozen_string_literal: true

set :rails_env, :production
set :stage, :production,
    user: fetch(:user),
    port: '22',
    roles: %w[app db bugsnag webpack].freeze,
    ssh_options: { forward_agent: true }
