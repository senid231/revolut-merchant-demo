# frozen_string_literal: true

module RevolutMerchant
  class Connection
    def get(path, query: nil)
      request(:get, path, query:).body
    end

    def post(path, query: nil, body: nil)
      request(:post, path, query:, body:).body
    end

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
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
          user_agent: RevolutMerchant.config.user_agent
        }
      }
    end
  end
end
