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

customer = RevolutMerchant::Client.customer_create(
  email: "j.e+#{Time.now.to_i}@q.com",
  full_name: 'John Example'
)

order = RevolutMerchant::Client.order_create(
  customer_id: customer[:id],
  amount: 100, # $1.00
  currency: RevolutMerchant::CONST::CURRENCY_USD,
  description: 'Create Payment Method - Order',
  capture_mode: RevolutMerchant::CONST::CAPTURE_MODE_MANUAL,
  enforce_challenge: RevolutMerchant::CONST::ENFORCE_CHALLENGE_FORCED
)

# puts order[:checkout_url]
html_file = File.expand_path('pay.html', __dir__)
puts 'Test Card #2  4929420573595709'
puts 'Test Card #1  5281438801804148'
puts "file://#{html_file}?o=#{order[:public_id]}"
puts $stdin.gets("\n")

RevolutMerchant::Client.order_capture(order[:id])

RevolutMerchant::Client.order_refund(
  order[:id],
  amount: 100, # $1.00
  description: 'Create Payment Method - Refund'
)

order = RevolutMerchant::Client.order(order[:id])
payment_method = order[:payments].last[:payment_method]
RevolutMerchant::Client.payment_method(customer[:id], payment_method[:id])

# /bin/bash -c "/home/senid/.rvm/bin/rvm ruby-3.1.2@revolut do /home/senid/.rvm/rubies/ruby-3.1.2/bin/ruby /home/senid/projects/my/revolut-merchant/examples/create_payment_method.rb"
# I, [2023-03-27T10:41:07.673663 #40715]  INFO -- request: POST https://sandbox-merchant.revolut.com/api/1.0/customers
# I, [2023-03-27T10:41:07.673713 #40715]  INFO -- request: Content-Type: "application/json"
# Accept: "application/json"
# User-Agent: "RevolutMerchant 0.1.0 Ruby 3.1.2"
# Authorization: "Bearer sk_3xDoIAOzaX_tZSgM6zQzBuvSxEVVDpI0AxFaG3hd_1fvbBOT_VcmcN2fwN2s89gb"
# I, [2023-03-27T10:41:07.673731 #40715]  INFO -- request: {"email":"j.e+1679902867@q.com","full_name":"John Example"}
# I, [2023-03-27T10:41:07.925861 #40715]  INFO -- response: Status 201
# I, [2023-03-27T10:41:07.925962 #40715]  INFO -- response: server: "nginx"
# date: "Mon, 27 Mar 2023 07:41:07 GMT"
# content-type: "application/json;charset=utf-8"
# transfer-encoding: "chunked"
# request-id: "12SEFQ48J2KPU"
# strict-transport-security: "max-age=63072000; includeSubdomains;"
# x-frame-options: "DENY"
# x-content-type-options: "nosniff"
# x-xss-protection: "1; mode=block"
# referrer-policy: "no-referrer"
# via: "1.1 google"
# alt-svc: "h3=\":443\"; ma=2592000,h3-29=\":443\"; ma=2592000,h3-Q050=\":443\"; ma=2592000,h3-Q046=\":443\"; ma=2592000,h3-Q043=\":443\"; ma=2592000,quic=\":443\"; ma=2592000; v=\"46,43\""
# I, [2023-03-27T10:41:07.926032 #40715]  INFO -- response: {"id":"879a93b1-759a-44dd-9ed0-34335172ca95","full_name":"John Example","email":"j.e+1679902867@q.com","created_at":"2023-03-27T07:41:07.899814Z","updated_at":"2023-03-27T07:41:07.899814Z"}
# I, [2023-03-27T10:41:07.926781 #40715]  INFO -- request: POST https://sandbox-merchant.revolut.com/api/1.0/orders
# I, [2023-03-27T10:41:07.926827 #40715]  INFO -- request: Content-Type: "application/json"
# Accept: "application/json"
# User-Agent: "RevolutMerchant 0.1.0 Ruby 3.1.2"
# Authorization: "Bearer sk_3xDoIAOzaX_tZSgM6zQzBuvSxEVVDpI0AxFaG3hd_1fvbBOT_VcmcN2fwN2s89gb"
# I, [2023-03-27T10:41:07.926855 #40715]  INFO -- request: {"customer_id":"879a93b1-759a-44dd-9ed0-34335172ca95","amount":100,"currency":"USD","description":"Create Payment Method - Order","capture_mode":"MANUAL","enforce_challenge":"FORCED"}
# I, [2023-03-27T10:41:08.207728 #40715]  INFO -- response: Status 201
# I, [2023-03-27T10:41:08.207793 #40715]  INFO -- response: server: "nginx"
# date: "Mon, 27 Mar 2023 07:41:08 GMT"
# content-type: "application/json;charset=utf-8"
# transfer-encoding: "chunked"
# request-id: "2R0UH7MT3ZIT"
# strict-transport-security: "max-age=63072000; includeSubdomains;"
# x-frame-options: "DENY"
# x-content-type-options: "nosniff"
# x-xss-protection: "1; mode=block"
# referrer-policy: "no-referrer"
# via: "1.1 google"
# alt-svc: "h3=\":443\"; ma=2592000,h3-29=\":443\"; ma=2592000,h3-Q050=\":443\"; ma=2592000,h3-Q046=\":443\"; ma=2592000,h3-Q043=\":443\"; ma=2592000,quic=\":443\"; ma=2592000; v=\"46,43\""
# I, [2023-03-27T10:41:08.207838 #40715]  INFO -- response: {"id":"64214894-3aff-aa67-89aa-5d5d5ea871cd","public_id":"01b8c06c-679b-475d-ad08-c913b3624f97","type":"PAYMENT","state":"PENDING","created_at":"2023-03-27T07:41:08.151024Z","updated_at":"2023-03-27T07:41:08.151024Z","description":"Create Payment Method - Order","capture_mode":"MANUAL","customer_id":"879a93b1-759a-44dd-9ed0-34335172ca95","email":"j.e+1679902867@q.com","order_amount":{"value":100,"currency":"USD"},"order_outstanding_amount":{"value":100,"currency":"USD"},"metadata":{},"checkout_url":"https://sandbox-business.revolut.com/payment-link/rQjJE7NiT5cBuMBsZ5tHXQ"}
# file:///home/senid/projects/my/revolut-merchant/examples/pay.html?o=01b8c06c-679b-475d-ad08-c913b3624f97
#
#
# I, [2023-03-27T10:41:57.399386 #40715]  INFO -- request: POST https://sandbox-merchant.revolut.com/api/1.0/orders/64214894-3aff-aa67-89aa-5d5d5ea871cd/capture
# I, [2023-03-27T10:41:57.399432 #40715]  INFO -- request: Content-Type: "application/json"
# Accept: "application/json"
# User-Agent: "RevolutMerchant 0.1.0 Ruby 3.1.2"
# Authorization: "Bearer sk_3xDoIAOzaX_tZSgM6zQzBuvSxEVVDpI0AxFaG3hd_1fvbBOT_VcmcN2fwN2s89gb"
# I, [2023-03-27T10:41:57.765407 #40715]  INFO -- response: Status 200
# I, [2023-03-27T10:41:57.765467 #40715]  INFO -- response: server: "nginx"
# date: "Mon, 27 Mar 2023 07:41:57 GMT"
# content-type: "application/json;charset=utf-8"
# vary: "Accept-Encoding"
# request-id: "NN2TAL1WNSZ"
# strict-transport-security: "max-age=63072000; includeSubdomains;"
# x-frame-options: "DENY"
# x-content-type-options: "nosniff"
# x-xss-protection: "1; mode=block"
# referrer-policy: "no-referrer"
# content-encoding: "gzip"
# via: "1.1 google"
# alt-svc: "h3=\":443\"; ma=2592000,h3-29=\":443\"; ma=2592000,h3-Q050=\":443\"; ma=2592000,h3-Q046=\":443\"; ma=2592000,h3-Q043=\":443\"; ma=2592000,quic=\":443\"; ma=2592000; v=\"46,43\""
# transfer-encoding: "chunked"
# I, [2023-03-27T10:41:57.765505 #40715]  INFO -- response: {"id":"64214894-3aff-aa67-89aa-5d5d5ea871cd","public_id":"01b8c06c-679b-475d-ad08-c913b3624f97","type":"PAYMENT","state":"COMPLETED","created_at":"2023-03-27T07:41:08.151024Z","updated_at":"2023-03-27T07:41:57.646165Z","completed_at":"2023-03-27T07:41:57.640Z","description":"Create Payment Method - Order","capture_mode":"MANUAL","customer_id":"879a93b1-759a-44dd-9ed0-34335172ca95","email":"j.e+1679902867@q.com","order_amount":{"value":100,"currency":"USD"},"order_outstanding_amount":{"value":0,"currency":"USD"},"refunded_amount":{"value":0,"currency":"USD"},"metadata":{},"payments":[{"id":"642148c0-74e8-adf5-9972-c44a64c3ff6b","state":"CAPTURED","created_at":"2023-03-27T07:41:52.563336Z","updated_at":"2023-03-27T07:41:57.648888Z","token":"8357ffea-1ad0-4696-85fb-2adc104d44fe","amount":{"value":100,"currency":"USD"},"authorised_amount":{"value":100,"currency":"USD"},"settled_amount":{"value":100,"currency":"USD"},"payment_method":{"id":"642148c0-c386-a147-85e8-2e588414148d","type":"CARD","card":{"card_brand":"VISA","card_bin":"492942","funding":"DEBIT","card_country":"GB","card_last_four":"5709","card_expiry":"11/2025","cardholder_name":"qwe asd","checks":{"three_ds":{"state":"VERIFIED","version":2}}}},"billing_address":{"street_line_1":"Revolut","street_line_2":"1 Canada Square","region":"Greater London","city":"London","country_code":"GB","postcode":"EC2V 6DN"},"risk_level":"LOW","fees":[]}]}
# I, [2023-03-27T10:41:57.765951 #40715]  INFO -- request: POST https://sandbox-merchant.revolut.com/api/1.0/orders/64214894-3aff-aa67-89aa-5d5d5ea871cd/refund
# I, [2023-03-27T10:41:57.765978 #40715]  INFO -- request: Content-Type: "application/json"
# Accept: "application/json"
# User-Agent: "RevolutMerchant 0.1.0 Ruby 3.1.2"
# Authorization: "Bearer sk_3xDoIAOzaX_tZSgM6zQzBuvSxEVVDpI0AxFaG3hd_1fvbBOT_VcmcN2fwN2s89gb"
# I, [2023-03-27T10:41:57.766001 #40715]  INFO -- request: {"amount":100,"description":"Create Payment Method - Refund"}
# I, [2023-03-27T10:41:58.543126 #40715]  INFO -- response: Status 201
# I, [2023-03-27T10:41:58.543182 #40715]  INFO -- response: server: "nginx"
# date: "Mon, 27 Mar 2023 07:41:58 GMT"
# content-type: "application/json;charset=utf-8"
# transfer-encoding: "chunked"
# request-id: "1344MHMEFE5L3"
# strict-transport-security: "max-age=63072000; includeSubdomains;"
# x-frame-options: "DENY"
# x-content-type-options: "nosniff"
# x-xss-protection: "1; mode=block"
# referrer-policy: "no-referrer"
# via: "1.1 google"
# alt-svc: "h3=\":443\"; ma=2592000,h3-29=\":443\"; ma=2592000,h3-Q050=\":443\"; ma=2592000,h3-Q046=\":443\"; ma=2592000,h3-Q043=\":443\"; ma=2592000,quic=\":443\"; ma=2592000; v=\"46,43\""
# I, [2023-03-27T10:41:58.543219 #40715]  INFO -- response: {"id":"642148c6-c984-a187-b106-6b383152d98d","type":"REFUND","state":"PROCESSING","created_at":"2023-03-27T07:41:58.062281Z","updated_at":"2023-03-27T07:41:58.074939Z","description":"Create Payment Method - Refund","customer_id":"879a93b1-759a-44dd-9ed0-34335172ca95","email":"j.e+1679902867@q.com","order_amount":{"value":100,"currency":"USD"},"order_outstanding_amount":{"value":100,"currency":"USD"},"metadata":{},"payments":[{"id":"642148c6-2b4e-a90e-8e10-c2abd416a215","state":"PROCESSING","created_at":"2023-03-27T07:41:58.074665Z","updated_at":"2023-03-27T07:41:58.381952Z"}],"related":[{"id":"64214894-3aff-aa67-89aa-5d5d5ea871cd","type":"PAYMENT","state":"COMPLETED","amount":{"value":100,"currency":"USD"}}]}
# I, [2023-03-27T10:41:58.543537 #40715]  INFO -- request: GET https://sandbox-merchant.revolut.com/api/1.0/orders/64214894-3aff-aa67-89aa-5d5d5ea871cd
# I, [2023-03-27T10:41:58.543560 #40715]  INFO -- request: Content-Type: "application/json"
# Accept: "application/json"
# User-Agent: "RevolutMerchant 0.1.0 Ruby 3.1.2"
# Authorization: "Bearer sk_3xDoIAOzaX_tZSgM6zQzBuvSxEVVDpI0AxFaG3hd_1fvbBOT_VcmcN2fwN2s89gb"
# I, [2023-03-27T10:41:58.868873 #40715]  INFO -- response: Status 200
# I, [2023-03-27T10:41:58.868930 #40715]  INFO -- response: server: "nginx"
# date: "Mon, 27 Mar 2023 07:41:58 GMT"
# content-type: "application/json;charset=utf-8"
# vary: "Accept-Encoding"
# request-id: "108RT5KA255WQ"
# strict-transport-security: "max-age=63072000; includeSubdomains;"
# x-frame-options: "DENY"
# x-content-type-options: "nosniff"
# x-xss-protection: "1; mode=block"
# referrer-policy: "no-referrer"
# content-encoding: "gzip"
# via: "1.1 google"
# alt-svc: "h3=\":443\"; ma=2592000,h3-29=\":443\"; ma=2592000,h3-Q050=\":443\"; ma=2592000,h3-Q046=\":443\"; ma=2592000,h3-Q043=\":443\"; ma=2592000,quic=\":443\"; ma=2592000; v=\"46,43\""
# transfer-encoding: "chunked"
# I, [2023-03-27T10:41:58.868955 #40715]  INFO -- response: {"id":"64214894-3aff-aa67-89aa-5d5d5ea871cd","public_id":"01b8c06c-679b-475d-ad08-c913b3624f97","type":"PAYMENT","state":"COMPLETED","created_at":"2023-03-27T07:41:08.151024Z","updated_at":"2023-03-27T07:41:57.646165Z","completed_at":"2023-03-27T07:41:57.640Z","description":"Create Payment Method - Order","capture_mode":"MANUAL","customer_id":"879a93b1-759a-44dd-9ed0-34335172ca95","email":"j.e+1679902867@q.com","order_amount":{"value":100,"currency":"USD"},"order_outstanding_amount":{"value":0,"currency":"USD"},"refunded_amount":{"value":100,"currency":"USD"},"metadata":{},"payments":[{"id":"642148c0-74e8-adf5-9972-c44a64c3ff6b","state":"CAPTURED","created_at":"2023-03-27T07:41:52.563336Z","updated_at":"2023-03-27T07:41:58.165164Z","token":"8357ffea-1ad0-4696-85fb-2adc104d44fe","amount":{"value":100,"currency":"USD"},"authorised_amount":{"value":100,"currency":"USD"},"settled_amount":{"value":100,"currency":"USD"},"payment_method":{"id":"642148c0-c386-a147-85e8-2e588414148d","type":"CARD","card":{"card_brand":"VISA","card_bin":"492942","funding":"DEBIT","card_country":"GB","card_last_four":"5709","card_expiry":"11/2025","cardholder_name":"qwe asd","checks":{"three_ds":{"state":"VERIFIED","version":2}}}},"billing_address":{"street_line_1":"Revolut","street_line_2":"1 Canada Square","region":"Greater London","city":"London","country_code":"GB","postcode":"EC2V 6DN"},"risk_level":"LOW","fees":[]}],"related":[{"id":"642148c6-c984-a187-b106-6b383152d98d","type":"REFUND","state":"COMPLETED","amount":{"value":100,"currency":"USD"}}]}
# {
#   "id": "642148c0-c386-a147-85e8-2e588414148d",
#   "type": "CARD",
#   "card": {
#     "card_brand": "VISA",
#     "card_bin": "492942",
#     "funding": "DEBIT",
#     "card_country": "GB",
#     "card_last_four": "5709",
#     "card_expiry": "11/2025",
#     "cardholder_name": "qwe asd",
#     "checks": {
#       "three_ds": {
#         "state": "VERIFIED",
#         "version": 2
#       }
#     }
#   }
# }
#
# Process finished with exit code 0
