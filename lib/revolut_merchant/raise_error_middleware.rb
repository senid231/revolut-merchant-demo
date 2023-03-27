# frozen_string_literal: true

require 'faraday'

module RevolutMerchant
  class RaiseErrorMiddleware < Faraday::Middleware
    # @param env [Faraday::Env]
    def on_complete(env)
      error = RevolutMerchant::Errors.from_response(env)
      RevolutMerchant.config.on_error&.call(error) if error
      raise error if error
    end
  end
end
