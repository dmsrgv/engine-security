import 'package:engine_security/engine_security.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SecurityThreatType', () {
    group('Enum Values', () {
      test('should have all expected enum values', () {
        final expectedValues = [
          EngineSecurityThreatType.unknown,
          EngineSecurityThreatType.frida,
          EngineSecurityThreatType.emulator,
          EngineSecurityThreatType.rootJailbreak,
          EngineSecurityThreatType.debugger,
          EngineSecurityThreatType.gpsFake,
        ];

        expect(EngineSecurityThreatType.values, containsAll(expectedValues));
        expect(EngineSecurityThreatType.values.length, equals(expectedValues.length));
      });

      test('should have correct enum values accessible', () {
        expect(EngineSecurityThreatType.unknown, isNotNull);
        expect(EngineSecurityThreatType.frida, isNotNull);
        expect(EngineSecurityThreatType.emulator, isNotNull);
        expect(EngineSecurityThreatType.rootJailbreak, isNotNull);
        expect(EngineSecurityThreatType.debugger, isNotNull);
        expect(EngineSecurityThreatType.gpsFake, isNotNull);
      });
    });

    group('Properties', () {
      test('should have correct displayName for all values', () {
        expect(EngineSecurityThreatType.unknown.displayName, equals('Unknown Threat'));
        expect(EngineSecurityThreatType.frida.displayName, equals('Frida Detection'));
        expect(EngineSecurityThreatType.emulator.displayName, equals('Emulator Detection'));
        expect(EngineSecurityThreatType.rootJailbreak.displayName, equals('Root/Jailbreak Detection'));
        expect(EngineSecurityThreatType.debugger.displayName, equals('Debugger Detection'));
        expect(EngineSecurityThreatType.gpsFake.displayName, equals('GPS Fake Detection'));
      });

      test('should have correct description for all values', () {
        expect(EngineSecurityThreatType.unknown.description, equals('Unknown security threat detected'));
        expect(EngineSecurityThreatType.frida.description, equals('Frida framework detected'));
        expect(EngineSecurityThreatType.emulator.description, equals('Application running on emulator or simulator'));
        expect(
          EngineSecurityThreatType.rootJailbreak.description,
          equals('Device has been rooted (Android) or jailbroken (iOS)'),
        );
        expect(EngineSecurityThreatType.debugger.description, equals('Debugger attachment detected'));
        expect(EngineSecurityThreatType.gpsFake.description, equals('GPS location spoofing or fake GPS app detected'));
      });

      test('should have correct severityLevel for all values', () {
        expect(EngineSecurityThreatType.unknown.severityLevel, equals(5));
        expect(EngineSecurityThreatType.frida.severityLevel, equals(9));
        expect(EngineSecurityThreatType.emulator.severityLevel, equals(6));
        expect(EngineSecurityThreatType.rootJailbreak.severityLevel, equals(8));
        expect(EngineSecurityThreatType.debugger.severityLevel, equals(2));
        expect(EngineSecurityThreatType.gpsFake.severityLevel, equals(7));
      });
    });

    group('Equality and Comparison', () {
      test('should be equal to itself', () {
        expect(EngineSecurityThreatType.frida, equals(EngineSecurityThreatType.frida));
        expect(EngineSecurityThreatType.emulator, equals(EngineSecurityThreatType.emulator));
        expect(EngineSecurityThreatType.debugger, equals(EngineSecurityThreatType.debugger));
        expect(EngineSecurityThreatType.unknown, equals(EngineSecurityThreatType.unknown));
        expect(EngineSecurityThreatType.rootJailbreak, equals(EngineSecurityThreatType.rootJailbreak));
        expect(EngineSecurityThreatType.gpsFake, equals(EngineSecurityThreatType.gpsFake));
      });

      test('should not be equal to different enum values', () {
        expect(EngineSecurityThreatType.frida, isNot(equals(EngineSecurityThreatType.emulator)));
        expect(EngineSecurityThreatType.debugger, isNot(equals(EngineSecurityThreatType.unknown)));
        expect(EngineSecurityThreatType.emulator, isNot(equals(EngineSecurityThreatType.debugger)));
        expect(EngineSecurityThreatType.rootJailbreak, isNot(equals(EngineSecurityThreatType.frida)));
      });

      test('should have consistent hashCode for same values', () {
        expect(EngineSecurityThreatType.frida.hashCode, equals(EngineSecurityThreatType.frida.hashCode));
        expect(EngineSecurityThreatType.emulator.hashCode, equals(EngineSecurityThreatType.emulator.hashCode));
      });
    });

    group('String Representation', () {
      test('should have correct toString output', () {
        expect(EngineSecurityThreatType.frida.toString(), contains('SecurityThreatType.frida'));
        expect(EngineSecurityThreatType.emulator.toString(), contains('SecurityThreatType.emulator'));
        expect(EngineSecurityThreatType.debugger.toString(), contains('SecurityThreatType.debugger'));
        expect(EngineSecurityThreatType.unknown.toString(), contains('SecurityThreatType.unknown'));
        expect(EngineSecurityThreatType.rootJailbreak.toString(), contains('SecurityThreatType.rootJailbreak'));
        expect(EngineSecurityThreatType.gpsFake.toString(), contains('SecurityThreatType.gpsFake'));
      });
    });

    group('Iteration and Collection Operations', () {
      test('should be iterable', () {
        var count = 0;
        for (final threatType in EngineSecurityThreatType.values) {
          expect(threatType, isA<EngineSecurityThreatType>());
          count++;
        }
        expect(count, equals(EngineSecurityThreatType.values.length));
      });

      test('should work with list operations', () {
        final list = EngineSecurityThreatType.values.toList();
        expect(list, contains(EngineSecurityThreatType.frida));
        expect(list, contains(EngineSecurityThreatType.emulator));
        expect(list, contains(EngineSecurityThreatType.debugger));
        expect(list, contains(EngineSecurityThreatType.unknown));
        expect(list, contains(EngineSecurityThreatType.rootJailbreak));
        expect(list, contains(EngineSecurityThreatType.gpsFake));
      });

      test('should work with set operations', () {
        final set = EngineSecurityThreatType.values.toSet();
        expect(set, contains(EngineSecurityThreatType.frida));
        expect(set.length, equals(EngineSecurityThreatType.values.length));
      });

      test('should work with where filter by severity', () {
        final highSeverityThreats = EngineSecurityThreatType.values
            .where((final type) => type.severityLevel >= 7)
            .toList();

        expect(highSeverityThreats, contains(EngineSecurityThreatType.frida));
        expect(highSeverityThreats, contains(EngineSecurityThreatType.rootJailbreak));
        expect(highSeverityThreats, contains(EngineSecurityThreatType.gpsFake));
        expect(highSeverityThreats, isNot(contains(EngineSecurityThreatType.debugger)));
      });

      test('should work with map operation', () {
        final displayNames = EngineSecurityThreatType.values.map((final type) => type.displayName).toList();

        expect(displayNames, contains('Frida Detection'));
        expect(displayNames, contains('Emulator Detection'));
        expect(displayNames, contains('Debugger Detection'));
        expect(displayNames, contains('Unknown Threat'));
        expect(displayNames, contains('Root/Jailbreak Detection'));
        expect(displayNames, contains('GPS Fake Detection'));
      });
    });

    group('Edge Cases and Validation', () {
      test('should handle switch statements', () {
        String getTypeDescription(final EngineSecurityThreatType type) {
          switch (type) {
            case EngineSecurityThreatType.frida:
              return 'Frida framework detected';
            case EngineSecurityThreatType.emulator:
              return 'Running on emulator';
            case EngineSecurityThreatType.debugger:
              return 'Debugger attached';
            case EngineSecurityThreatType.rootJailbreak:
              return 'Device is rooted/jailbroken';
            case EngineSecurityThreatType.unknown:
              return 'Unknown threat';
            case EngineSecurityThreatType.gpsFake:
              return 'GPS fake detected';
          }
        }

        expect(getTypeDescription(EngineSecurityThreatType.frida), equals('Frida framework detected'));
        expect(getTypeDescription(EngineSecurityThreatType.emulator), equals('Running on emulator'));
        expect(getTypeDescription(EngineSecurityThreatType.debugger), equals('Debugger attached'));
        expect(getTypeDescription(EngineSecurityThreatType.rootJailbreak), equals('Device is rooted/jailbroken'));
        expect(getTypeDescription(EngineSecurityThreatType.unknown), equals('Unknown threat'));
        expect(getTypeDescription(EngineSecurityThreatType.gpsFake), equals('GPS fake detected'));
      });

      test('should maintain enum order consistency', () {
        const valuesList = EngineSecurityThreatType.values;
        expect(valuesList.indexOf(EngineSecurityThreatType.unknown), equals(0));
        expect(valuesList.indexOf(EngineSecurityThreatType.frida), equals(1));
        expect(valuesList.indexOf(EngineSecurityThreatType.emulator), equals(2));
        expect(valuesList.indexOf(EngineSecurityThreatType.rootJailbreak), equals(3));
        expect(valuesList.indexOf(EngineSecurityThreatType.debugger), equals(4));
        expect(valuesList.indexOf(EngineSecurityThreatType.gpsFake), equals(5));
      });

      test('should work with json serialization scenarios', () {
        final enumNames = EngineSecurityThreatType.values.map((final e) => e.name).toList();

        expect(enumNames, contains('unknown'));
        expect(enumNames, contains('frida'));
        expect(enumNames, contains('emulator'));
        expect(enumNames, contains('rootJailbreak'));
        expect(enumNames, contains('debugger'));
        expect(enumNames, contains('gpsFake'));
      });
    });

    group('Severity and Risk Assessment', () {
      test('should have severity levels in expected range', () {
        for (final threatType in EngineSecurityThreatType.values) {
          expect(threatType.severityLevel, greaterThanOrEqualTo(0));
          expect(threatType.severityLevel, lessThanOrEqualTo(10));
        }
      });

      test('should categorize threats by severity level', () {
        final criticalThreats = EngineSecurityThreatType.values.where((final type) => type.severityLevel >= 8).toList();

        expect(criticalThreats, contains(EngineSecurityThreatType.frida));
        expect(criticalThreats, contains(EngineSecurityThreatType.rootJailbreak));
        expect(criticalThreats.length, equals(2));
      });

      test('should order threats by severity correctly', () {
        final orderedBySeverity = EngineSecurityThreatType.values.toList()
          ..sort((final a, final b) => b.severityLevel.compareTo(a.severityLevel));

        expect(orderedBySeverity.first, equals(EngineSecurityThreatType.frida));
        expect(orderedBySeverity.last, equals(EngineSecurityThreatType.debugger));
      });

      test('should handle severity-based filtering', () {
        final lowSeverityThreats = EngineSecurityThreatType.values
            .where((final type) => type.severityLevel <= 3)
            .toList();

        expect(lowSeverityThreats, contains(EngineSecurityThreatType.debugger));
        expect(lowSeverityThreats.length, equals(1));
      });
    });

    group('Business Logic', () {
      test('should identify most critical threats', () {
        final mostCritical = EngineSecurityThreatType.values.reduce(
          (final a, final b) => a.severityLevel > b.severityLevel ? a : b,
        );

        expect(mostCritical, equals(EngineSecurityThreatType.frida));
        expect(mostCritical.severityLevel, equals(9));
      });

      test('should identify least critical threats', () {
        final leastCritical = EngineSecurityThreatType.values.reduce(
          (final a, final b) => a.severityLevel < b.severityLevel ? a : b,
        );

        expect(leastCritical, equals(EngineSecurityThreatType.debugger));
        expect(leastCritical.severityLevel, equals(2));
      });

      test('should calculate average severity', () {
        final totalSeverity = EngineSecurityThreatType.values
            .map((final type) => type.severityLevel)
            .reduce((final a, final b) => a + b);

        final averageSeverity = totalSeverity / EngineSecurityThreatType.values.length;
        expect(averageSeverity, closeTo(6.17, 0.1));
      });
    });
  });
}
