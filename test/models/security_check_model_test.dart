import 'package:engine_security/engine_security.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SecurityCheckModel', () {
    group('Constructor', () {
      test('should create instance with all required parameters', () {
        final model = SecurityCheckModel(
          isSecure: true,
          threatType: SecurityThreatType.frida,
          confidence: 0.95,
          details: 'Test details',
          detectionMethod: 'Test method',
          timestamp: DateTime.now(),
        );

        expect(model.isSecure, isTrue);
        expect(model.threatType, equals(SecurityThreatType.frida));
        expect(model.confidence, equals(0.95));
        expect(model.details, equals('Test details'));
        expect(model.detectionMethod, equals('Test method'));
        expect(model.timestamp, isNotNull);
      });

      test('should create instance with default confidence', () {
        const model = SecurityCheckModel(
          isSecure: false,
          threatType: SecurityThreatType.unknown,
        );

        expect(model.isSecure, isFalse);
        expect(model.threatType, equals(SecurityThreatType.unknown));
        expect(model.confidence, equals(1.0));
        expect(model.details, isNull);
        expect(model.detectionMethod, isNull);
        expect(model.timestamp, isNull);
      });
    });

    group('Factory Methods', () {
      test('secure() should create secure instance with default values', () {
        final model = SecurityCheckModel.secure();

        expect(model.isSecure, isTrue);
        expect(model.threatType, equals(SecurityThreatType.unknown));
        expect(model.confidence, equals(1.0));
        expect(model.details, isNull);
        expect(model.detectionMethod, isNull);
        expect(model.timestamp, isNotNull);
      });

      test('secure() should create secure instance with custom parameters', () {
        final model = SecurityCheckModel.secure(
          confidence: 0.98,
          details: 'Custom secure details',
          detectionMethod: 'Custom method',
        );

        expect(model.isSecure, isTrue);
        expect(model.threatType, equals(SecurityThreatType.unknown));
        expect(model.confidence, equals(0.98));
        expect(model.details, equals('Custom secure details'));
        expect(model.detectionMethod, equals('Custom method'));
        expect(model.timestamp, isNotNull);
      });

      test('threat() should create threat instance with default values', () {
        final model = SecurityCheckModel.threat(
          threatType: SecurityThreatType.frida,
        );

        expect(model.isSecure, isFalse);
        expect(model.threatType, equals(SecurityThreatType.frida));
        expect(model.confidence, equals(1.0));
        expect(model.details, isNull);
        expect(model.detectionMethod, isNull);
        expect(model.timestamp, isNotNull);
      });

      test('threat() should create threat instance with custom parameters', () {
        final model = SecurityCheckModel.threat(
          threatType: SecurityThreatType.emulator,
          confidence: 0.85,
          details: 'Custom threat details',
          detectionMethod: 'Custom threat method',
        );

        expect(model.isSecure, isFalse);
        expect(model.threatType, equals(SecurityThreatType.emulator));
        expect(model.confidence, equals(0.85));
        expect(model.details, equals('Custom threat details'));
        expect(model.detectionMethod, equals('Custom threat method'));
        expect(model.timestamp, isNotNull);
      });
    });

    group('toString', () {
      test('should return correct string representation', () {
        final model = SecurityCheckModel(
          isSecure: true,
          threatType: SecurityThreatType.frida,
          confidence: 0.95,
          details: 'Test details',
          detectionMethod: 'Test method',
          timestamp: DateTime(2024, 1, 1, 12, 0),
        );

        final result = model.toString();

        expect(result, contains('SecurityCheckModel'));
        expect(result, contains('isSecure: true'));
        expect(result, contains('threatType: SecurityThreatType.frida'));
        expect(result, contains('confidence: 0.95'));
        expect(result, contains('details: Test details'));
        expect(result, contains('detectionMethod: Test method'));
        expect(result, contains('2024-01-01 12:00:00.000'));
      });

      test('should handle null values in toString', () {
        const model = SecurityCheckModel(
          isSecure: false,
          threatType: SecurityThreatType.unknown,
          confidence: 0.5,
        );

        final result = model.toString();

        expect(result, contains('SecurityCheckModel'));
        expect(result, contains('isSecure: false'));
        expect(result, contains('threatType: SecurityThreatType.unknown'));
        expect(result, contains('confidence: 0.5'));
        expect(result, contains('details: null'));
        expect(result, contains('detectionMethod: null'));
        expect(result, contains('timestamp: null'));
      });
    });

    group('Equality', () {
      test('should be equal when all properties are same', () {
        final timestamp = DateTime(2024, 1, 1);
        final model1 = SecurityCheckModel(
          isSecure: true,
          threatType: SecurityThreatType.frida,
          confidence: 0.95,
          details: 'Test details',
          detectionMethod: 'Test method',
          timestamp: timestamp,
        );

        final model2 = SecurityCheckModel(
          isSecure: true,
          threatType: SecurityThreatType.frida,
          confidence: 0.95,
          details: 'Test details',
          detectionMethod: 'Test method',
          timestamp: timestamp,
        );

        expect(model1.toString(), equals(model2.toString()));
      });

      test('should not be equal when properties differ', () {
        final timestamp = DateTime(2024, 1, 1);
        final model1 = SecurityCheckModel(
          isSecure: true,
          threatType: SecurityThreatType.frida,
          confidence: 0.95,
          details: 'Test details',
          detectionMethod: 'Test method',
          timestamp: timestamp,
        );

        final model2 = SecurityCheckModel(
          isSecure: false,
          threatType: SecurityThreatType.frida,
          confidence: 0.95,
          details: 'Test details',
          detectionMethod: 'Test method',
          timestamp: timestamp,
        );

        expect(model1.toString(), isNot(equals(model2.toString())));
      });
    });

    group('Edge Cases', () {
      test('should handle confidence boundary values', () {
        const model1 = SecurityCheckModel(
          isSecure: true,
          threatType: SecurityThreatType.unknown,
          confidence: 0.0,
        );
        const model2 = SecurityCheckModel(
          isSecure: true,
          threatType: SecurityThreatType.unknown,
          confidence: 1.0,
        );

        expect(model1.confidence, equals(0.0));
        expect(model2.confidence, equals(1.0));
      });

      test('should handle empty string details', () {
        const model = SecurityCheckModel(
          isSecure: true,
          threatType: SecurityThreatType.unknown,
          confidence: 0.5,
          details: '',
        );

        expect(model.details, equals(''));
      });

      test('should handle very long details string', () {
        final longDetails = 'A' * 1000;
        final model = SecurityCheckModel(
          isSecure: true,
          threatType: SecurityThreatType.unknown,
          confidence: 0.5,
          details: longDetails,
        );

        expect(model.details, equals(longDetails));
        expect(model.details!.length, equals(1000));
      });

      test('should handle all threat types', () {
        for (final threatType in SecurityThreatType.values) {
          final model = SecurityCheckModel(
            isSecure: false,
            threatType: threatType,
          );
          expect(model.threatType, equals(threatType));
        }
      });
    });
  });
}
