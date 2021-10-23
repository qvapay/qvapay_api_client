import 'package:qvapay_api_client/src/utils.dart';
import 'package:test/test.dart';

void main() {
  group('toStringWithMicrosecond', () {
    test('when date contains micoseconds', () async {
      const tStringWithMicrosecond = '2021-08-28T21:13:38.060153Z';
      final tDataWithMicrosecond = DateTime.parse(tStringWithMicrosecond);
      expect(
        tStringWithMicrosecond,
        toStringWithMicrosecond(tDataWithMicrosecond),
      );
    });

    test('when the date does not contain micoseconds', () async {
      const tStringWithOutMicrosecond = '2021-08-28T21:13:38.000000Z';
      final tDataWithOutMicrosecond = DateTime.parse(tStringWithOutMicrosecond);
      expect(
        toStringWithMicrosecond(tDataWithOutMicrosecond),
        tStringWithOutMicrosecond,
      );
    });
  });

  group('OAuthMemoryStorage', () {
    final storage = OAuthMemoryStorage();
    const tToken = 'token';

    test('save', () async {
      expect(await storage.save(tToken), isTrue);
    });
    test('fetch', () async {
      await storage.save(tToken);
      expect(await storage.fetch(), tToken);
    });

    test('delete', () async {
      expect(storage.delete(), completes);
      expect(await storage.fetch(), isNull);
    });
  });
}
