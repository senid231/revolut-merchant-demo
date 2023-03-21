# frozen_string_literal: true

module RevolutMerchant
  module Client
    module_function

    # @return [Array]
    # @raise [RevolutMerchant::Errors::ApiError]
    def customers
      connection.get('customers')
    end

    # @param customer_id [String]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def customer(customer_id)
      connection.get("customers/#{customer_id}")
    end

    # @param attributes [Hash]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def customer_create(attributes)
      connection.post('customers', body: attributes)
    end

    # @param customer_id [String]
    # @param attributes [Hash]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def customer_update(customer_id, attributes)
      connection.patch("customers/#{customer_id}", body: attributes)
    end

    # @param customer_id [String]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def customer_delete(customer_id)
      connection.delete("customers/#{customer_id}")
    end

    # @param customer_id [String]
    # @param query [Hash,nil]
    # @return [Array]
    # @raise [RevolutMerchant::Errors::ApiError]
    def payment_methods(customer_id, query = nil)
      connection.get("customers/#{customer_id}/payment-methods", query:)
    end

    # @param customer_id [String]
    # @param payment_method_id [String]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def payment_method(customer_id, payment_method_id)
      connection.get("customers/#{customer_id}/payment-methods/#{payment_method_id}")
    end

    # @param customer_id [String]
    # @param payment_method_id [String]
    # @param attributes [Hash]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def payment_method_update(customer_id, payment_method_id, attributes)
      connection.patch("customers/#{customer_id}/payment-methods/#{payment_method_id}", body: attributes)
    end

    # @param customer_id [String]
    # @param payment_method_id [String]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def payment_method_delete(customer_id, payment_method_id)
      connection.delete("customers/#{customer_id}/payment-methods/#{payment_method_id}")
    end

    # @param query [Hash,nil]
    # @return [Array]
    # @raise [RevolutMerchant::Errors::ApiError]
    def orders(query = nil)
      connection.get('orders', query:)
    end

    # @param attributes [Hash]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def order_create(attributes)
      connection.post('orders', body: attributes)
    end

    # @param order_id [String]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def order(order_id)
      connection.get("orders/#{order_id}")
    end

    # @param order_id [String]
    # @param attributes [Hash,nil]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def order_capture(order_id, attributes = nil)
      connection.post("orders/#{order_id}/capture", body: attributes)
    end

    # @param order_id [String]
    # @param attributes [Hash]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def order_refund(order_id, attributes)
      connection.post("orders/#{order_id}/refund", body: attributes)
    end

    # @param order_id [String]
    # @param attributes [Hash]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def order_update(order_id, attributes)
      connection.patch("orders/#{order_id}", body: attributes)
    end

    # @param order_id [String]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def order_cancel(order_id)
      connection.post("orders/#{order_id}/cancel")
    end

    # @param payment_id [String]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def payment(payment_id)
      connection.get("payments/#{payment_id}")
    end

    # @param order_id [String]
    # @param attributes [Hash]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def payment_create(order_id, attributes)
      connection.post("orders/#{order_id}/payments", body: attributes)
    end

    def connection
      @connection ||= Connection.new
    end
  end
end
