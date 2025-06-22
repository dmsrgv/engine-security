import 'package:engine_security/engine_security.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EngineGpsFakeDetector', () {
    late EngineGpsFakeDetector detector;

    setUp(() {
      detector = EngineGpsFakeDetector();
    });

    test('should have correct threat type', () {
      expect(detector.threatType, EngineSecurityThreatType.gpsFake);
    });

    test('should have correct detector name', () {
      expect(detector.detectorName, 'GpsFakeDetector');
    });

    test('should provide detector info', () {
      final info = detector.detectorInfo;
      expect(info.name, 'GpsFakeDetector');
      expect(info.threatType, EngineSecurityThreatType.gpsFake);
      expect(info.enabled, detector.isAvailable);
    });

    test('should be enabled by default', () {
      expect(detector.isAvailable, isTrue);
    });

    test('should respect enabled parameter', () {
      final disabledDetector = EngineGpsFakeDetector(enabled: false);
      expect(disabledDetector.isAvailable, isFalse);
    });

    test('should return disabled result when disabled', () async {
      final disabledDetector = EngineGpsFakeDetector(enabled: false);
      final result = await disabledDetector.performCheck();

      expect(result.isSecure, isTrue);
      expect(result.details, contains('disabled'));
      expect(result.detectionMethod, equals('disabled_check'));
      expect(result.confidence, equals(1.0));
    });

    test('should perform check without errors', () async {
      final result = await detector.performCheck();
      expect(result, isA<EngineSecurityCheckModel>());
      expect(result.confidence, greaterThanOrEqualTo(0.0));
      expect(result.confidence, lessThanOrEqualTo(1.0));

      if (result.isSecure) {
        expect(result.threatType, EngineSecurityThreatType.unknown);
      } else {
        expect(result.threatType, EngineSecurityThreatType.gpsFake);
      }
    });

    test('should handle static methods', () async {
      final mockEnabled = await EngineGpsFakeDetector.checkMockLocationEnabled();
      final fakeApps = await EngineGpsFakeDetector.getInstalledFakeGpsApps();

      expect(mockEnabled, isA<bool>());
      expect(fakeApps, isA<List<String>>());
    });
  });

  group('SecurityThreatType.gpsFake', () {
    test('should have correct properties', () {
      const threatType = EngineSecurityThreatType.gpsFake;
      expect(threatType.displayName, 'GPS Fake Detection');
      expect(threatType.description, 'GPS location spoofing or fake GPS app detected');
      expect(threatType.severityLevel, 7);
    });
  });
}
