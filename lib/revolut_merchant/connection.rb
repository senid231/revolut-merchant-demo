# frozen_string_literal: true

module RevolutMerchant
  class Connection
    MIME_TYPE = 'application/json'

    # @param path [String]
    # @param query [Hash,nil]
    # @return [Hash,Array]
    # @raise [RevolutMerchant::Errors::ApiError]
    def get(path, query: nil)
      request(:get, path, query:).body
    end

    # @param path [String]
    # @param query [Hash,nil]
    # @param body [Hash,nil]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def post(path, query: nil, body: nil)
      request(:post, path, query:, body:).body
    end

    # @param path [String]
    # @param query [Hash,nil]
    # @param body [Hash,nil]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def patch(path, query: nil, body: nil)
      request(:patch, path, query:, body:).body
    end

    # @param path [String]
    # @param query [Hash,nil]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def delete(path, query: nil)
      request(:delete, path, query:).body
    end

    private

    def request(method, path, query: nil, body: nil)
      connection.send(method) do |request|
        request.url(path, query)
        request.body = body.to_json if body
      end
    end

    def connection
      Faraday.new(connection_options) do |builder|
        builder.request :json
        builder.request :authorization, 'Bearer', -> { RevolutMerchant.config.secret_key }

        builder.use RaiseErrorMiddleware
        builder.response :json, parser_options: { symbolize_names: true }

        builder.adapter Faraday.default_adapter

        builder.response :logger, RevolutMerchant.config.logger, bodies: true if RevolutMerchant.config.logger

        RevolutMerchant.config.connection_config&.call(builder)
      end
    end

    def connection_options
      {
        url: RevolutMerchant.config.url,
        headers: {
          'Content-Type' => MIME_TYPE,
          'Accept' => MIME_TYPE,
          user_agent: RevolutMerchant.config.user_agent
        }
      }
    end
  end
end
