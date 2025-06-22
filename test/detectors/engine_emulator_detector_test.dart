import 'dart:io';

import 'package:engine_security/src/src.dart';
import 'package:test/test.dart';

void main() {
  group('EngineEmulatorDetector', () {
    late EngineEmulatorDetector detector;
    late EngineEmulatorDetector disabledDetector;

    setUp(() {
      detector = EngineEmulatorDetector();
      disabledDetector = EngineEmulatorDetector(enabled: false);
    });

    group('Constructor and Properties', () {
      test('should create detector with default enabled state', () {
        final detector = EngineEmulatorDetector();
        expect(detector.enabled, isTrue);
      });

      test('should create detector with specified enabled state', () {
        final enabledDetector = EngineEmulatorDetector(enabled: true);
        final disabledDetector = EngineEmulatorDetector(enabled: false);

        expect(enabledDetector.enabled, isTrue);
        expect(disabledDetector.enabled, isFalse);
      });

      test('should have correct threat type', () {
        expect(detector.threatType, equals(SecurityThreatType.emulator));
      });

      test('should have correct detector name', () {
        expect(detector.detectorName, equals('EmulatorDetector'));
      });

      test('should have correct availability based on enabled state', () {
        expect(detector.isAvailable, isTrue);
        expect(disabledDetector.isAvailable, isFalse);
      });
    });

    group('Detector Info', () {
      test('should return correct detector info when enabled', () {
        final info = detector.detectorInfo;

        expect(info.name, equals('EmulatorDetector'));
        expect(info.threatType, equals(SecurityThreatType.emulator));
        expect(info.enabled, isTrue);
        expect(info.platform, equals(Platform.operatingSystem));
      });

      test('should return correct detector info when disabled', () {
        final info = disabledDetector.detectorInfo;

        expect(info.name, equals('EmulatorDetector'));
        expect(info.threatType, equals(SecurityThreatType.emulator));
        expect(info.enabled, isFalse);
        expect(info.platform, equals(Platform.operatingSystem));
      });
    });

    group('performCheck', () {
      test('should return secure result when detector is disabled', () async {
        final result = await disabledDetector.performCheck();

        expect(result.isSecure, isTrue);
        expect(result.details, equals('Emulator detector disabled'));
        expect(result.detectionMethod, equals('disabled_check'));
        expect(result.confidence, equals(1.0));
      });

      test('should perform security check when enabled', () async {
        final result = await detector.performCheck();

        expect(result, isA<SecurityCheckModel>());
        expect(result.confidence, greaterThan(0.0));
        expect(result.detectionMethod, isNotEmpty);
        expect(result.details, isNotEmpty);
      });

      test('should handle secure state with proper confidence', () async {
        final result = await detector.performCheck();

        if (result.isSecure) {
          expect(result.details, contains('No emulator/simulator detected'));
          expect(result.detectionMethod, equals('platform_checks'));
          expect(result.confidence, equals(0.80));
        }
      });

      test('should detect threat with proper details', () async {
        final result = await detector.performCheck();

        if (!result.isSecure) {
          expect(result.threatType, equals(SecurityThreatType.emulator));
          expect(result.details, contains('Emulator/Simulator detected'));
          expect(result.detectionMethod, equals('platform_specific_checks'));
          expect(result.confidence, equals(0.85));
        }
      });
    });

    group('Platform-specific Detection', () {
      test('should handle Android emulator detection', () async {
        if (Platform.isAndroid) {
          final result = await detector.performCheck();
          expect(result, isA<SecurityCheckModel>());
        }
      });

      test('should handle iOS simulator detection', () async {
        if (Platform.isIOS) {
          final result = await detector.performCheck();
          expect(result, isA<SecurityCheckModel>());
        }
      });
    });

    group('Integration Tests', () {
      test('should complete full check cycle without errors', () async {
        expect(() async => await detector.performCheck(), returnsNormally);
      });

      test('should maintain consistent behavior across multiple calls', () async {
        final result1 = await detector.performCheck();
        final result2 = await detector.performCheck();

        expect(result1.detectionMethod, equals(result2.detectionMethod));
        expect(result1.isSecure, equals(result2.isSecure));
      });

      test('should have deterministic results for disabled detector', () async {
        final result1 = await disabledDetector.performCheck();
        final result2 = await disabledDetector.performCheck();

        expect(result1.isSecure, equals(result2.isSecure));
        expect(result1.details, equals(result2.details));
        expect(result1.confidence, equals(result2.confidence));
      });
    });

    group('Interface Compliance', () {
      test('should implement ISecurityDetector interface', () {
        expect(detector, isA<ISecurityDetector>());
      });

      test('should have all required interface methods', () {
        expect(detector.threatType, isA<SecurityThreatType>());
        expect(detector.detectorName, isA<String>());
        expect(detector.isAvailable, isA<bool>());
        expect(detector.detectorInfo, isA<DetectorInfoModel>());
      });

      test('should return Future<SecurityCheckModel> from performCheck', () {
        expect(detector.performCheck(), isA<Future<SecurityCheckModel>>());
      });
    });
  });
}
