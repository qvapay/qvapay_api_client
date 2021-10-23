# qvapay_api_client

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Dart API Client which wraps the [QvaPay API](https://documenter.getpostman.com/view/8765260/TzzHnDGw)

The client needs [Dio][dio_link] to perform the requests, you must inject an instance in the constructor.

```dart
void main () async {
  final api = QvaPayApiClient (Dio(), CustomSecureStorage());

  // Listen to the authentication status
  api.status.listen ((status) => print (status));

  // Start section on the platform
  await api.logIn (email: 'erich@qvapay.com', password: 'sqpToTheMoon');

  // You get the user's data and its last operations
  final me = await api.getUserData ();
  print (me.toString ());

  // You can create a transaction to receive a specific payment,
  // or just a transfer that you want to receive from another user.
  final transactionCreated = await api.createTransaction (
      uuid: 'c67af7d0-a699-4e50-82d5-cfeaa9ed2b7d',
      amount: 20.5,
      description: 'Mobile Recharge');

  // Pay a specific transaction through your `uuid`, it can be the
  // purchase of an item or simply a transfer to another user.
  final payTransaction =
      await api.payTransaction (uuid: '09dfsd9fs-cxc5-sdfd-3dsvf-f7sdtfrds6d', pin: '9900');

  // You get the details of a specific transaction through its `uuid`
  final transaction =
      await api.getTransactionDetails (uuid: payTransaction.uuid);
  print (transaction.toString ());

  // Filter the search for Transactions in terms of the given parameters, otherwise
  // Contrary to not passing any parameter returns the last 30 transactions
  final transactions = await api.getTransactions (
    start: DateTime.parse ('2021-08-16T03: 39: 03.000000Z'),
    end: DateTime.now (),
    description: 'Recharge',
  );
  print (transactions.toString ());

  // Close the session
  await api.logOut ();
  // Close listening
  api.dispose ();
}
```

⚠️ Always remember to close the status stream with the `dispose()` method provided by the client.

🦺 Implementing secure storage with [flutter_secure_storage][flutter_secure_storage_link]

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:qvapay_api_client/qvapay_api_client.dart';

const _keySecureStorage = 'secure_storage';

class CustomSecureStorage extends OAuthStorage {
  final _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> delete() {
    return _secureStorage.deleteAll();
  }

  @override
  Future<String?> fetch() {
    return _secureStorage.read(key: _keySecureStorage);
  }

  @override
  Future<bool> save(String token) async {
    try {
      await _secureStorage.write(key: _keySecureStorage, value: token);
      return true;
    } catch (e) {
      return false;
    }
  }
}
```

## Running Tests 🧪

To run all unit tests use the following command:

```sh
# Run all test
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

[coverage_badge]: coverage_badge.svg
[dio_link]: https://pub.dev/packages/dio
[flutter_secure_storage_link]: https://pub.dev/packages/flutter_secure_storage
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
