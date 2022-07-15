server ENV.fetch('PRODUCTION_HOST'),
       user: fetch(:user),
       roles: %w[app db bugsnag webpack].freeze,
       ssh_options: { forward_agent: true }
