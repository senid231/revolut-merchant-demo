# frozen_string_literal: true

require_relative 'revolut_merchant/version'
require_relative 'revolut_merchant/const'
require_relative 'revolut_merchant/configuration'
require_relative 'revolut_merchant/errors'
require_relative 'revolut_merchant/raise_error_middleware'
require_relative 'revolut_merchant/connection'
require_relative 'revolut_merchant/client'

module RevolutMerchant
  module_function

  def configure(&)
    yield config
  end

  def config
    @config ||= Configuration.new
  end
end
