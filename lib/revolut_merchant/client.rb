# frozen_string_literal: true

module RevolutMerchant
  module Client
    module_function

    def customers
      connection.get('customers')
    end

    # @param customer_id [String]
    def customer(customer_id)
      connection.get("customers/#{customer_id}")
    end

    # @param attributes [Hash]
    def customer_create(attributes)
      connection.post('customers', body: attributes)
    end

    # @param customer_id [String]
    # @param attributes [Hash]
    def customer_update(customer_id, attributes)
      connection.patch("customers/#{customer_id}", body: attributes)
    end

    # @param customer_id [String]
    def customer_delete(customer_id)
      connection.delete("customers/#{customer_id}")
    end

    # @param customer_id [String]
    # @param query [Hash,nil]
    def payment_methods(customer_id, query = nil)
      connection.get("customers/#{customer_id}/payment-methods", query:)
    end

    # @param customer_id [String]
    # @param payment_method_id [String]
    def payment_method(customer_id, payment_method_id)
      connection.get("customers/#{customer_id}/payment-methods/#{payment_method_id}")
    end

    # @param customer_id [String]
    # @param payment_method_id [String]
    # @param attributes [Hash]
    def payment_method_update(customer_id, payment_method_id, attributes)
      connection.patch("customers/#{customer_id}/payment-methods/#{payment_method_id}", body: attributes)
    end

    # @param customer_id [String]
    # @param payment_method_id [String]
    def payment_method_delete(customer_id, payment_method_id)
      connection.delete("customers/#{customer_id}/payment-methods/#{payment_method_id}")
    end

    # @param attributes [Hash]
    def order_create(attributes)
      connection.post('orders', body: attributes)
    end

    # @param id [String]
    def order(id)
      connection.get("orders/#{id}")
    end

    # @param query [Hash,nil]
    def orders(query = nil)
      connection.get('orders', query:)
    end

    # @param id [String]
    # @param attributes [Hash,nil]
    def order_capture(id, attributes = nil)
      connection.post("orders/#{id}/capture", body: attributes)
    end

    # @param id [String]
    # @param attributes [Hash,nil]
    def order_confirm(id, attributes = nil)
      connection.post("orders/#{id}/confirm", body: attributes)
    end

    # @param id [String]
    # @param attributes [Hash]
    def order_refund(id, attributes)
      connection.post("orders/#{id}/refund", body: attributes)
    end

    # @param id [String]
    # @param attributes [Hash]
    def order_update(id, attributes)
      connection.patch("orders/#{id}", body: attributes)
    end

    # @param id [String]
    def order_cancel(id)
      connection.post("orders/#{id}/cancel")
    end

    def connection
      @connection ||= Connection.new
    end
  end
end
