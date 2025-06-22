import 'dart:io';

import 'package:engine_security/src/src.dart';

class EngineFridaDetector implements ISecurityDetector {
  EngineFridaDetector({this.enabled = true});

  final bool enabled;

  @override
  SecurityThreatType get threatType => SecurityThreatType.frida;

  @override
  String get detectorName => 'FridaDetector';

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
        details: 'Frida detector disabled',
        detectionMethod: 'disabled_check',
        confidence: 1.0,
      );
    }

    try {
      final results = await Future.wait([
        _detectFridaServer(),
        _detectFridaLibraries(),
        _detectFridaPorts(),
        _detectFridaProcesses(),
        _detectFridaFiles(),
        _detectDynamicInstrumentation(),
      ]);

      final detectedMethods = <String>[];
      final detected = results.any((final result) => result.isNotEmpty);

      for (var i = 0; i < results.length; i++) {
        if (results[i].isNotEmpty) {
          detectedMethods.add(results[i]);
        }
      }

      if (detected) {
        return SecurityCheckModel.threat(
          threatType: SecurityThreatType.frida,
          details: 'Frida framework detected: ${detectedMethods.join(', ')}',
          detectionMethod: 'multi_vector_detection',
          confidence: 0.95,
        );
      }

      return SecurityCheckModel.secure(
        details: 'No Frida instrumentation detected',
        detectionMethod: 'performCheck: multi_vector_scan',
        confidence: 0.90,
      );
    } catch (e) {
      return SecurityCheckModel.secure(
        details: 'Frida detection failed: $e',
        detectionMethod: 'error_handling',
        confidence: 0.50,
      );
    }
  }

  Future<String> _detectFridaServer() async {
    final fridaPorts = [27042, 27043, 27044, 27045];

    for (final port in fridaPorts) {
      try {
        final socket = await Socket.connect('127.0.0.1', port, timeout: const Duration(milliseconds: 100));
        await socket.close();
        return 'Frida server on port $port';
      } catch (e) {
        continue;
      }
    }

    return '';
  }

  Future<String> _detectFridaLibraries() async {
    final result =
        await Process.run('cat', [
          '/proc/self/maps',
        ], runInShell: true).catchError(
          (final _) => ProcessResult(0, 1, '', ''),
        );

    if (result.exitCode == 0) {
      final output = result.stdout.toString().toLowerCase();

      final fridaLibraries = [
        'frida',
        'gumjs',
        'gadget',
      ];

      for (final lib in fridaLibraries) {
        if (output.contains(lib)) {
          return 'Frida library: $lib';
        }
      }
    }

    return '';
  }

  Future<String> _detectFridaPorts() async {
    final result = await Process.run('netstat', [
      '-an',
    ], runInShell: true).catchError((final _) => ProcessResult(0, 1, '', ''));

    if (result.exitCode == 0) {
      final output = result.stdout.toString();

      final fridaPorts = ['27042', '27043', '27044', '27045'];

      for (final port in fridaPorts) {
        if (output.contains(':$port ')) {
          return 'Frida port: $port';
        }
      }
    }

    return '';
  }

  Future<String> _detectFridaProcesses() async {
    final result =
        await Process.run('ps', [
          '-ef',
        ], runInShell: true).catchError(
          (final _) => ProcessResult(0, 1, '', ''),
        );

    if (result.exitCode == 0) {
      final output = result.stdout.toString().toLowerCase();

      final fridaProcesses = [
        'frida',
        'frida-server',
        'gum-js-loop',
        'gadget',
      ];

      for (final process in fridaProcesses) {
        if (output.contains(process)) {
          return 'Frida process: $process';
        }
      }
    }

    return '';
  }

  Future<String> _detectFridaFiles() async {
    final fridaFiles = [
      '/data/local/tmp/frida-server',
      '/system/lib/libfrida-gadget.so',
      '/system/lib64/libfrida-gadget.so',
      '/data/local/tmp/re.frida.server',
      '/sdcard/frida-server',
    ];

    for (final path in fridaFiles) {
      final file = File(path);
      if (file.existsSync()) {
        return 'Frida file: $path';
      }
    }

    return '';
  }

  Future<String> _detectDynamicInstrumentation() async {
    if (Platform.isAndroid) {
      final result = await Process.run('cat', [
        '/proc/self/status',
      ], runInShell: true).catchError((final _) => ProcessResult(0, 1, '', ''));

      if (result.exitCode == 0) {
        final output = result.stdout.toString();

        if (output.contains('TracerPid:') && !output.contains('TracerPid:\t0')) {
          return 'Process being traced';
        }
      }
    }

    return '';
  }
}
