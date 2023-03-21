# frozen_string_literal: true

module RevolutMerchant
  class CONST
    MODE_SANDBOX = :sandbox
    MODE_PROD = :prod
    MODE_URLS = {
      MODE_SANDBOX => 'https://sandbox-merchant.revolut.com/api/1.0',
      MODE_PROD => 'https://merchant.revolut.com/api/1.0'
    }.freeze

    CURRENCY_USD = 'USD'

    CAPTURE_MODE_MANUAL = 'MANUAL'

    ENFORCE_CHALLENGE_FORCED = 'FORCED'

    ORDER_STATE_PENDING = 'PENDING'
    ORDER_STATE_PROCESSING = 'PROCESSING'
    ORDER_STATE_AUTHORISED = 'AUTHORISED'
    ORDER_STATE_COMPLETED = 'COMPLETED'
    ORDER_STATE_CANCELLED = 'CANCELLED'
    ORDER_STATE_FAILED = 'FAILED'

    freeze
  end
end
