// ignore_for_file: empty_catches

import 'dart:io';

import 'package:engine_security/src/src.dart';

/// Detector for debuggers attached to the application process.
///
/// IMPORTANT: This detector does NOT only detect "USB Debugging enabled".
/// It specifically checks if there is a debugger actively monitoring
/// or instrumenting the application process.
///
/// Differences:
/// - USB Debugging: Allows connecting device to PC (not a threat)
/// - Attached debugger: Active process controlling/monitoring the app (threat)
///
/// Checks performed:
/// - TracerPid: If another process is "tracking" this process
/// - Debugger processes: gdb, lldb, strace, ptrace, etc.
/// - Timing attack: Detects instrumentation by execution time
/// - Active ADB connections: Active remote debugging
class EngineDebuggerDetector implements IEngineSecurityDetector {
  EngineDebuggerDetector({this.enabled = true});

  final bool enabled;

  @override
  EngineSecurityThreatType get threatType => EngineSecurityThreatType.debugger;

  @override
  String get detectorName => 'DebuggerDetector';

  @override
  bool get isAvailable => enabled;

  @override
  EngineDetectorInfoModel get detectorInfo => EngineDetectorInfoModel(
    name: detectorName,
    threatType: threatType,
    enabled: enabled,
    platform: Platform.operatingSystem,
  );

  @override
  Future<EngineSecurityCheckModel> performCheck() async {
    if (!enabled) {
      return EngineSecurityCheckModel.secure(
        details: 'Debugger detector disabled',
        detectionMethod: 'disabled_check',
        confidence: 1.0,
      );
    }

    try {
      final detectionMethods = <String>[
        if (Platform.isAndroid) ...await _checkAndroidDebugger(),
        if (Platform.isIOS) ...await _checkIOSDebugger(),
        ?await _checkTimingAttack(),
      ];

      if (detectionMethods.isNotEmpty) {
        return EngineSecurityCheckModel.threat(
          threatType: EngineSecurityThreatType.debugger,
          details: 'Debugger detected: ${detectionMethods.join(', ')}',
          detectionMethod: 'platform_specific_detection',
          confidence: 0.85,
        );
      }

      return EngineSecurityCheckModel.secure(
        details: 'No debugger detected',
        detectionMethod: 'debugger_checks',
        confidence: 0.80,
      );
    } catch (e) {
      return EngineSecurityCheckModel.secure(
        details: 'Debugger detection failed: $e',
        detectionMethod: 'error_handling',
        confidence: 0.50,
      );
    }
  }

  Future<List<String>> _checkAndroidDebugger() async {
    final indicators = <String>[];

    // Verificação principal: processo sendo trackeado
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

    // Verificação de processos debugger ativos
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

    // Verificação adicional: aplicações de debugging conectadas
    try {
      final debuggableResult = await Process.run('getprop', ['ro.debuggable'], runInShell: true);
      final adbResult = await Process.run('getprop', ['service.adb.tcp.port'], runInShell: true);

      if (debuggableResult.exitCode == 0 && adbResult.exitCode == 0) {
        final isDebuggable = debuggableResult.stdout.toString().trim() == '1';
        final adbPort = adbResult.stdout.toString().trim();

        // Se é debuggable E tem porta ADB ativa, pode indicar debugging ativo
        if (isDebuggable && adbPort.isNotEmpty && adbPort != '-1') {
          // Verificar se há realmente conexão ADB ativa
          final netstatResult = await Process.run('netstat', ['-an'], runInShell: true).catchError(
            (final _) => ProcessResult(0, 1, '', ''),
          );

          if (netstatResult.exitCode == 0) {
            final netOutput = netstatResult.stdout.toString();
            if (netOutput.contains(':$adbPort') || netOutput.contains('5037')) {
              indicators.add('Active ADB debugging connection detected');
            }
          }
        }
      }
    } catch (e) {
      // Falha silenciosa, não é crítico
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
