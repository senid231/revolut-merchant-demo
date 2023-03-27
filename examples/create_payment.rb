# frozen_string_literal: true

require_relative '../lib/revolut_merchant'
require 'logger'

RevolutMerchant.configure do |config|
  config.secret_key = ENV.fetch('REVOLUT_SECRET_KEY')
  config.mode = RevolutMerchant::CONST::MODE_SANDBOX
  config.logger = Logger.new($stdout)
  config.on_error = ->(error) do
    config.logger.error { "RevolutMerchant ERROR <#{error.class}> #{error.message}" }
    # Rails.logger.error { "#{error.env.method.upcase} #{error.env.url}: #{error.status})\n#{error.response_body}" }
  end
end

# customer created in ./create_payment_method
customer = RevolutMerchant::Client.customer('879a93b1-759a-44dd-9ed0-34335172ca95')
payment_method = RevolutMerchant::Client.payment_methods(customer[:id]).sample

order = RevolutMerchant::Client.order_create(
  customer_id: customer[:id],
  amount: 12_345, # $123.45
  currency: RevolutMerchant::CONST::CURRENCY_USD,
  description: 'Payment',
  capture_mode: RevolutMerchant::CONST::CAPTURE_MODE_MANUAL,
  enforce_challenge: RevolutMerchant::CONST::ENFORCE_CHALLENGE_FORCED
)

RevolutMerchant::Client.payment_create(
  order[:id],
  saved_payment_method: {
    type: 'card',
    id: payment_method[:id],
    initiator: 'merchant'
  }
)

RevolutMerchant::Client.order(order[:id])
RevolutMerchant::Client.order_capture(order[:id])

