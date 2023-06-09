# frozen_string_literal: true

module RevolutMerchant
  class Configuration
    attr_accessor :secret_key,
                  :public_key,
                  :user_agent,
                  :connection_config,
                  :on_error,
                  :logger

    attr_writer :url
    attr_reader :mode

    def initialize
      @mode = CONST::MODE_SANDBOX
      self.user_agent = "RevolutMerchant #{RevolutMerchant::VERSION} Ruby #{RUBY_VERSION}"
    end

    def mode=(value)
      raise ArgumentError, 'invalid mode' unless CONST::MODE_URLS.key?(value)

      @mode = value
    end

    def url
      return @url if defined?(@url)

      CONST::MODE_URLS.fetch(mode)
    end
  end
end
