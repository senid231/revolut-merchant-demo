# frozen_string_literal: true

module RevolutMerchant
  module Errors
    class Error < StandardError
    end

    class ApiError < Error
      # @!method env [Faraday::Env,nil]
      # @!method status [Integer,nil]
      # @!method response_body [Hash,nil]
      attr_reader :env, :status, :response_body

      def initialize(msg, env)
        @env = env
        @status = env&.status
        @response_body = env&.response_body
        super(msg)
      end
    end

    class BadRequest < ApiError
      def initialize(env)
        super('Bad Request', env)
      end
    end

    class Unauthorized < ApiError
      def initialize(env)
        super('Unauthorized', env)
      end
    end

    class NotFound < ApiError
      def initialize(env)
        super("Not found #{env.url.path}", env)
      end
    end

    class InsufficientFunds < ApiError
      def initialize(env)
        super('Insufficient Funds', env)
      end
    end

    class ServerError < ApiError
      def initialize(env)
        super('Server Error', env)
      end
    end

    module_function

    # @param env [Faraday::Env]
    # @return [RevolutMerchant::Errors::ApiError,nil]
    def from_response(env)
      status = env.status
      return if status >= 200 && status <= 299

      if status == 400
        BadRequest.new(env)
      elsif status == 401
        Unauthorized.new(env)
      elsif status == 404
        NotFound.new(env)
      elsif status == 422
        InsufficientFunds.new(env)
      elsif status >= 500
        ServerError.new(env)
      else
        ApiError.new("Unknown error (#{status})", env)
      end
    end
  end
end
