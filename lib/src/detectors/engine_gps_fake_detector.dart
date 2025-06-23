// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:io';

import 'package:engine_security/engine_security.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class EngineGpsFakeDetector implements IEngineSecurityDetector {
  EngineGpsFakeDetector({this.enabled = true});

  final bool enabled;

  static const MethodChannel _channel = MethodChannel('engine_security/gps_fake');

  static final List<String> _fakeLocationApps = [
    'com.lexa.fakegps',
    'com.incorporateapps.fakegps.fre',
    'com.blogspot.newapphorizons.fakegps',
    'com.evdokimov.fakelocations',
    'com.technoplatform.fake_gps_go',
    'com.fakegps.app',
    'com.theappninjas.gpsjoystick',
    'ru.gavrikov.mocklocations',
    'appinventor.ai_progressdeveloper.FakeGPS',
    'com.gsmarena.mockgps',
    'com.mozzek.location_spoofer',
    'com.ebryx.gps.spoofer',
    'com.paget96.spoofgps',
    'com.droidtrail.mockgps',
    'com.appguru.location_spoofer',
    'com.excellentapps.mocklocation',
    'com.gps.hack.joystick',
    'com.incorporateapps.fakegps',
    'com.theappninjas.gpsemulator',
    'com.hola.fake.location',
    'com.vito.gps',
    'com.xss.gps.location',
    'com.gps.joystick.fake.location',
    'com.gps.hack.app',
    'com.android.fake.location',
  ];

  @override
  EngineSecurityThreatType get threatType => EngineSecurityThreatType.gpsFake;

  @override
  String get detectorName => 'GpsFakeDetector';

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
        details: 'GPS fake detector disabled',
        detectionMethod: 'disabled_check',
        confidence: 1.0,
      );
    }

    try {
      final detectionMethods = <String>[
        if (Platform.isAndroid) ...await _checkAndroidGpsFake(),
        if (Platform.isIOS) ...await _checkIOSGpsFake(),
      ];

      if (detectionMethods.isNotEmpty) {
        return EngineSecurityCheckModel.threat(
          threatType: EngineSecurityThreatType.gpsFake,
          details: 'GPS fake detected: ${detectionMethods.join(', ')}',
          detectionMethod: 'platform_specific_checks',
          confidence: 0.90,
        );
      }

      return EngineSecurityCheckModel.secure(
        details: 'No GPS manipulation detected',
        detectionMethod: 'platform_checks',
        confidence: 0.85,
      );
    } catch (e) {
      return EngineSecurityCheckModel.secure(
        details: 'GPS fake detection failed: $e',
        detectionMethod: 'error_handling',
        confidence: 0.50,
      );
    }
  }

  Future<List<String>> _checkAndroidGpsFake() async {
    final indicators = <String>[];

    final futures = <Future<void>>[
      () async {
        try {
          final mockLocationEnabled = await _channel.invokeMethod<bool>('checkMockLocationEnabled');
          if (mockLocationEnabled == true) {
            indicators.add('Mock location enabled in developer options');
          }
        } catch (e) {}
      }(),

      () async {
        try {
          final installedApps = await _channel.invokeMethod<List<dynamic>>('getInstalledApps');
          if (installedApps != null) {
            final fakeAppsFound = installedApps
                .where((final app) => _fakeLocationApps.contains(app.toString()))
                .toList();
            if (fakeAppsFound.isNotEmpty) {
              indicators.add('Fake GPS apps detected: ${fakeAppsFound.length} apps');
            }
          }
        } catch (e) {}
      }(),

      () async {
        try {
          final status = await Permission.location.status;
          if (status.isDenied || status.isPermanentlyDenied) {
            indicators.add('Location permission denied');
          }
        } catch (e) {}
      }(),
    ];

    await Future.wait(futures);

    if (indicators.isNotEmpty) {
      return indicators;
    }

    if (await Geolocator.isLocationServiceEnabled()) {
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
            timeLimit: Duration(milliseconds: 800),
          ),
        ).timeout(const Duration(milliseconds: 1500));

        if (position.latitude == 0.0 && position.longitude == 0.0) {
          indicators.add('GPS returning zero coordinates');
        }

        if (position.accuracy > 1000) {
          indicators.add('GPS accuracy extremely poor');
        }
      } catch (e) {
        if (e.toString().contains('timeout')) {
          indicators.add('GPS timeout - possible interference');
        }
      }
    }

    return indicators;
  }

  Future<List<String>> _checkIOSGpsFake() async {
    final indicators = <String>[];

    final futures = <Future<void>>[
      () async {
        try {
          final isJailbroken = await _channel.invokeMethod<bool>('checkJailbreakStatus');
          if (isJailbroken == true) {
            indicators.add('Device is jailbroken - GPS spoofing possible');
          }
        } catch (e) {}
      }(),

      () async {
        try {
          final fakeApps = await _channel.invokeMethod<List<dynamic>>('getInstalledApps');
          if (fakeApps != null && fakeApps.isNotEmpty) {
            indicators.add('Fake GPS apps detected: ${fakeApps.length} apps');
          }
        } catch (e) {}
      }(),

      () async {
        try {
          final reliability = await _channel.invokeMethod<Map<dynamic, dynamic>>('checkLocationServicesReliability');
          if (reliability != null) {
            final isReliable = reliability['isReliable']?.toBool() ?? true;
            final suspiciousCount = reliability['suspiciousCount']?.toInt() ?? 0;

            if (!isReliable) {
              indicators.add('Location services unreliable');
            }

            if (suspiciousCount > 0) {
              indicators.add('Core Location services compromised: $suspiciousCount issues');
            }

            final authStatus = reliability['authorizationStatus']?.toString();
            if (authStatus == 'restricted' || authStatus == 'denied') {
              indicators.add('Location authorization issues: $authStatus');
            }
          }
        } catch (e) {}
      }(),

      () async {
        try {
          final status = await Permission.location.status;
          if (status.isDenied || status.isPermanentlyDenied) {
            indicators.add('Location permission denied');
          }
        } catch (e) {}
      }(),
    ];

    await Future.wait(futures);

    if (indicators.isNotEmpty) {
      return indicators;
    }

    if (await Geolocator.isLocationServiceEnabled()) {
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
            timeLimit: Duration(milliseconds: 800),
          ),
        ).timeout(const Duration(milliseconds: 1500));

        if (position.latitude == 0.0 && position.longitude == 0.0) {
          indicators.add('GPS returning zero coordinates');
        }

        if (position.accuracy > 1000) {
          indicators.add('GPS accuracy extremely poor');
        }

        if (position.accuracy < 0.5 && position.altitude == 0.0) {
          indicators.add('GPS data artificially perfect');
        }
      } catch (e) {
        if (e.toString().contains('timeout')) {
          indicators.add('GPS timeout - possible interference');
        }
      }
    }

    return indicators;
  }

  static Future<bool> checkMockLocationEnabled() async {
    try {
      final result = await _channel.invokeMethod<bool>('checkMockLocationEnabled');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<List<String>> getInstalledFakeGpsApps() async {
    try {
      final installedApps = await _channel.invokeMethod<List<dynamic>>('getInstalledApps');
      if (installedApps != null) {
        return installedApps
            .where((final app) => _fakeLocationApps.contains(app.toString()))
            .map((final app) => app.toString())
            .toList();
      }
    } catch (e) {
      return [];
    }
    return [];
  }
}
