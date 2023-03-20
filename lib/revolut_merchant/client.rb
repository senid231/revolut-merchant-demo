# frozen_string_literal: true

module RevolutMerchant
  module Client
    module_function

    def customers
      connection.get('customers')
    end

    # @param id [String]
    def customer(id)
      connection.get("customers/#{id}")
    end

    # @param attributes [Hash]
    def customer_create(attributes)
      connection.post('customers', body: attributes)
    end

    # @param id [String]
    # @param attributes [Hash]
    def customer_update(id, attributes)
      connection.patch("customers/#{id}", body: attributes)
    end

    # @param id [String]
    def customer_delete(id)
      connection.delete("customers/#{id}")
    end

    def connection
      @connection ||= Connection.new
    end
  end
end