# /bin/bash -c "/home/senid/.rvm/bin/rvm ruby-3.1.2@revolut do /home/senid/.rvm/rubies/ruby-3.1.2/bin/ruby /home/senid/projects/my/revolut-merchant/examples/create_payment.rb"
# I, [2023-03-27T10:48:21.250858 #54843]  INFO -- request: GET https://sandbox-merchant.revolut.com/api/1.0/customers/879a93b1-759a-44dd-9ed0-34335172ca95
# I, [2023-03-27T10:48:21.250911 #54843]  INFO -- request: Content-Type: "application/json"
# Accept: "application/json"
# User-Agent: "RevolutMerchant 0.1.0 Ruby 3.1.2"
# Authorization: "Bearer sk_3xDoIAOzaX_tZSgM6zQzBuvSxEVVDpI0AxFaG3hd_1fvbBOT_VcmcN2fwN2s89gb"
# I, [2023-03-27T10:48:21.504876 #54843]  INFO -- response: Status 200
# I, [2023-03-27T10:48:21.504929 #54843]  INFO -- response: server: "nginx"
# date: "Mon, 27 Mar 2023 07:48:21 GMT"
# content-type: "application/json;charset=utf-8"
# vary: "Accept-Encoding"
# request-id: "14P098AX2WK5L"
# strict-transport-security: "max-age=63072000; includeSubdomains;"
# x-frame-options: "DENY"
# x-content-type-options: "nosniff"
# x-xss-protection: "1; mode=block"
# referrer-policy: "no-referrer"
# content-encoding: "gzip"
# via: "1.1 google"
# alt-svc: "h3=\":443\"; ma=2592000,h3-29=\":443\"; ma=2592000,h3-Q050=\":443\"; ma=2592000,h3-Q046=\":443\"; ma=2592000,h3-Q043=\":443\"; ma=2592000,quic=\":443\"; ma=2592000; v=\"46,43\""
# transfer-encoding: "chunked"
# I, [2023-03-27T10:48:21.504955 #54843]  INFO -- response: {"id":"879a93b1-759a-44dd-9ed0-34335172ca95","full_name":"John Example","email":"j.e+1679902867@q.com","created_at":"2023-03-27T07:41:07.899814Z","updated_at":"2023-03-27T07:41:52.811637Z","payment_methods":[{"id":"642148c0-c386-a147-85e8-2e588414148d","type":"CARD","saved_for":"MERCHANT","method_details":{"bin":"492942","last4":"5709","expiry_month":11,"expiry_year":2025,"cardholder_name":"qwe asd","funding":"DEBIT","country_code":"GB","billing_address":{"street_line_1":"Revolut","street_line_2":"1 Canada Square","post_code":"EC2V 6DN","city":"London","region":"Greater London","country_code":"GB"}}}]}
# I, [2023-03-27T10:48:21.505339 #54843]  INFO -- request: GET https://sandbox-merchant.revolut.com/api/1.0/customers/879a93b1-759a-44dd-9ed0-34335172ca95/payment-methods
# I, [2023-03-27T10:48:21.505361 #54843]  INFO -- request: Content-Type: "application/json"
# Accept: "application/json"
# User-Agent: "RevolutMerchant 0.1.0 Ruby 3.1.2"
# Authorization: "Bearer sk_3xDoIAOzaX_tZSgM6zQzBuvSxEVVDpI0AxFaG3hd_1fvbBOT_VcmcN2fwN2s89gb"
# I, [2023-03-27T10:48:21.763342 #54843]  INFO -- response: Status 200
# I, [2023-03-27T10:48:21.763394 #54843]  INFO -- response: server: "nginx"
# date: "Mon, 27 Mar 2023 07:48:21 GMT"
# content-type: "application/json;charset=utf-8"
# vary: "Accept-Encoding"
# request-id: "1YEZ4E6BQS9P"
# strict-transport-security: "max-age=63072000; includeSubdomains;"
# x-frame-options: "DENY"
# x-content-type-options: "nosniff"
# x-xss-protection: "1; mode=block"
# referrer-policy: "no-referrer"
# content-encoding: "gzip"
# via: "1.1 google"
# alt-svc: "h3=\":443\"; ma=2592000,h3-29=\":443\"; ma=2592000,h3-Q050=\":443\"; ma=2592000,h3-Q046=\":443\"; ma=2592000,h3-Q043=\":443\"; ma=2592000,quic=\":443\"; ma=2592000; v=\"46,43\""
# transfer-encoding: "chunked"
# I, [2023-03-27T10:48:21.763416 #54843]  INFO -- response: [{"id":"642148c0-c386-a147-85e8-2e588414148d","type":"CARD","saved_for":"MERCHANT","method_details":{"bin":"492942","last4":"5709","expiry_month":11,"expiry_year":2025,"cardholder_name":"qwe asd","funding":"DEBIT","country_code":"GB","billing_address":{"street_line_1":"Revolut","street_line_2":"1 Canada Square","post_code":"EC2V 6DN","city":"London","region":"Greater London","country_code":"GB"}}}]
# I, [2023-03-27T10:48:21.763912 #54843]  INFO -- request: POST https://sandbox-merchant.revolut.com/api/1.0/orders
# I, [2023-03-27T10:48:21.763933 #54843]  INFO -- request: Content-Type: "application/json"
# Accept: "application/json"
# User-Agent: "RevolutMerchant 0.1.0 Ruby 3.1.2"
# Authorization: "Bearer sk_3xDoIAOzaX_tZSgM6zQzBuvSxEVVDpI0AxFaG3hd_1fvbBOT_VcmcN2fwN2s89gb"
# I, [2023-03-27T10:48:21.763946 #54843]  INFO -- request: {"customer_id":"879a93b1-759a-44dd-9ed0-34335172ca95","amount":12345,"currency":"USD","description":"Payment","capture_mode":"MANUAL","enforce_challenge":"FORCED"}
# I, [2023-03-27T10:48:22.032083 #54843]  INFO -- response: Status 201
# I, [2023-03-27T10:48:22.032165 #54843]  INFO -- response: server: "nginx"
# date: "Mon, 27 Mar 2023 07:48:22 GMT"
# content-type: "application/json;charset=utf-8"
# transfer-encoding: "chunked"
# request-id: "1CR4BGSS7IR3A"
# strict-transport-security: "max-age=63072000; includeSubdomains;"
# x-frame-options: "DENY"
# x-content-type-options: "nosniff"
# x-xss-protection: "1; mode=block"
# referrer-policy: "no-referrer"
# via: "1.1 google"
# alt-svc: "h3=\":443\"; ma=2592000,h3-29=\":443\"; ma=2592000,h3-Q050=\":443\"; ma=2592000,h3-Q046=\":443\"; ma=2592000,h3-Q043=\":443\"; ma=2592000,quic=\":443\"; ma=2592000; v=\"46,43\""
# I, [2023-03-27T10:48:22.032216 #54843]  INFO -- response: {"id":"64214a45-0515-acc9-b63d-77eda617303b","public_id":"5b2792e3-4b91-47eb-801a-ccfceeff1245","type":"PAYMENT","state":"PENDING","created_at":"2023-03-27T07:48:21.990247Z","updated_at":"2023-03-27T07:48:21.990247Z","description":"Payment","capture_mode":"MANUAL","customer_id":"879a93b1-759a-44dd-9ed0-34335172ca95","email":"j.e+1679902867@q.com","order_amount":{"value":12345,"currency":"USD"},"order_outstanding_amount":{"value":12345,"currency":"USD"},"metadata":{},"checkout_url":"https://sandbox-business.revolut.com/payment-link/gBrM_O7_EkVbJ5LjS5FH6w"}
# I, [2023-03-27T10:48:22.032812 #54843]  INFO -- request: POST https://sandbox-merchant.revolut.com/api/orders/64214a45-0515-acc9-b63d-77eda617303b/payments
# I, [2023-03-27T10:48:22.032853 #54843]  INFO -- request: Content-Type: "application/json"
# Accept: "application/json"
# User-Agent: "RevolutMerchant 0.1.0 Ruby 3.1.2"
# Authorization: "Bearer sk_3xDoIAOzaX_tZSgM6zQzBuvSxEVVDpI0AxFaG3hd_1fvbBOT_VcmcN2fwN2s89gb"
# I, [2023-03-27T10:48:22.032882 #54843]  INFO -- request: {"saved_payment_method":{"type":"card","id":"642148c0-c386-a147-85e8-2e588414148d","initiator":"merchant"}}
# I, [2023-03-27T10:48:22.529796 #54843]  INFO -- response: Status 200
# I, [2023-03-27T10:48:22.529875 #54843]  INFO -- response: server: "nginx"
# date: "Mon, 27 Mar 2023 07:48:22 GMT"
# content-type: "application/json;charset=utf-8"
# vary: "Accept-Encoding"
# request-id: "T2FR0KJHMJ14"
# strict-transport-security: "max-age=63072000; includeSubdomains;"
# x-frame-options: "DENY"
# x-content-type-options: "nosniff"
# x-xss-protection: "1; mode=block"
# referrer-policy: "no-referrer"
# content-encoding: "gzip"
# via: "1.1 google"
# alt-svc: "h3=\":443\"; ma=2592000,h3-29=\":443\"; ma=2592000,h3-Q050=\":443\"; ma=2592000,h3-Q046=\":443\"; ma=2592000,h3-Q043=\":443\"; ma=2592000,quic=\":443\"; ma=2592000; v=\"46,43\""
# transfer-encoding: "chunked"
# I, [2023-03-27T10:48:22.529922 #54843]  INFO -- response: {"id":"64214a46-e188-a791-872f-b54810e00e2c","order_id":"64214a45-0515-acc9-b63d-77eda617303b","payment_method":{"type":"card"},"state":"authorisation_passed"}
# I, [2023-03-27T10:48:22.530361 #54843]  INFO -- request: GET https://sandbox-merchant.revolut.com/api/1.0/orders/64214a45-0515-acc9-b63d-77eda617303b
# I, [2023-03-27T10:48:22.530399 #54843]  INFO -- request: Content-Type: "application/json"
# Accept: "application/json"
# User-Agent: "RevolutMerchant 0.1.0 Ruby 3.1.2"
# Authorization: "Bearer sk_3xDoIAOzaX_tZSgM6zQzBuvSxEVVDpI0AxFaG3hd_1fvbBOT_VcmcN2fwN2s89gb"
# I, [2023-03-27T10:48:22.845255 #54843]  INFO -- response: Status 200
# I, [2023-03-27T10:48:22.845336 #54843]  INFO -- response: server: "nginx"
# date: "Mon, 27 Mar 2023 07:48:22 GMT"
# content-type: "application/json;charset=utf-8"
# vary: "Accept-Encoding"
# request-id: "OUNJ92MPFZOB"
# strict-transport-security: "max-age=63072000; includeSubdomains;"
# x-frame-options: "DENY"
# x-content-type-options: "nosniff"
# x-xss-protection: "1; mode=block"
# referrer-policy: "no-referrer"
# content-encoding: "gzip"
# via: "1.1 google"
# alt-svc: "h3=\":443\"; ma=2592000,h3-29=\":443\"; ma=2592000,h3-Q050=\":443\"; ma=2592000,h3-Q046=\":443\"; ma=2592000,h3-Q043=\":443\"; ma=2592000,quic=\":443\"; ma=2592000; v=\"46,43\""
# transfer-encoding: "chunked"
# I, [2023-03-27T10:48:22.845395 #54843]  INFO -- response: {"id":"64214a45-0515-acc9-b63d-77eda617303b","public_id":"5b2792e3-4b91-47eb-801a-ccfceeff1245","type":"PAYMENT","state":"AUTHORISED","created_at":"2023-03-27T07:48:21.990247Z","updated_at":"2023-03-27T07:48:22.551990Z","description":"Payment","capture_mode":"MANUAL","customer_id":"879a93b1-759a-44dd-9ed0-34335172ca95","email":"j.e+1679902867@q.com","order_amount":{"value":12345,"currency":"USD"},"order_outstanding_amount":{"value":12345,"currency":"USD"},"refunded_amount":{"value":0,"currency":"USD"},"metadata":{},"checkout_url":"https://sandbox-business.revolut.com/payment-link/gBrM_O7_EkVbJ5LjS5FH6w","payments":[{"id":"64214a46-e188-a791-872f-b54810e00e2c","state":"AUTHORISED","created_at":"2023-03-27T07:48:22.376339Z","updated_at":"2023-03-27T07:48:22.553479Z","amount":{"value":12345,"currency":"USD"},"authorised_amount":{"value":12345,"currency":"USD"},"settled_amount":{"value":12345,"currency":"USD"},"payment_method":{"id":"642148c0-c386-a147-85e8-2e588414148d","type":"CARD","card":{"card_brand":"VISA","card_bin":"492942","funding":"DEBIT","card_country":"GB","card_last_four":"5709","card_expiry":"11/2025","cardholder_name":"qwe asd","checks":{}}},"billing_address":{"street_line_1":"Revolut","street_line_2":"1 Canada Square","region":"Greater London","city":"London","country_code":"GB","postcode":"EC2V 6DN"},"risk_level":"LOW","fees":[]}]}
# I, [2023-03-27T10:48:22.846336 #54843]  INFO -- request: POST https://sandbox-merchant.revolut.com/api/1.0/orders/64214a45-0515-acc9-b63d-77eda617303b/capture
# I, [2023-03-27T10:48:22.846382 #54843]  INFO -- request: Content-Type: "application/json"
# Accept: "application/json"
# User-Agent: "RevolutMerchant 0.1.0 Ruby 3.1.2"
# Authorization: "Bearer sk_3xDoIAOzaX_tZSgM6zQzBuvSxEVVDpI0AxFaG3hd_1fvbBOT_VcmcN2fwN2s89gb"
# I, [2023-03-27T10:48:23.278060 #54843]  INFO -- response: Status 200
# I, [2023-03-27T10:48:23.278153 #54843]  INFO -- response: server: "nginx"
# date: "Mon, 27 Mar 2023 07:48:23 GMT"
# content-type: "application/json;charset=utf-8"
# vary: "Accept-Encoding"
# request-id: "1LFPV26D88W9V"
# strict-transport-security: "max-age=63072000; includeSubdomains;"
# x-frame-options: "DENY"
# x-content-type-options: "nosniff"
# x-xss-protection: "1; mode=block"
# referrer-policy: "no-referrer"
# content-encoding: "gzip"
# via: "1.1 google"
# alt-svc: "h3=\":443\"; ma=2592000,h3-29=\":443\"; ma=2592000,h3-Q050=\":443\"; ma=2592000,h3-Q046=\":443\"; ma=2592000,h3-Q043=\":443\"; ma=2592000,quic=\":443\"; ma=2592000; v=\"46,43\""
# transfer-encoding: "chunked"
# I, [2023-03-27T10:48:23.278201 #54843]  INFO -- response: {"id":"64214a45-0515-acc9-b63d-77eda617303b","public_id":"5b2792e3-4b91-47eb-801a-ccfceeff1245","type":"PAYMENT","state":"COMPLETED","created_at":"2023-03-27T07:48:21.990247Z","updated_at":"2023-03-27T07:48:23.079261Z","completed_at":"2023-03-27T07:48:23.073Z","description":"Payment","capture_mode":"MANUAL","customer_id":"879a93b1-759a-44dd-9ed0-34335172ca95","email":"j.e+1679902867@q.com","order_amount":{"value":12345,"currency":"USD"},"order_outstanding_amount":{"value":0,"currency":"USD"},"refunded_amount":{"value":0,"currency":"USD"},"metadata":{},"payments":[{"id":"64214a46-e188-a791-872f-b54810e00e2c","state":"CAPTURED","created_at":"2023-03-27T07:48:22.376339Z","updated_at":"2023-03-27T07:48:23.081870Z","amount":{"value":12345,"currency":"USD"},"authorised_amount":{"value":12345,"currency":"USD"},"settled_amount":{"value":12345,"currency":"USD"},"payment_method":{"id":"642148c0-c386-a147-85e8-2e588414148d","type":"CARD","card":{"card_brand":"VISA","card_bin":"492942","funding":"DEBIT","card_country":"GB","card_last_four":"5709","card_expiry":"11/2025","cardholder_name":"qwe asd","checks":{}}},"billing_address":{"street_line_1":"Revolut","street_line_2":"1 Canada Square","region":"Greater London","city":"London","country_code":"GB","postcode":"EC2V 6DN"},"risk_level":"LOW","fees":[]}]}
#
# Process finished with exit code 0
