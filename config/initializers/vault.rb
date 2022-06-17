# frozen_string_literal: true

require 'vault/rails'

Vault::Rails.configure do |config|
  config.enabled = ENV.true?('VAULT_ENABLED') || Rails.env.production?
  config.address = ENV.fetch('VAULT_ADDR', 'http://127.0.0.1:8200')
  config.token = ENV.fetch('VAULT_TOKEN', nil)
  config.ssl_verify = false
  config.timeout = 60
  config.application = ENV.fetch('VAULT_APP_NAME', 'druzhba')
end

if ENV['VAULT_TOKEN'].to_s == ''
  Rails.logger.warn 'Environment variable VAULT_TOKEN is missing'
else
  # rubocop:disable Metrics/AbcSize
  def renew_process
    token = Vault.auth_token.lookup(Vault.token)
    time = token.data[:ttl] * (1 + rand) * 0.1
    Rails.logger.debug format('[VAULT] Token will renew in %.0f sec', time)
    sleep(time)
    Vault.auth_token.renew(token.data[:id])
    Rails.logger.info '[VAULT] Token renewed'
  end
  # rubocop:enable Metrics/AbcSize

  token = Vault.auth_token.lookup(Vault.token)

  if token.data[:renewable]
    Rails.logger.info '[VAULT] Starting token renew thread'
    Thread.new do
      loop do
        renew_process
      rescue StandardError => e
        report_exception(e)
        sleep 60
      end
    end
  else
    Rails.logger.info '[VAULT] Token is not renewable'
  end
end