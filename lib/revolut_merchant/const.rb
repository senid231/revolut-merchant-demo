# frozen_string_literal: true

module RevolutMerchant
  class CONST
    MODE_SANDBOX = :sandbox
    MODE_PROD = :prod
    MODE_URLS = {
      MODE_SANDBOX => 'https://sandbox-merchant.revolut.com/api/1.0',
      MODE_PROD => 'https://merchant.revolut.com/api/1.0'
    }.freeze

    freeze
  end
end
