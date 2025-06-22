// ignore_for_file: empty_catches

import 'dart:io';

import 'package:engine_security/src/src.dart';

class EngineDebuggerDetector implements ISecurityDetector {
  EngineDebuggerDetector({this.enabled = true});

  final bool enabled;

  @override
  SecurityThreatType get threatType => SecurityThreatType.debugger;

  @override
  String get detectorName => 'DebuggerDetector';

  @override
  bool get isAvailable => enabled;

  @override
  DetectorInfoModel get detectorInfo => DetectorInfoModel(
    name: detectorName,
    threatType: threatType,
    enabled: enabled,
    platform: Platform.operatingSystem,
  );

  @override
  Future<SecurityCheckModel> performCheck() async {
    if (!enabled) {
      return SecurityCheckModel.secure(
        isSecure: false,
        details: 'Debugger detector disabled',
        detectionMethod: 'performCheck',
        confidence: 1,
      );
    }

    try {
      final detectionMethods = <String>[
        if (Platform.isAndroid) ...await _checkAndroidDebugger(),
        if (Platform.isIOS) ...await _checkIOSDebugger(),
        ?await _checkTimingAttack(),
      ];

      if (detectionMethods.isNotEmpty) {
        return SecurityCheckModel.threat(
          threatType: SecurityThreatType.debugger,
          details: 'Debugger detected: ${detectionMethods.join(', ')}',
          detectionMethod: 'platform_specific_detection',
          confidence: 0.50,
        );
      }

      return SecurityCheckModel.secure(
        details: 'No debugger detected',
        detectionMethod: 'debugger_checks',
      );
    } catch (e) {
      return SecurityCheckModel.secure(
        details: 'Debugger detection failed: $e',
        detectionMethod: 'performCheck: error_handling',
        confidence: 0.50,
      );
    }
  }

  Future<List<String>> _checkAndroidDebugger() async {
    final indicators = <String>[];

    final result =
        await Process.run('cat', [
          '/proc/self/status',
        ], runInShell: true).catchError(
          (final _) => ProcessResult(0, 1, '', ''),
        );

    if (result.exitCode == 0) {
      final output = result.stdout.toString();

      final lines = output.split('\n');
      for (final line in lines) {
        if (line.startsWith('TracerPid:')) {
          final tracerPid = line.split('\t').last.trim();
          if (tracerPid != '0') {
            indicators.add('Process being traced (PID: $tracerPid)');
          }
          break;
        }
      }
    }

    final psResult =
        await Process.run('ps', [
          '-ef',
        ], runInShell: true).catchError(
          (final _) => ProcessResult(0, 1, '', ''),
        );

    if (psResult.exitCode == 0) {
      final output = psResult.stdout.toString().toLowerCase();

      final debuggerProcesses = [
        'gdb',
        'lldb',
        'strace',
        'ltrace',
        'ptrace',
      ];

      for (final debugger in debuggerProcesses) {
        if (output.contains(debugger.toLowerCase())) {
          indicators.add('Debugger process detected: $debugger');
          break;
        }
      }
    }

    return indicators;
  }

  Future<List<String>> _checkIOSDebugger() async {
    final indicators = <String>[];

    final psResult = await Process.run('ps', [
      '-ef',
    ], runInShell: true).catchError((final _) => ProcessResult(0, 1, '', ''));

    if (psResult.exitCode == 0) {
      final output = psResult.stdout.toString().toLowerCase();

      final debuggerProcesses = [
        'debugserver',
        'lldb',
        'gdb',
        'cycript',
      ];

      for (final debugger in debuggerProcesses) {
        if (output.contains(debugger)) {
          indicators.add('Debugger process detected: $debugger');
          break;
        }
      }
    }

    return indicators;
  }

  Future<String?> _checkTimingAttack() async {
    final stopwatch = Stopwatch()..start();

    var result = 0;
    for (var i = 0; i < 1000000; i++) {
      result += i;
    }

    stopwatch.stop();

    if (stopwatch.elapsedMilliseconds > 100 && result > 0) {
      return 'Unusual execution timing detected (${stopwatch.elapsedMilliseconds}ms)';
    }

    return null;
  }
}
