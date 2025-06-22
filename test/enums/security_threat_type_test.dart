import 'package:engine_security/engine_security.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SecurityThreatType', () {
    group('Enum Values', () {
      test('should have all expected enum values', () {
        final expectedValues = [
          SecurityThreatType.unknown,
          SecurityThreatType.frida,
          SecurityThreatType.emulator,
          SecurityThreatType.rootJailbreak,
          SecurityThreatType.debugger,
        ];

        expect(SecurityThreatType.values, containsAll(expectedValues));
        expect(SecurityThreatType.values.length, equals(expectedValues.length));
      });

      test('should have correct enum values accessible', () {
        expect(SecurityThreatType.unknown, isNotNull);
        expect(SecurityThreatType.frida, isNotNull);
        expect(SecurityThreatType.emulator, isNotNull);
        expect(SecurityThreatType.rootJailbreak, isNotNull);
        expect(SecurityThreatType.debugger, isNotNull);
      });
    });

    group('Properties', () {
      test('should have correct displayName for all values', () {
        expect(SecurityThreatType.unknown.displayName, equals('Unknown Threat'));
        expect(SecurityThreatType.frida.displayName, equals('Frida Detection'));
        expect(SecurityThreatType.emulator.displayName, equals('Emulator Detection'));
        expect(SecurityThreatType.rootJailbreak.displayName, equals('Root/Jailbreak Detection'));
        expect(SecurityThreatType.debugger.displayName, equals('Debugger Detection'));
      });

      test('should have correct description for all values', () {
        expect(SecurityThreatType.unknown.description, equals('Unknown security threat detected'));
        expect(SecurityThreatType.frida.description, equals('Frida framework detected'));
        expect(SecurityThreatType.emulator.description, equals('Application running on emulator or simulator'));
        expect(
          SecurityThreatType.rootJailbreak.description,
          equals('Device has been rooted (Android) or jailbroken (iOS)'),
        );
        expect(SecurityThreatType.debugger.description, equals('Debugger attachment detected'));
      });

      test('should have correct severityLevel for all values', () {
        expect(SecurityThreatType.unknown.severityLevel, equals(5));
        expect(SecurityThreatType.frida.severityLevel, equals(9));
        expect(SecurityThreatType.emulator.severityLevel, equals(6));
        expect(SecurityThreatType.rootJailbreak.severityLevel, equals(8));
        expect(SecurityThreatType.debugger.severityLevel, equals(2));
      });
    });

    group('Equality and Comparison', () {
      test('should be equal to itself', () {
        expect(SecurityThreatType.frida, equals(SecurityThreatType.frida));
        expect(SecurityThreatType.emulator, equals(SecurityThreatType.emulator));
        expect(SecurityThreatType.debugger, equals(SecurityThreatType.debugger));
        expect(SecurityThreatType.unknown, equals(SecurityThreatType.unknown));
        expect(SecurityThreatType.rootJailbreak, equals(SecurityThreatType.rootJailbreak));
      });

      test('should not be equal to different enum values', () {
        expect(SecurityThreatType.frida, isNot(equals(SecurityThreatType.emulator)));
        expect(SecurityThreatType.debugger, isNot(equals(SecurityThreatType.unknown)));
        expect(SecurityThreatType.emulator, isNot(equals(SecurityThreatType.debugger)));
        expect(SecurityThreatType.rootJailbreak, isNot(equals(SecurityThreatType.frida)));
      });

      test('should have consistent hashCode for same values', () {
        expect(SecurityThreatType.frida.hashCode, equals(SecurityThreatType.frida.hashCode));
        expect(SecurityThreatType.emulator.hashCode, equals(SecurityThreatType.emulator.hashCode));
      });
    });

    group('String Representation', () {
      test('should have correct toString output', () {
        expect(SecurityThreatType.frida.toString(), contains('SecurityThreatType.frida'));
        expect(SecurityThreatType.emulator.toString(), contains('SecurityThreatType.emulator'));
        expect(SecurityThreatType.debugger.toString(), contains('SecurityThreatType.debugger'));
        expect(SecurityThreatType.unknown.toString(), contains('SecurityThreatType.unknown'));
        expect(SecurityThreatType.rootJailbreak.toString(), contains('SecurityThreatType.rootJailbreak'));
      });
    });

    group('Iteration and Collection Operations', () {
      test('should be iterable', () {
        var count = 0;
        for (final threatType in SecurityThreatType.values) {
          expect(threatType, isA<SecurityThreatType>());
          count++;
        }
        expect(count, equals(SecurityThreatType.values.length));
      });

      test('should work with list operations', () {
        final list = SecurityThreatType.values.toList();
        expect(list, contains(SecurityThreatType.frida));
        expect(list, contains(SecurityThreatType.emulator));
        expect(list, contains(SecurityThreatType.debugger));
        expect(list, contains(SecurityThreatType.unknown));
        expect(list, contains(SecurityThreatType.rootJailbreak));
      });

      test('should work with set operations', () {
        final set = SecurityThreatType.values.toSet();
        expect(set, contains(SecurityThreatType.frida));
        expect(set.length, equals(SecurityThreatType.values.length));
      });

      test('should work with where filter by severity', () {
        final highSeverityThreats = SecurityThreatType.values.where((final type) => type.severityLevel >= 7).toList();

        expect(highSeverityThreats, contains(SecurityThreatType.frida));
        expect(highSeverityThreats, contains(SecurityThreatType.rootJailbreak));
        expect(highSeverityThreats, isNot(contains(SecurityThreatType.debugger)));
      });

      test('should work with map operation', () {
        final displayNames = SecurityThreatType.values.map((final type) => type.displayName).toList();

        expect(displayNames, contains('Frida Detection'));
        expect(displayNames, contains('Emulator Detection'));
        expect(displayNames, contains('Debugger Detection'));
        expect(displayNames, contains('Unknown Threat'));
        expect(displayNames, contains('Root/Jailbreak Detection'));
      });
    });

    group('Edge Cases and Validation', () {
      test('should handle switch statements', () {
        String getTypeDescription(final SecurityThreatType type) {
          switch (type) {
            case SecurityThreatType.frida:
              return 'Frida framework detected';
            case SecurityThreatType.emulator:
              return 'Running on emulator';
            case SecurityThreatType.debugger:
              return 'Debugger attached';
            case SecurityThreatType.rootJailbreak:
              return 'Device is rooted/jailbroken';
            case SecurityThreatType.unknown:
              return 'Unknown threat';
          }
        }

        expect(getTypeDescription(SecurityThreatType.frida), equals('Frida framework detected'));
        expect(getTypeDescription(SecurityThreatType.emulator), equals('Running on emulator'));
        expect(getTypeDescription(SecurityThreatType.debugger), equals('Debugger attached'));
        expect(getTypeDescription(SecurityThreatType.rootJailbreak), equals('Device is rooted/jailbroken'));
        expect(getTypeDescription(SecurityThreatType.unknown), equals('Unknown threat'));
      });

      test('should maintain enum order consistency', () {
        const valuesList = SecurityThreatType.values;
        expect(valuesList.indexOf(SecurityThreatType.unknown), equals(0));
        expect(valuesList.indexOf(SecurityThreatType.frida), equals(1));
        expect(valuesList.indexOf(SecurityThreatType.emulator), equals(2));
        expect(valuesList.indexOf(SecurityThreatType.rootJailbreak), equals(3));
        expect(valuesList.indexOf(SecurityThreatType.debugger), equals(4));
      });

      test('should work with json serialization scenarios', () {
        final enumNames = SecurityThreatType.values.map((final e) => e.name).toList();

        expect(enumNames, contains('unknown'));
        expect(enumNames, contains('frida'));
        expect(enumNames, contains('emulator'));
        expect(enumNames, contains('rootJailbreak'));
        expect(enumNames, contains('debugger'));
      });
    });

    group('Severity and Risk Assessment', () {
      test('should have severity levels in expected range', () {
        for (final threatType in SecurityThreatType.values) {
          expect(threatType.severityLevel, greaterThanOrEqualTo(0));
          expect(threatType.severityLevel, lessThanOrEqualTo(10));
        }
      });

      test('should categorize threats by severity level', () {
        final criticalThreats = SecurityThreatType.values.where((final type) => type.severityLevel >= 8).toList();

        expect(criticalThreats, contains(SecurityThreatType.frida));
        expect(criticalThreats, contains(SecurityThreatType.rootJailbreak));
        expect(criticalThreats.length, equals(2));
      });

      test('should order threats by severity correctly', () {
        final orderedBySeverity = SecurityThreatType.values.toList()
          ..sort((final a, final b) => b.severityLevel.compareTo(a.severityLevel));

        expect(orderedBySeverity.first, equals(SecurityThreatType.frida));
        expect(orderedBySeverity.last, equals(SecurityThreatType.debugger));
      });

      test('should handle severity-based filtering', () {
        final lowSeverityThreats = SecurityThreatType.values.where((final type) => type.severityLevel <= 3).toList();

        expect(lowSeverityThreats, contains(SecurityThreatType.debugger));
        expect(lowSeverityThreats.length, equals(1));
      });
    });

    group('Business Logic', () {
      test('should identify most critical threats', () {
        final mostCritical = SecurityThreatType.values.reduce(
          (final a, final b) => a.severityLevel > b.severityLevel ? a : b,
        );

        expect(mostCritical, equals(SecurityThreatType.frida));
        expect(mostCritical.severityLevel, equals(9));
      });

      test('should identify least critical threats', () {
        final leastCritical = SecurityThreatType.values.reduce(
          (final a, final b) => a.severityLevel < b.severityLevel ? a : b,
        );

        expect(leastCritical, equals(SecurityThreatType.debugger));
        expect(leastCritical.severityLevel, equals(2));
      });

      test('should calculate average severity', () {
        final totalSeverity = SecurityThreatType.values
            .map((final type) => type.severityLevel)
            .reduce((final a, final b) => a + b);

        final averageSeverity = totalSeverity / SecurityThreatType.values.length;
        expect(averageSeverity, equals(6.0));
      });
    });
  });
}
