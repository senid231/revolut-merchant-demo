# frozen_string_literal: true

module RevolutMerchant
  module Client
    module_function

    # @return [Array]
    # @raise [RevolutMerchant::Errors::ApiError]
    def customers
      connection.get('/api/1.0/customers')
    end

    # @param customer_id [String]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def customer(customer_id)
      connection.get("/api/1.0/customers/#{customer_id}")
    end

    # @param attributes [Hash]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def customer_create(attributes)
      connection.post('/api/1.0/customers', body: attributes)
    end

    # @param customer_id [String]
    # @param attributes [Hash]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def customer_update(customer_id, attributes)
      connection.patch("/api/1.0/customers/#{customer_id}", body: attributes)
    end

    # @param customer_id [String]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def customer_delete(customer_id)
      connection.delete("/api/1.0/customers/#{customer_id}")
    end

    # @param customer_id [String]
    # @param query [Hash,nil]
    # @return [Array]
    # @raise [RevolutMerchant::Errors::ApiError]
    def payment_methods(customer_id, query = nil)
      connection.get("/api/1.0/customers/#{customer_id}/payment-methods", query:)
    end

    # @param customer_id [String]
    # @param payment_method_id [String]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def payment_method(customer_id, payment_method_id)
      connection.get("/api/1.0/customers/#{customer_id}/payment-methods/#{payment_method_id}")
    end

    # @param customer_id [String]
    # @param payment_method_id [String]
    # @param attributes [Hash]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def payment_method_update(customer_id, payment_method_id, attributes)
      connection.patch("/api/1.0/customers/#{customer_id}/payment-methods/#{payment_method_id}", body: attributes)
    end

    # @param customer_id [String]
    # @param payment_method_id [String]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def payment_method_delete(customer_id, payment_method_id)
      connection.delete("/api/1.0/customers/#{customer_id}/payment-methods/#{payment_method_id}")
    end

    # @param query [Hash,nil]
    # @return [Array]
    # @raise [RevolutMerchant::Errors::ApiError]
    def orders(query = nil)
      connection.get('/api/1.0/orders', query:)
    end

    # @param attributes [Hash]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def order_create(attributes)
      connection.post('/api/1.0/orders', body: attributes)
    end

    # @param order_id [String]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def order(order_id)
      connection.get("/api/1.0/orders/#{order_id}")
    end

    # @param order_id [String]
    # @param attributes [Hash,nil]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def order_capture(order_id, attributes = nil)
      connection.post("/api/1.0/orders/#{order_id}/capture", body: attributes)
    end

    # @param order_id [String]
    # @param attributes [Hash]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def order_refund(order_id, attributes)
      connection.post("/api/1.0/orders/#{order_id}/refund", body: attributes)
    end

    # @param order_id [String]
    # @param attributes [Hash]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def order_update(order_id, attributes)
      connection.patch("/api/1.0/orders/#{order_id}", body: attributes)
    end

    # @param order_id [String]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def order_cancel(order_id)
      connection.post("/api/1.0/orders/#{order_id}/cancel")
    end

    # @param payment_id [String]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def payment(payment_id)
      connection.get("/api/payments/#{payment_id}")
    end

    # @param order_id [String]
    # @param attributes [Hash]
    # @return [Hash]
    # @raise [RevolutMerchant::Errors::ApiError]
    def payment_create(order_id, attributes)
      connection.post("/api/orders/#{order_id}/payments", body: attributes)
    end

    def connection
      @connection ||= Connection.new
    end
  end
end
