import 'package:engine_security/engine_security.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/detector_test_result.dart';

class SecurityTestNotifier extends StateNotifier<Map<String, DetectorTestResult?>> {
  SecurityTestNotifier() : super({});

  Future<void> runDetectorTest(String detectorName) async {
    final stopwatch = Stopwatch()..start();

    state = {
      ...state,
      detectorName: DetectorTestResult(
        detectorName: detectorName,
        result: SecurityCheckModel.secure(details: 'Preparando teste...'),
        timestamp: DateTime.now(),
        executionTime: Duration.zero,
        isRunning: true,
      ),
    };

    try {
      late ISecurityDetector detector;

      switch (detectorName) {
        case 'Frida':
          detector = EngineFridaDetector(enabled: true);
          break;
        case 'Root/Jailbreak':
          detector = EngineRootDetector(enabled: true);
          break;
        case 'Emulator':
          detector = EngineEmulatorDetector(enabled: true);
          break;
        case 'Debugger':
          detector = EngineDebuggerDetector(enabled: true);
          break;
        case 'GPS Fake':
          detector = EngineGpsFakeDetector(enabled: true);
          break;
        default:
          throw Exception('Detector não encontrado: $detectorName');
      }

      if (!detector.isAvailable) {
        throw Exception('Detector não disponível nesta plataforma');
      }

      final result = await detector.performCheck();
      stopwatch.stop();

      state = {
        ...state,
        detectorName: DetectorTestResult(
          detectorName: detectorName,
          result: result,
          timestamp: DateTime.now(),
          executionTime: stopwatch.elapsed,
          isRunning: false,
        ),
      };
    } catch (e) {
      stopwatch.stop();

      state = {
        ...state,
        detectorName: DetectorTestResult(
          detectorName: detectorName,
          result: SecurityCheckModel.secure(details: 'Erro no teste: $e', confidence: 0.0),
          timestamp: DateTime.now(),
          executionTime: stopwatch.elapsed,
          isRunning: false,
        ),
      };
    }
  }

  Future<void> runAllTests() async {
    final detectors = ['Frida', 'Root/Jailbreak', 'Emulator', 'Debugger', 'GPS Fake'];

    for (final detector in detectors) {
      await runDetectorTest(detector);
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  void clearResults() {
    state = {};
  }

  DetectorTestResult? getResult(String detectorName) {
    return state[detectorName];
  }
}

final securityTestProvider = StateNotifierProvider<SecurityTestNotifier, Map<String, DetectorTestResult?>>((ref) {
  return SecurityTestNotifier();
});

final securitySummaryProvider = Provider<SecuritySummary>((ref) {
  final tests = ref.watch(securityTestProvider);

  int totalTests = tests.length;
  int completedTests = tests.values.where((test) => test != null && !test.isRunning).length;
  int threatsDetected = tests.values.where((test) => test != null && !test.isRunning && !test.result.isSecure).length;
  int secureTests = tests.values.where((test) => test != null && !test.isRunning && test.result.isSecure).length;

  return SecuritySummary(
    totalTests: totalTests,
    completedTests: completedTests,
    threatsDetected: threatsDetected,
    secureTests: secureTests,
    isRunning: tests.values.any((test) => test?.isRunning == true),
  );
});

class SecuritySummary {
  final int totalTests;
  final int completedTests;
  final int threatsDetected;
  final int secureTests;
  final bool isRunning;

  const SecuritySummary({
    required this.totalTests,
    required this.completedTests,
    required this.threatsDetected,
    required this.secureTests,
    required this.isRunning,
  });

  double get completionPercentage => totalTests > 0 ? (completedTests / totalTests) * 100 : 0.0;

  String get overallStatus {
    if (isRunning) return 'Executando testes...';
    if (completedTests == 0) return 'Nenhum teste executado';
    if (threatsDetected > 0) return 'Ameaças detectadas!';
    return 'Sistema seguro';
  }
}
