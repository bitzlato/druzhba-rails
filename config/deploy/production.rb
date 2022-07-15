set :stage, :production

       user: fetch(:user),
       roles: %w[app db bugsnag webpack].freeze,
       ssh_options: { forward_agent: true }
