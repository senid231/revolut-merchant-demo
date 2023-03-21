# frozen_string_literal: true

require 'revolut_merchant'

RevolutMerchant.configure do |config|
  config.secret_key = Rails.application.secrets.revolut_secret_key
  config.public_key = Rails.application.secrets.revolut_public_key
  config.mode = RevolutMerchant::CONST::MODE_SANDBOX
  config.logger = Rails.logger
  config.on_error = ->(error) do
    Rails.logger.error { "RevolutMerchant ERROR <#{error.class}> #{error.message}" }
    # Rails.logger.error { "#{error.env.method.upcase} #{error.env.url}: #{error.status})\n#{error.response_body}" }
  end
end
