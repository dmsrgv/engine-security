// ignore_for_file: avoid_print

import 'package:engine_security/engine_security.dart';

Future<void> main() async {
  print('🔒 Engine Security - Example Usage\n');

  final detectors = [
    EngineDebuggerDetector(),
    EngineEmulatorDetector(),
    EngineFridaDetector(),
    EngineRootDetector(),
  ];

  print('Available Security Detectors:');
  for (final detector in detectors) {
    final info = detector.detectorInfo;
    print('  - ${info.name}: ${info.threatType} (Enabled: ${info.enabled})');
  }

  print('\n🔍 Running Security Checks...\n');

  for (final detector in detectors) {
    try {
      print('Checking ${detector.detectorName}...');
      final result = await detector.performCheck();

      final status = result.isSecure ? '✅ SECURE' : '⚠️  THREAT DETECTED';
      print('  Result: $status');
      print('  Details: ${result.details}');
      print('  Method: ${result.detectionMethod}');
      print('  Confidence: ${(result.confidence * 100).toStringAsFixed(1)}%');

      if (!result.isSecure) {
        print('  Threat Type: ${result.threatType}');
      }

      print('');
    } catch (e) {
      print('  ❌ Error: $e');
      print('');
    }
  }

  final debuggerDetector = EngineDebuggerDetector(enabled: false);
  print('Example with disabled detector:');
  final disabledResult = await debuggerDetector.performCheck();
  print('  Disabled detector result: ${disabledResult.details}');
  print('  Confidence: ${(disabledResult.confidence * 100).toStringAsFixed(1)}%');

  print('\n🎯 Security Check Summary:');
  print('  All security detectors have been executed successfully!');
  print('  Use these detectors in your Flutter app to enhance security.');
}
