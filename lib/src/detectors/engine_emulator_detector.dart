import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:engine_security/src/src.dart';

class EngineEmulatorDetector implements ISecurityDetector {
  EngineEmulatorDetector({this.enabled = true});

  final bool enabled;

  @override
  SecurityThreatType get threatType => SecurityThreatType.emulator;

  @override
  String get detectorName => 'EmulatorDetector';

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
        details: 'Emulator detector disabled',
        detectionMethod: 'disabled_check',
        confidence: 1.0,
      );
    }

    final detectionMethods = <String>[
      if (Platform.isAndroid) ...await _checkAndroidEmulator(),
      if (Platform.isIOS) ...await _checkIOSSimulator(),
    ];

    return detectionMethods.isNotEmpty
        ? SecurityCheckModel.threat(
            threatType: SecurityThreatType.emulator,
            details: 'Emulator/Simulator detected: ${detectionMethods.join(', ')}',
            detectionMethod: 'platform_specific_checks',
            confidence: 0.85,
          )
        : SecurityCheckModel.secure(
            details: 'No emulator/simulator detected',
            detectionMethod: 'platform_checks',
            confidence: 0.80,
          );
  }

  Future<List<String>> _checkAndroidEmulator() async {
    final indicators = <String>[];

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    final emulatorBrands = ['generic', 'unknown', 'emulator', 'android', 'google_sdk'];
    final emulatorModels = ['sdk', 'emulator', 'android sdk built for x86'];

    if (emulatorBrands.contains(androidInfo.brand.toLowerCase())) {
      indicators.add('Emulator brand: ${androidInfo.brand}');
    }

    if (emulatorModels.any((final model) => androidInfo.model.toLowerCase().contains(model))) {
      indicators.add('Emulator model: ${androidInfo.model}');
    }

    if (androidInfo.isPhysicalDevice == false) {
      indicators.add('Non-physical device detected');
    }

    if (androidInfo.hardware.toLowerCase().contains('goldfish') == true ||
        androidInfo.hardware.toLowerCase().contains('ranchu') == true) {
      indicators.add('Emulator hardware: ${androidInfo.hardware}');
    }

    if (androidInfo.fingerprint.toLowerCase().contains('generic') == true ||
        androidInfo.fingerprint.toLowerCase().contains('emulator') == true) {
      indicators.add('Emulator fingerprint detected');
    }

    return indicators;
  }

  Future<List<String>> _checkIOSSimulator() async {
    final indicators = <String>[];

    final deviceInfo = DeviceInfoPlugin();
    final iosInfo = await deviceInfo.iosInfo;

    if (iosInfo.isPhysicalDevice == false) {
      indicators.add('iOS Simulator detected');
    }

    if (iosInfo.model.toLowerCase().contains('simulator')) {
      indicators.add('Simulator model: ${iosInfo.model}');
    }

    if (iosInfo.identifierForVendor?.toString() == '00000000-0000-0000-0000-000000000000') {
      indicators.add('Simulator identifier detected');
    }

    return indicators;
  }
}
