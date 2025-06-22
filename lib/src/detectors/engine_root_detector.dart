// ignore_for_file: empty_catches

import 'dart:io';

import 'package:engine_security/src/src.dart';

class EngineRootDetector implements ISecurityDetector {
  EngineRootDetector({this.enabled = true});

  final bool enabled;

  @override
  SecurityThreatType get threatType => SecurityThreatType.rootJailbreak;

  @override
  String get detectorName => 'RootDetector';

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
        details: 'Root detector disabled',
        detectionMethod: 'disabled_check',
        confidence: 1.0,
      );
    }

    try {
      final detectionMethods = <String>[
        if (Platform.isAndroid) ...await _checkAndroidRoot(),
        if (Platform.isIOS) ...await _checkIOSJailbreak(),
      ];

      if (detectionMethods.isNotEmpty) {
        return SecurityCheckModel.threat(
          threatType: SecurityThreatType.rootJailbreak,
          details: 'Root/Jailbreak detected: ${detectionMethods.join(', ')}',
          detectionMethod: 'platform_specific_checks',
          confidence: 0.90,
        );
      }

      return SecurityCheckModel.secure(
        details: 'No root/jailbreak detected',
        detectionMethod: 'platform_checks',
        confidence: 0.85,
      );
    } catch (e) {
      return SecurityCheckModel.secure(
        details: 'Root detection failed: $e',
        detectionMethod: 'error_handling',
        confidence: 0.50,
      );
    }
  }

  Future<List<String>> _checkAndroidRoot() async {
    final indicators = <String>[];

    final rootFiles = [
      '/system/app/Superuser.apk',
      '/sbin/su',
      '/system/bin/su',
      '/system/xbin/su',
      '/data/local/xbin/su',
      '/data/local/bin/su',
      '/system/sd/xbin/su',
      '/system/bin/failsafe/su',
      '/data/local/su',
      '/su/bin/su',
      '/system/xbin/which',
      '/data/local/xbin/which',
      '/system/bin/which',
      '/system/xbin/busybox',
      '/system/bin/busybox',
      '/data/local/xbin/busybox',
    ];

    for (final path in rootFiles) {
      final file = File(path);
      if (file.existsSync()) {
        indicators.add('Root file found: $path');
        break;
      }
    }

    final rootApps = [
      '/data/data/com.noshufou.android.su',
      '/data/data/com.noshufou.android.su.elite',
      '/data/data/eu.chainfire.supersu',
      '/data/data/com.koushikdutta.superuser',
      '/data/data/com.thirdparty.superuser',
      '/data/data/com.yellowes.su',
      '/data/data/com.koushikdutta.rommanager',
      '/data/data/com.koushikdutta.rommanager.license',
      '/data/data/com.dimonvideo.luckypatcher',
      '/data/data/com.chelpus.lackypatch',
      '/data/data/com.ramdroid.appquarantine',
    ];

    for (final path in rootApps) {
      final dir = Directory(path);
      if (dir.existsSync()) {
        indicators.add('Root app detected');
        break;
      }
    }

    try {
      final result = await Process.run('su', ['-c', 'id'], runInShell: true).timeout(const Duration(seconds: 1));
      if (result.exitCode == 0) {
        indicators.add('Su command successful');
      }
    } catch (e) {}

    final result = await Process.run('getprop', ['ro.build.tags'], runInShell: true);
    if (result.exitCode == 0 && result.stdout.toString().toLowerCase().contains('test-keys')) {
      indicators.add('Test keys build detected');
    }

    return indicators;
  }

  Future<List<String>> _checkIOSJailbreak() async {
    final indicators = <String>[];

    final jailbreakFiles = [
      '/Applications/Cydia.app',
      '/Library/MobileSubstrate/MobileSubstrate.dylib',
      '/bin/bash',
      '/usr/sbin/sshd',
      '/etc/apt',
      '/private/var/lib/apt/',
      '/private/var/lib/cydia',
      '/private/var/mobile/Library/SBSettings/Themes',
      '/System/Library/LaunchDaemons/com.ikey.bbot.plist',
      '/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist',
      '/private/var/tmp/cydia.log',
      '/private/var/lib/cydia',
      '/private/var/cache/apt',
      '/private/var/log/syslog',
      '/private/var/tmp/cydia.log',
      '/Applications/Icy.app',
      '/Applications/MxTube.app',
      '/Applications/RockApp.app',
      '/Applications/blackra1n.app',
      '/Applications/SBSettings.app',
      '/Applications/FakeCarrier.app',
      '/Applications/WinterBoard.app',
      '/Applications/IntelliScreen.app',
    ];

    for (final path in jailbreakFiles) {
      final file = File(path);
      if (file.existsSync()) {
        indicators.add('Jailbreak file found: $path');
        break;
      }
    }

    final testFile = File('/private/test_jailbreak');
    await testFile.writeAsString('test');
    if (testFile.existsSync()) {
      await testFile.delete();
      indicators.add('Write access to restricted directory');
    }

    return indicators;
  }
}
