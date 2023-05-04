# Revolut Merchant

Concept of revolut merchant API integration with Rails application.

Inspired by [jpalumickas/revolut-ruby](https://github.com/jpalumickas/revolut-ruby)

## Requirements
Ruby: 3.1.2  
SQLite: 3

## Installation

```shell
ruby bin/setup
```

## Test cards

https://developer.revolut.com/docs/accept-payments/tutorials/test-in-the-sandbox-environment/test-cards/
```
4929420573595709	VISA  
5281438801804148	MASTERCARD
```
## Running

```shell
bundle exec rails server -b 127.0.0.1 -p 3000
```

## Problems

1. Can't test case when created payment method does not support 3DS. what will we see in response checks?
2. Can't test case when created payment requires 3DS challenge
3. `POST /payments` response will have state `authentication_started` and ew can't show 3DS popup after customer create payment on user panel. all payments with 3DS will be asynchronous through email
   https://developer.revolut.com/docs/accept-payments/tutorials/save-and-charge-payment-methods/checkout-with-saved-card/#step-5-handle-3ds-challenge-and-track-payment-state
4. Can't force payment to be rejected if 3DS required by customer's bank (we have such flow for auto-charge stripe cards)

## Installation

https://dev.to/davidteren/ruby-on-rails-7-high-performance-frontend-development-with-esbuild-rollup-vite-2onj

https://github.com/davidteren/simple_tails
