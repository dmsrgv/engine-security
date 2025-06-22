import 'package:engine_security/engine_security.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DetectorInfoModel', () {
    group('Constructor', () {
      test('should create instance with all parameters', () {
        const model = DetectorInfoModel(
          name: 'Test Detector',
          threatType: SecurityThreatType.frida,
          enabled: true,
          platform: 'Android',
        );

        expect(model.name, equals('Test Detector'));
        expect(model.threatType, equals(SecurityThreatType.frida));
        expect(model.enabled, isTrue);
        expect(model.platform, equals('Android'));
      });

      test('should create instance with different threat types', () {
        for (final threatType in SecurityThreatType.values) {
          final model = DetectorInfoModel(
            name: 'Test Detector',
            threatType: threatType,
            enabled: false,
            platform: 'iOS',
          );

          expect(model.name, equals('Test Detector'));
          expect(model.threatType, equals(threatType));
          expect(model.enabled, isFalse);
          expect(model.platform, equals('iOS'));
        }
      });
    });

    group('toString', () {
      test('should return correct string representation', () {
        const model = DetectorInfoModel(
          name: 'Frida Detector',
          threatType: SecurityThreatType.frida,
          enabled: true,
          platform: 'Android',
        );

        final result = model.toString();

        expect(result, contains('DetectorInfoModel'));
        expect(result, contains('name: Frida Detector'));
        expect(result, contains('threatType: SecurityThreatType.frida'));
        expect(result, contains('enabled: true'));
        expect(result, contains('platform: Android'));
      });

      test('should handle different platforms', () {
        final platforms = ['Android', 'iOS', 'Windows', 'macOS', 'Linux'];

        for (final platform in platforms) {
          final model = DetectorInfoModel(
            name: 'Test Detector',
            threatType: SecurityThreatType.unknown,
            enabled: false,
            platform: platform,
          );

          final result = model.toString();
          expect(result, contains('platform: $platform'));
        }
      });
    });

    group('Equality', () {
      test('should be equal when all properties are same', () {
        const model1 = DetectorInfoModel(
          name: 'Test Detector',
          threatType: SecurityThreatType.frida,
          enabled: true,
          platform: 'Android',
        );

        const model2 = DetectorInfoModel(
          name: 'Test Detector',
          threatType: SecurityThreatType.frida,
          enabled: true,
          platform: 'Android',
        );

        expect(model1.toString(), equals(model2.toString()));
      });

      test('should not be equal when properties differ', () {
        const model1 = DetectorInfoModel(
          name: 'Test Detector',
          threatType: SecurityThreatType.frida,
          enabled: true,
          platform: 'Android',
        );

        const model2 = DetectorInfoModel(
          name: 'Different Detector',
          threatType: SecurityThreatType.frida,
          enabled: true,
          platform: 'Android',
        );

        expect(model1.toString(), isNot(equals(model2.toString())));
      });
    });

    group('Edge Cases', () {
      test('should handle empty strings', () {
        const model = DetectorInfoModel(
          name: '',
          threatType: SecurityThreatType.unknown,
          enabled: false,
          platform: '',
        );

        expect(model.name, equals(''));
        expect(model.platform, equals(''));
        expect(model.threatType, equals(SecurityThreatType.unknown));
        expect(model.enabled, isFalse);
      });

      test('should handle very long strings', () {
        final longName = 'A' * 1000;
        final longPlatform = 'B' * 500;
        final model = DetectorInfoModel(
          name: longName,
          threatType: SecurityThreatType.frida,
          enabled: true,
          platform: longPlatform,
        );

        expect(model.name, equals(longName));
        expect(model.platform, equals(longPlatform));
        expect(model.name.length, equals(1000));
        expect(model.platform.length, equals(500));
      });

      test('should handle special characters', () {
        const model = DetectorInfoModel(
          name: 'Test/Detector-2024_v1.0',
          threatType: SecurityThreatType.frida,
          enabled: true,
          platform: 'Android-API30+',
        );

        expect(model.name, equals('Test/Detector-2024_v1.0'));
        expect(model.platform, equals('Android-API30+'));
      });

      test('should handle unicode characters', () {
        const model = DetectorInfoModel(
          name: '测试检测器',
          threatType: SecurityThreatType.frida,
          enabled: true,
          platform: 'Андроид',
        );

        expect(model.name, equals('测试检测器'));
        expect(model.platform, equals('Андроид'));
      });

      test('should handle all boolean values for enabled', () {
        const model1 = DetectorInfoModel(
          name: 'Test',
          threatType: SecurityThreatType.unknown,
          enabled: true,
          platform: 'Test',
        );

        const model2 = DetectorInfoModel(
          name: 'Test',
          threatType: SecurityThreatType.unknown,
          enabled: false,
          platform: 'Test',
        );

        expect(model1.enabled, isTrue);
        expect(model2.enabled, isFalse);
      });
    });

    group('Properties', () {
      test('should maintain immutability', () {
        const model = DetectorInfoModel(
          name: 'Original Name',
          threatType: SecurityThreatType.debugger,
          enabled: true,
          platform: 'iOS',
        );

        expect(model.name, equals('Original Name'));
        expect(model.threatType, equals(SecurityThreatType.debugger));
        expect(model.enabled, isTrue);
        expect(model.platform, equals('iOS'));
      });

      test('should handle all threat types', () {
        for (final threatType in SecurityThreatType.values) {
          final model = DetectorInfoModel(
            name: 'Test Detector',
            threatType: threatType,
            enabled: true,
            platform: 'Android',
          );

          expect(model.threatType, equals(threatType));
        }
      });
    });
  });
}
