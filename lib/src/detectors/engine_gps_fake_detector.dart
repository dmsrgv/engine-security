// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:io';

import 'package:engine_security/src/src.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class EngineGpsFakeDetector implements ISecurityDetector {
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
  SecurityThreatType get threatType => SecurityThreatType.gpsFake;

  @override
  String get detectorName => 'GpsFakeDetector';

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
        return SecurityCheckModel.threat(
          threatType: SecurityThreatType.gpsFake,
          details: 'GPS fake detected: ${detectionMethods.join(', ')}',
          detectionMethod: 'platform_specific_checks',
          confidence: 0.90,
        );
      }

      return SecurityCheckModel.secure(
        details: 'No GPS manipulation detected',
        detectionMethod: 'platform_checks',
        confidence: 0.85,
      );
    } catch (e) {
      return SecurityCheckModel.secure(
        details: 'GPS fake detection failed: $e',
        detectionMethod: 'error_handling',
        confidence: 0.50,
      );
    }
  }

  Future<List<String>> _checkAndroidGpsFake() async {
    final indicators = <String>[];

    try {
      final mockLocationEnabled = await _channel.invokeMethod<bool>('checkMockLocationEnabled');
      if (mockLocationEnabled == true) {
        indicators.add('Mock location enabled in developer options');
      }
    } catch (e) {}

    try {
      final installedApps = await _channel.invokeMethod<List<dynamic>>('getInstalledApps');
      if (installedApps != null) {
        final fakeAppsFound = installedApps.where((final app) => _fakeLocationApps.contains(app.toString())).toList();

        if (fakeAppsFound.isNotEmpty) {
          indicators.add('Fake GPS apps detected: ${fakeAppsFound.length} apps');
        }
      }
    } catch (e) {}

    if (await Geolocator.isLocationServiceEnabled()) {
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 10),
          ),
        ).timeout(const Duration(seconds: 15));

        if (position.accuracy > 100) {
          indicators.add('Suspicious GPS accuracy: ${position.accuracy.toInt()}m');
        }

        if (position.altitude == 0.0 && position.speed == 0.0) {
          indicators.add('Suspicious GPS values: zero altitude and speed');
        }
      } catch (e) {}

      try {
        final positions = <Position>[];

        for (var i = 0; i < 3; i++) {
          try {
            final position = await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.high,
                timeLimit: Duration(seconds: 5),
              ),
            ).timeout(const Duration(seconds: 8));
            positions.add(position);

            if (i < 2) {
              await Future.delayed(const Duration(seconds: 2));
            }
          } catch (e) {
            break;
          }
        }

        if (positions.length >= 2) {
          for (var i = 1; i < positions.length; i++) {
            final distance = Geolocator.distanceBetween(
              positions[i - 1].latitude,
              positions[i - 1].longitude,
              positions[i].latitude,
              positions[i].longitude,
            );

            final timeDiff = positions[i].timestamp.difference(positions[i - 1].timestamp);

            if (distance > 1000 && timeDiff.inSeconds < 10) {
              indicators.add('Impossible GPS movement: ${distance.toInt()}m in ${timeDiff.inSeconds}s');
              break;
            }
          }
        }
      } catch (e) {}
    }

    try {
      final status = await Permission.location.status;
      if (status.isDenied || status.isPermanentlyDenied) {
        indicators.add('Location permission denied');
      }

      final locationService = loc.Location();
      final serviceEnabled = await locationService.serviceEnabled();
      if (!serviceEnabled) {
        indicators.add('Location service disabled');
      }
    } catch (e) {}

    return indicators;
  }

  Future<List<String>> _checkIOSGpsFake() async {
    final indicators = <String>[];

    // Verificar jailbreak (que facilita GPS spoofing)
    try {
      final isJailbroken = await _channel.invokeMethod<bool>('checkJailbreakStatus');
      if (isJailbroken == true) {
        indicators.add('Device is jailbroken - GPS spoofing possible');
      }
    } catch (e) {}

    // Verificar apps de GPS fake específicos do iOS
    try {
      final fakeApps = await _channel.invokeMethod<List<dynamic>>('getInstalledApps');
      if (fakeApps != null && fakeApps.isNotEmpty) {
        indicators.add('Fake GPS apps detected: ${fakeApps.length} apps');
      }
    } catch (e) {}

    // Verificar confiabilidade dos serviços de localização nativos
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

    // Verificar GPS usando geolocator (garantindo uso do Core Location Framework)
    if (await Geolocator.isLocationServiceEnabled()) {
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 10),
          ),
        ).timeout(const Duration(seconds: 15));

        // No iOS, accuracy muito baixa pode indicar spoofing
        if (position.accuracy > 100) {
          indicators.add('Suspicious GPS accuracy: ${position.accuracy.toInt()}m');
        }

        // Verificar valores impossíveis (comum em apps de spoofing)
        if (position.altitude == 0.0 && position.speed == 0.0) {
          indicators.add('Suspicious GPS values detected');
        }

        // Verificar se os dados de localização são muito "perfeitos" (indicativo de fake)
        if (position.accuracy < 5.0 && position.altitude.abs() < 1.0) {
          indicators.add('GPS data too precise - possible spoofing');
        }
      } catch (e) {
        indicators.add('GPS reading failed - possible interference');
      }

      // Verificação de consistência temporal (detectar teletransporte)
      try {
        final positions = <Position>[];

        for (var i = 0; i < 3; i++) {
          try {
            final position = await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.high,
                timeLimit: Duration(seconds: 5),
              ),
            ).timeout(const Duration(seconds: 8));
            positions.add(position);

            if (i < 2) {
              await Future.delayed(const Duration(seconds: 2));
            }
          } catch (e) {
            break;
          }
        }

        if (positions.length >= 2) {
          for (var i = 1; i < positions.length; i++) {
            final distance = Geolocator.distanceBetween(
              positions[i - 1].latitude,
              positions[i - 1].longitude,
              positions[i].latitude,
              positions[i].longitude,
            );

            final timeDiff = positions[i].timestamp.difference(positions[i - 1].timestamp);

            // No iOS, movimentos impossíveis são mais raros devido às restrições
            if (distance > 500 && timeDiff.inSeconds < 5) {
              indicators.add('Impossible GPS movement detected: ${distance.toInt()}m in ${timeDiff.inSeconds}s');
              break;
            }
          }
        }
      } catch (e) {}
    }

    // Verificar permissões (usando Core Location via permission_handler)
    try {
      final status = await Permission.location.status;
      if (status.isDenied || status.isPermanentlyDenied) {
        indicators.add('Location permission denied');
      }
    } catch (e) {}

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
