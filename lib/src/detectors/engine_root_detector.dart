// ignore_for_file: empty_catches

import 'dart:io';

import 'package:engine_security/src/src.dart';

class EngineRootDetector implements IEngineSecurityDetector {
  EngineRootDetector({this.enabled = true});

  final bool enabled;

  @override
  EngineSecurityThreatType get threatType => EngineSecurityThreatType.rootJailbreak;

  @override
  String get detectorName => 'RootDetector';

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
        return EngineSecurityCheckModel.threat(
          threatType: EngineSecurityThreatType.rootJailbreak,
          details: 'Root/Jailbreak detected: ${detectionMethods.join(', ')}',
          detectionMethod: 'platform_specific_checks',
          confidence: 0.90,
        );
      }

      return EngineSecurityCheckModel.secure(
        details: 'No root/jailbreak detected',
        detectionMethod: 'platform_checks',
        confidence: 0.85,
      );
    } catch (e) {
      return EngineSecurityCheckModel.secure(
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
        final output = result.stdout.toString();
        if (output.contains('uid=0') || output.contains('root')) {
          indicators.add('Su command successful with root privileges');
        }
      }
    } catch (e) {}

    try {
      final result = await Process.run('getprop', ['ro.build.tags'], runInShell: true);
      if (result.exitCode == 0) {
        final buildTags = result.stdout.toString().toLowerCase().trim();
        if (buildTags.contains('test-keys')) {
          final debuggable = await Process.run('getprop', ['ro.debuggable'], runInShell: true);
          final secure = await Process.run('getprop', ['ro.secure'], runInShell: true);

          if (debuggable.exitCode == 0 && secure.exitCode == 0) {
            final isDebuggable = debuggable.stdout.toString().trim() == '1';
            final isSecure = secure.stdout.toString().trim() == '1';

            if (!isSecure && !isDebuggable) {
              indicators.add('Insecure build with test-keys detected');
            }
          }
        }
      }
    } catch (e) {}

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
