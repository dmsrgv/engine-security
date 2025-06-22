import 'package:engine_security/engine_security.dart';
import 'package:flutter_test/flutter_test.dart';

class MockSecurityDetector implements ISecurityDetector {
  final SecurityCheckModel _mockResult;
  final DetectorInfoModel _mockDetectorInfo;
  final SecurityThreatType _threatType;
  final String _detectorName;
  final bool _isAvailable;

  MockSecurityDetector({
    required final SecurityCheckModel mockResult,
    required final DetectorInfoModel mockDetectorInfo,
    required final SecurityThreatType threatType,
    required final String detectorName,
    final bool isAvailable = true,
  }) : _mockResult = mockResult,
       _mockDetectorInfo = mockDetectorInfo,
       _threatType = threatType,
       _detectorName = detectorName,
       _isAvailable = isAvailable;

  @override
  Future<SecurityCheckModel> performCheck() async => _mockResult;

  @override
  DetectorInfoModel get detectorInfo => _mockDetectorInfo;

  @override
  SecurityThreatType get threatType => _threatType;

  @override
  String get detectorName => _detectorName;

  @override
  bool get isAvailable => _isAvailable;
}

void main() {
  group('ISecurityDetector', () {
    late MockSecurityDetector mockDetector;
    late SecurityCheckModel secureResult;
    late SecurityCheckModel threatResult;
    late DetectorInfoModel detectorInfo;

    setUp(() {
      secureResult = SecurityCheckModel.secure();
      threatResult = SecurityCheckModel.threat(
        threatType: SecurityThreatType.frida,
      );
      detectorInfo = const DetectorInfoModel(
        name: 'Mock Detector',
        threatType: SecurityThreatType.frida,
        enabled: true,
        platform: 'Test',
      );
      mockDetector = MockSecurityDetector(
        mockResult: secureResult,
        mockDetectorInfo: detectorInfo,
        threatType: SecurityThreatType.frida,
        detectorName: 'Mock Detector',
      );
    });

    group('Interface Contract', () {
      test('should implement performCheck method', () async {
        final result = await mockDetector.performCheck();
        expect(result, isA<SecurityCheckModel>());
        expect(result.isSecure, isTrue);
      });

      test('should implement detectorInfo getter', () {
        final info = mockDetector.detectorInfo;
        expect(info, isA<DetectorInfoModel>());
        expect(info.name, equals('Mock Detector'));
        expect(info.threatType, equals(SecurityThreatType.frida));
        expect(info.enabled, isTrue);
        expect(info.platform, equals('Test'));
      });

      test('should implement threatType getter', () {
        expect(mockDetector.threatType, equals(SecurityThreatType.frida));
      });

      test('should implement detectorName getter', () {
        expect(mockDetector.detectorName, equals('Mock Detector'));
      });

      test('should implement isAvailable getter', () {
        expect(mockDetector.isAvailable, isTrue);
      });
    });

    group('Return Types', () {
      test('performCheck should return Future<SecurityCheckModel>', () async {
        final result = mockDetector.performCheck();
        expect(result, isA<Future<SecurityCheckModel>>());

        final resolvedResult = await result;
        expect(resolvedResult, isA<SecurityCheckModel>());
      });

      test('detectorInfo should return DetectorInfoModel', () {
        final info = mockDetector.detectorInfo;
        expect(info, isA<DetectorInfoModel>());
        expect(info.runtimeType, equals(DetectorInfoModel));
      });

      test('threatType should return SecurityThreatType', () {
        final threatType = mockDetector.threatType;
        expect(threatType, isA<SecurityThreatType>());
      });

      test('detectorName should return String', () {
        final name = mockDetector.detectorName;
        expect(name, isA<String>());
        expect(name.isNotEmpty, isTrue);
      });

      test('isAvailable should return bool', () {
        final available = mockDetector.isAvailable;
        expect(available, isA<bool>());
      });
    });

    group('Mock Implementation Behavior', () {
      test('should return secure result when configured', () async {
        final detector = MockSecurityDetector(
          mockResult: secureResult,
          mockDetectorInfo: detectorInfo,
          threatType: SecurityThreatType.unknown,
          detectorName: 'Secure Detector',
        );
        final result = await detector.performCheck();

        expect(result.isSecure, isTrue);
        expect(result.threatType, equals(SecurityThreatType.unknown));
      });

      test('should return threat result when configured', () async {
        final detector = MockSecurityDetector(
          mockResult: threatResult,
          mockDetectorInfo: detectorInfo,
          threatType: SecurityThreatType.frida,
          detectorName: 'Frida Detector',
        );
        final result = await detector.performCheck();

        expect(result.isSecure, isFalse);
        expect(result.threatType, equals(SecurityThreatType.frida));
      });

      test('should return consistent detector info', () {
        final detector = MockSecurityDetector(
          mockResult: secureResult,
          mockDetectorInfo: detectorInfo,
          threatType: SecurityThreatType.frida,
          detectorName: 'Test Detector',
        );

        expect(detector.detectorInfo, equals(detectorInfo));
        expect(detector.detectorInfo, same(detectorInfo));
      });

      test('should handle unavailable detector', () {
        final detector = MockSecurityDetector(
          mockResult: secureResult,
          mockDetectorInfo: detectorInfo,
          threatType: SecurityThreatType.frida,
          detectorName: 'Unavailable Detector',
          isAvailable: false,
        );

        expect(detector.isAvailable, isFalse);
      });
    });

    group('Interface Polymorphism', () {
      test('should work as ISecurityDetector type', () async {
        final ISecurityDetector detector = MockSecurityDetector(
          mockResult: secureResult,
          mockDetectorInfo: detectorInfo,
          threatType: SecurityThreatType.frida,
          detectorName: 'Polymorphic Detector',
        );

        final result = await detector.performCheck();
        final info = detector.detectorInfo;
        final threatType = detector.threatType;
        final name = detector.detectorName;
        final available = detector.isAvailable;

        expect(result, isA<SecurityCheckModel>());
        expect(info, isA<DetectorInfoModel>());
        expect(threatType, isA<SecurityThreatType>());
        expect(name, isA<String>());
        expect(available, isA<bool>());
      });

      test('should handle different detector implementations', () async {
        final detectors = <ISecurityDetector>[
          MockSecurityDetector(
            mockResult: secureResult,
            mockDetectorInfo: detectorInfo,
            threatType: SecurityThreatType.unknown,
            detectorName: 'Detector 1',
          ),
          MockSecurityDetector(
            mockResult: threatResult,
            mockDetectorInfo: detectorInfo,
            threatType: SecurityThreatType.frida,
            detectorName: 'Detector 2',
          ),
        ];

        for (final detector in detectors) {
          final result = await detector.performCheck();
          final info = detector.detectorInfo;

          expect(result, isA<SecurityCheckModel>());
          expect(info, isA<DetectorInfoModel>());
          expect(detector, isA<ISecurityDetector>());
        }
      });
    });

    group('Async Behavior', () {
      test('should handle async performCheck calls', () async {
        final futures = List.generate(
          5,
          (_) => mockDetector.performCheck(),
        );

        final results = await Future.wait(futures);

        expect(results.length, equals(5));
        for (final result in results) {
          expect(result, isA<SecurityCheckModel>());
          expect(result.isSecure, isTrue);
        }
      });

      test('should handle concurrent calls', () async {
        final detector1 = MockSecurityDetector(
          mockResult: secureResult,
          mockDetectorInfo: detectorInfo,
          threatType: SecurityThreatType.unknown,
          detectorName: 'Detector 1',
        );
        final detector2 = MockSecurityDetector(
          mockResult: threatResult,
          mockDetectorInfo: detectorInfo,
          threatType: SecurityThreatType.frida,
          detectorName: 'Detector 2',
        );

        final results = await Future.wait([
          detector1.performCheck(),
          detector2.performCheck(),
        ]);

        expect(results[0].isSecure, isTrue);
        expect(results[1].isSecure, isFalse);
      });
    });

    group('Error Handling', () {
      test('should handle detector that throws exception', () async {
        final errorDetector = MockSecurityDetectorWithError();

        expect(
          () => errorDetector.performCheck(),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle detector with exception in getter', () {
        final nullInfoDetector = MockSecurityDetectorWithNullInfo();

        expect(
          () => nullInfoDetector.detectorInfo,
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Real-world Usage Patterns', () {
      test('should work in detector factory pattern', () async {
        ISecurityDetector createDetector(
          final SecurityThreatType threatType,
          final String name,
        ) {
          final info = DetectorInfoModel(
            name: name,
            threatType: threatType,
            enabled: true,
            platform: 'Test',
          );
          final result = SecurityCheckModel.threat(threatType: threatType);
          return MockSecurityDetector(
            mockResult: result,
            mockDetectorInfo: info,
            threatType: threatType,
            detectorName: name,
          );
        }

        final fridaDetector = createDetector(SecurityThreatType.frida, 'Frida Detector');
        final emulatorDetector = createDetector(SecurityThreatType.emulator, 'Emulator Detector');

        final fridaResult = await fridaDetector.performCheck();
        final emulatorResult = await emulatorDetector.performCheck();

        expect(fridaResult.threatType, equals(SecurityThreatType.frida));
        expect(emulatorResult.threatType, equals(SecurityThreatType.emulator));
        expect(fridaDetector.detectorName, equals('Frida Detector'));
        expect(emulatorDetector.detectorName, equals('Emulator Detector'));
      });

      test('should work in security scanner pattern', () async {
        final detectors = <ISecurityDetector>[
          MockSecurityDetector(
            mockResult: SecurityCheckModel.secure(),
            mockDetectorInfo: const DetectorInfoModel(
              name: 'Secure Detector',
              threatType: SecurityThreatType.unknown,
              enabled: true,
              platform: 'Test',
            ),
            threatType: SecurityThreatType.unknown,
            detectorName: 'Secure Detector',
          ),
          MockSecurityDetector(
            mockResult: SecurityCheckModel.threat(threatType: SecurityThreatType.frida),
            mockDetectorInfo: const DetectorInfoModel(
              name: 'Frida Detector',
              threatType: SecurityThreatType.frida,
              enabled: true,
              platform: 'Test',
            ),
            threatType: SecurityThreatType.frida,
            detectorName: 'Frida Detector',
          ),
        ];

        final results = await Future.wait(
          detectors.map((final detector) => detector.performCheck()),
        );

        final threats = results.where((final result) => !result.isSecure).toList();
        expect(threats.length, equals(1));
        expect(threats.first.threatType, equals(SecurityThreatType.frida));

        final availableDetectors = detectors.where((final d) => d.isAvailable).toList();
        expect(availableDetectors.length, equals(2));
      });
    });
  });
}

class MockSecurityDetectorWithError implements ISecurityDetector {
  @override
  Future<SecurityCheckModel> performCheck() async {
    throw Exception('Mock error for testing');
  }

  @override
  DetectorInfoModel get detectorInfo => const DetectorInfoModel(
    name: 'Error Detector',
    threatType: SecurityThreatType.unknown,
    enabled: true,
    platform: 'Test',
  );

  @override
  SecurityThreatType get threatType => SecurityThreatType.unknown;

  @override
  String get detectorName => 'Error Detector';

  @override
  bool get isAvailable => true;
}

class MockSecurityDetectorWithNullInfo implements ISecurityDetector {
  @override
  Future<SecurityCheckModel> performCheck() async => SecurityCheckModel.secure();

  @override
  DetectorInfoModel get detectorInfo {
    throw Exception('Info not available');
  }

  @override
  SecurityThreatType get threatType => SecurityThreatType.unknown;

  @override
  String get detectorName => 'Null Info Detector';

  @override
  bool get isAvailable => false;
}
