import 'package:engine_security/engine_security.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineCertificatePinModel', () {
    group('Constructor', () {
      test('should create instance with all required parameters', () {
        const model = EngineCertificatePinModel(
          hostname: 'api.example.com',
          pins: ['YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg='],
        );

        expect(model.hostname, equals('api.example.com'));
        expect(model.pins, hasLength(1));
        expect(model.pins.first, equals('YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg='));
        expect(model.includeSubdomains, isFalse);
        expect(model.enforcePinning, isTrue);
      });

      test('should create instance with optional parameters', () {
        const model = EngineCertificatePinModel(
          hostname: 'api.example.com',
          pins: ['YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg='],
          includeSubdomains: true,
          enforcePinning: false,
        );

        expect(model.includeSubdomains, isTrue);
        expect(model.enforcePinning, isFalse);
      });
    });

    group('Pin Validation', () {
      test('should validate correct SHA-256 base64 pins', () {
        const model = EngineCertificatePinModel(
          hostname: 'test.com',
          pins: ['YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg='],
        );

        expect(model.isValidPinFormat('YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg='), isTrue);
        expect(model.hasValidPins, isTrue);
      });

      test('should reject invalid pin formats', () {
        const model = EngineCertificatePinModel(
          hostname: 'test.com',
          pins: ['invalid-pin'],
        );

        expect(model.isValidPinFormat('invalid-pin'), isFalse);
        expect(model.isValidPinFormat(''), isFalse);
        expect(model.isValidPinFormat('short'), isFalse);
        expect(model.hasValidPins, isFalse);
      });

      test('should handle multiple pins', () {
        const model = EngineCertificatePinModel(
          hostname: 'test.com',
          pins: [
            'YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg=',
            'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
          ],
        );

        expect(model.hasValidPins, isTrue);
        expect(model.pins, hasLength(2));
      });

      test('should reject empty pins list', () {
        const model = EngineCertificatePinModel(
          hostname: 'test.com',
          pins: [],
        );

        expect(model.hasValidPins, isFalse);
      });
    });

    group('Hostname Matching', () {
      test('should match exact hostname', () {
        const model = EngineCertificatePinModel(
          hostname: 'api.example.com',
          pins: ['YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg='],
        );

        expect(model.matchesHostname('api.example.com'), isTrue);
        expect(model.matchesHostname('other.example.com'), isFalse);
      });

      test('should match subdomains when enabled', () {
        const model = EngineCertificatePinModel(
          hostname: 'example.com',
          pins: ['YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg='],
          includeSubdomains: true,
        );

        expect(model.matchesHostname('example.com'), isTrue);
        expect(model.matchesHostname('api.example.com'), isTrue);
        expect(model.matchesHostname('sub.api.example.com'), isTrue);
        expect(model.matchesHostname('other.com'), isFalse);
      });

      test('should not match subdomains when disabled', () {
        const model = EngineCertificatePinModel(
          hostname: 'example.com',
          pins: ['YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg='],
          includeSubdomains: false,
        );

        expect(model.matchesHostname('example.com'), isTrue);
        expect(model.matchesHostname('api.example.com'), isFalse);
      });
    });

    group('Equality and HashCode', () {
      test('should be equal when all properties match', () {
        const model1 = EngineCertificatePinModel(
          hostname: 'test.com',
          pins: ['YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg='],
          includeSubdomains: true,
          enforcePinning: false,
        );

        const model2 = EngineCertificatePinModel(
          hostname: 'test.com',
          pins: ['YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg='],
          includeSubdomains: true,
          enforcePinning: false,
        );

        expect(model1, equals(model2));
        expect(model1.hashCode, equals(model2.hashCode));
      });

      test('should not be equal when properties differ', () {
        const model1 = EngineCertificatePinModel(
          hostname: 'test.com',
          pins: ['YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg='],
        );

        const model2 = EngineCertificatePinModel(
          hostname: 'different.com',
          pins: ['YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg='],
        );

        expect(model1, isNot(equals(model2)));
      });
    });

    group('toString', () {
      test('should return correct string representation', () {
        const model = EngineCertificatePinModel(
          hostname: 'test.com',
          pins: ['YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg='],
          includeSubdomains: true,
          enforcePinning: false,
        );

        final result = model.toString();

        expect(result, contains('EngineCertificatePinModel'));
        expect(result, contains('hostname: test.com'));
        expect(result, contains('pins: 1 pins'));
        expect(result, contains('includeSubdomains: true'));
        expect(result, contains('enforcePinning: false'));
      });
    });

    group('Edge Cases', () {
      test('should handle empty hostname', () {
        const model = EngineCertificatePinModel(
          hostname: '',
          pins: ['YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg='],
        );

        expect(model.hostname, equals(''));
        expect(model.matchesHostname(''), isTrue);
        expect(model.matchesHostname('test.com'), isFalse);
      });

      test('should handle very long hostname', () {
        final longHostname = 'a' * 100 + '.example.com';
        final model = EngineCertificatePinModel(
          hostname: longHostname,
          pins: ['YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg='],
        );

        expect(model.hostname, equals(longHostname));
        expect(model.matchesHostname(longHostname), isTrue);
      });

      test('should handle many pins', () {
        final manyPins = List.generate(
          10,
          (final i) => 'YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuih$i=',
        );

        final model = EngineCertificatePinModel(
          hostname: 'test.com',
          pins: manyPins,
        );

        expect(model.pins, hasLength(10));
      });
    });
  });
}
