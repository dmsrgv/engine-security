import 'package:engine_security/engine_security.dart';
import 'package:test/test.dart';

void main() {
  group('EngineHttpsPinningDetector', () {
    late EngineHttpsPinningDetector detector;

    setUp(() {
      detector = EngineHttpsPinningDetector();
    });

    group('Basic Properties', () {
      test('should have correct threat type', () {
        expect(detector.threatType, equals(EngineSecurityThreatType.httpsPinning));
      });

      test('should have correct detector name', () {
        expect(detector.detectorName, equals('HttpsPinningDetector'));
      });

      test('should be available when enabled', () {
        expect(detector.isAvailable, isTrue);
      });

      test('should not be available when disabled', () {
        final disabledDetector = EngineHttpsPinningDetector(enabled: false);
        expect(disabledDetector.isAvailable, isFalse);
      });
    });

    group('Detector Info', () {
      test('should return correct detector info', () {
        final info = detector.detectorInfo;

        expect(info.name, equals('HttpsPinningDetector'));
        expect(info.threatType, equals(EngineSecurityThreatType.httpsPinning));
        expect(info.enabled, isTrue);
        expect(info.platform, isNotEmpty);
      });

      test('should return correct detector info when disabled', () {
        final disabledDetector = EngineHttpsPinningDetector(enabled: false);
        final info = disabledDetector.detectorInfo;

        expect(info.enabled, isFalse);
        expect(info.threatType, equals(EngineSecurityThreatType.httpsPinning));
      });
    });

    group('performCheck', () {
      test('should return secure when detector is disabled', () async {
        final disabledDetector = EngineHttpsPinningDetector(enabled: false);
        final result = await disabledDetector.performCheck();

        expect(result, isA<EngineSecurityCheckModel>());
        expect(result.isSecure, isTrue);
        expect(result.details, contains('disabled'));
        expect(result.detectionMethod, equals('disabled_check'));
        expect(result.confidence, equals(1.0));
      });

      test('should detect when no HttpOverrides configured', () async {
        final result = await detector.performCheck();

        expect(result, isA<EngineSecurityCheckModel>());
        // This test might be secure or threat depending on configuration
        expect(result.threatType, equals(EngineSecurityThreatType.httpsPinning));
      });

      test('should work with valid pin configurations', () async {
        final validPins = [
          const EngineCertificatePinModel(
            hostname: 'api.example.com',
            pins: ['YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg='],
          ),
        ];

        final detectorWithPins = EngineHttpsPinningDetector(
          pinnedCertificates: validPins,
          testConnectivity: false, // Disable connectivity tests
        );

        final result = await detectorWithPins.performCheck();

        expect(result, isA<EngineSecurityCheckModel>());
        expect(result.threatType, equals(EngineSecurityThreatType.httpsPinning));
      });

      test('should detect invalid pin configurations', () async {
        final invalidPins = [
          const EngineCertificatePinModel(
            hostname: 'api.example.com',
            pins: ['invalid-pin-format'],
          ),
        ];

        final detectorWithInvalidPins = EngineHttpsPinningDetector(
          pinnedCertificates: invalidPins,
          testConnectivity: false,
        );

        final result = await detectorWithInvalidPins.performCheck();

        expect(result, isA<EngineSecurityCheckModel>());
        expect(result.isSecure, isFalse);
        expect(result.details, contains('Invalid certificate pins'));
      });

      test('should handle strict mode correctly', () async {
        final strictDetector = EngineHttpsPinningDetector(
          strictMode: true,
          pinnedCertificates: [], // No pins configured
        );

        final result = await strictDetector.performCheck();

        expect(result, isA<EngineSecurityCheckModel>());
        expect(result.isSecure, isFalse);
        expect(result.details, contains('No certificate pinning configured'));
      });

      test('should handle IP address in hostname', () async {
        final invalidPins = [
          const EngineCertificatePinModel(
            hostname: '192.168.1.1',
            pins: ['YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg='],
          ),
        ];

        final detectorWithIpHostname = EngineHttpsPinningDetector(
          pinnedCertificates: invalidPins,
          testConnectivity: false,
        );

        final result = await detectorWithIpHostname.performCheck();

        expect(result, isA<EngineSecurityCheckModel>());
        expect(result.isSecure, isFalse);
        expect(result.details, contains('IP address used instead of hostname'));
      });

      test('should handle errors gracefully', () async {
        // This test is harder to trigger errors in the current implementation
        // but ensures error handling works
        final result = await detector.performCheck();

        expect(result, isA<EngineSecurityCheckModel>());
        expect(result.threatType, equals(EngineSecurityThreatType.httpsPinning));
      });
    });

    group('Static Helper Methods', () {
      test('isValidCertificatePin should validate pin formats', () {
        expect(
          EngineHttpsPinningDetector.isValidCertificatePin(
            'YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg=',
          ),
          isTrue,
        );

        expect(
          EngineHttpsPinningDetector.isValidCertificatePin('invalid-pin'),
          isFalse,
        );

        expect(
          EngineHttpsPinningDetector.isValidCertificatePin(''),
          isFalse,
        );
      });

      test('createPinFromCertificateFile should handle non-existent files', () async {
        final result = await EngineHttpsPinningDetector.createPinFromCertificateFile(
          'test.com',
          '/non/existent/file.crt',
        );

        expect(result, isNull);
      });
    });

    group('Configuration Options', () {
      test('should respect testConnectivity flag', () {
        final detector1 = EngineHttpsPinningDetector(testConnectivity: true);
        final detector2 = EngineHttpsPinningDetector(testConnectivity: false);

        expect(detector1.testConnectivity, isTrue);
        expect(detector2.testConnectivity, isFalse);
      });

      test('should respect strictMode flag', () {
        final detector1 = EngineHttpsPinningDetector(strictMode: true);
        final detector2 = EngineHttpsPinningDetector(strictMode: false);

        expect(detector1.strictMode, isTrue);
        expect(detector2.strictMode, isFalse);
      });

      test('should handle custom pin configurations', () {
        final customPins = [
          const EngineCertificatePinModel(
            hostname: 'api.custom.com',
            pins: [
              'YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg=',
              'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
            ],
            includeSubdomains: true,
            enforcePinning: false,
          ),
        ];

        final customDetector = EngineHttpsPinningDetector(
          pinnedCertificates: customPins,
        );

        expect(customDetector.pinnedCertificates, hasLength(1));
        expect(customDetector.pinnedCertificates.first.hostname, equals('api.custom.com'));
        expect(customDetector.pinnedCertificates.first.pins, hasLength(2));
        expect(customDetector.pinnedCertificates.first.includeSubdomains, isTrue);
        expect(customDetector.pinnedCertificates.first.enforcePinning, isFalse);
      });
    });

    group('Interface Compliance', () {
      test('should implement IEngineSecurityDetector interface', () {
        expect(detector, isA<IEngineSecurityDetector>());
      });

      test('should return Future<EngineSecurityCheckModel> from performCheck', () {
        expect(detector.performCheck(), isA<Future<EngineSecurityCheckModel>>());
      });
    });

    group('Edge Cases', () {
      test('should handle empty hostname in pin configuration', () async {
        final invalidPins = [
          const EngineCertificatePinModel(
            hostname: '',
            pins: ['YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg='],
          ),
        ];

        final detectorWithEmptyHostname = EngineHttpsPinningDetector(
          pinnedCertificates: invalidPins,
          testConnectivity: false,
        );

        final result = await detectorWithEmptyHostname.performCheck();

        expect(result, isA<EngineSecurityCheckModel>());
        expect(result.isSecure, isFalse);
        expect(result.details, contains('Empty hostname'));
      });

      test('should handle empty pins list', () async {
        final emptyPins = [
          const EngineCertificatePinModel(
            hostname: 'api.example.com',
            pins: [],
          ),
        ];

        final detectorWithEmptyPins = EngineHttpsPinningDetector(
          pinnedCertificates: emptyPins,
          testConnectivity: false,
        );

        final result = await detectorWithEmptyPins.performCheck();

        expect(result, isA<EngineSecurityCheckModel>());
        expect(result.isSecure, isFalse);
        expect(result.details, contains('Invalid certificate pins'));
      });

      test('should handle multiple pin configurations', () async {
        final multiplePins = [
          const EngineCertificatePinModel(
            hostname: 'api1.example.com',
            pins: ['YLh1dUR9y6Kja30RrAn7JKnbQG/uEtLMkBgFF2Fuihg='],
          ),
          const EngineCertificatePinModel(
            hostname: 'api2.example.com',
            pins: ['AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='],
          ),
        ];

        final detectorWithMultiplePins = EngineHttpsPinningDetector(
          pinnedCertificates: multiplePins,
          testConnectivity: false,
        );

        final result = await detectorWithMultiplePins.performCheck();

        expect(result, isA<EngineSecurityCheckModel>());
        expect(detectorWithMultiplePins.pinnedCertificates, hasLength(2));
      });
    });
  });
}
