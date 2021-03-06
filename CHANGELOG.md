# Changelog

## 0.0.1

- Initial version.

## 0.0.2

- Small opinionated improvements. Thanks [@lynier](https://github.com/leynier) for PR [#1](https://github.com/qvapay/qvapay_api_client/pull/1).
- fix: added authorization in the header of the `logout` method.
- refactor: added the `email` property to the `Me` model.

## 0.0.3

- refactor: renamed `LatestTransaction` to `Transaction`.
- refactor: add parameter `baseUrl` to constructor of `QvaPayApiClient`.
- refactor: add parameter `invite` to `register` method.
- feat: added `getTransactions` method.
- feat: added `getTransactionDetails` method.
- docs: improve documentation.

## 0.0.4

- docs(readme): add example of how to implement the client.
- test: reach 100% test coverage.

## 0.0.5

- fix: casting error in login response
- update: change the analysis_options version to 2.4.0
- refactor(owner): add `email` property
- **BREAKING:** refactor(transaction!): merged class `PaidBy` y `PayTo` into a single class `Paid`
- **BREAKING:** refactor(create_transaction!): return a `Transaction` instead of `TransactionResponse`
- **BREAKING:** refactor(pay_transaction!): return a `Transaction` instead of `PaymentResponse`
