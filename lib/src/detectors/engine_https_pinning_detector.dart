import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:engine_security/engine_security.dart';

class EngineHttpsPinningDetector implements IEngineSecurityDetector {
  EngineHttpsPinningDetector({
    this.enabled = true,
    this.pinnedCertificates = const [],
    this.testConnectivity = true,
    this.strictMode = false,
  });

  final bool enabled;

  final List<EngineCertificatePinModel> pinnedCertificates;

  final bool testConnectivity;

  final bool strictMode;

  @override
  EngineSecurityThreatType get threatType => EngineSecurityThreatType.httpsPinning;

  @override
  String get detectorName => 'HttpsPinningDetector';

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
        details: 'HTTPS pinning detector disabled',
        detectionMethod: 'disabled_check',
        confidence: 1.0,
      );
    }

    try {
      final detectionMethods = <String>[];

      final overridesCheck = _checkHttpOverridesConfiguration();
      if (overridesCheck != null) {
        detectionMethods.add(overridesCheck);
      }

      final configValidation = _validatePinConfigurations();
      if (configValidation.isNotEmpty) {
        detectionMethods.addAll(configValidation);
      }

      if (testConnectivity && pinnedCertificates.isNotEmpty) {
        final connectivityIssues = await _testPinnedHostConnectivity();
        if (connectivityIssues.isNotEmpty) {
          detectionMethods.addAll(connectivityIssues);
        }
      }

      if (strictMode && pinnedCertificates.isEmpty) {
        detectionMethods.add('No certificate pinning configured (strict mode)');
      }

      if (detectionMethods.isNotEmpty) {
        return EngineSecurityCheckModel.threat(
          threatType: EngineSecurityThreatType.httpsPinning,
          details: 'HTTPS pinning issues detected: ${detectionMethods.join(', ')}',
          detectionMethod: 'certificate_pinning_validation',
          confidence: 0.85,
        );
      }

      final configuredSites = pinnedCertificates.map((final pin) => pin.hostname).toList();
      final sitesText = configuredSites.isNotEmpty
          ? 'Sites protegidos: ${configuredSites.join(', ')}'
          : 'HTTPS certificate pinning properly configured and validated';

      return EngineSecurityCheckModel.secure(
        details: sitesText,
        detectionMethod: 'pinning_validation_checks',
        confidence: 0.90,
      );
    } catch (e) {
      return EngineSecurityCheckModel.secure(
        details: 'HTTPS pinning detection failed: $e',
        detectionMethod: 'error_handling',
        confidence: 0.50,
      );
    }
  }

  String? _checkHttpOverridesConfiguration() {
    final currentOverrides = HttpOverrides.current;

    if (currentOverrides == null) {
      return 'No HttpOverrides configured - certificate pinning not active';
    }

    if (currentOverrides is! EngineSecurityHttpOverrides) {
      return 'Custom HttpOverrides detected - may bypass certificate pinning';
    }

    final securityOverrides = currentOverrides;
    if (securityOverrides.pinnedCertificates.isEmpty) {
      return 'Security HttpOverrides configured but no certificates pinned';
    }

    return null;
  }

  List<String> _validatePinConfigurations() {
    final issues = <String>[];

    if (pinnedCertificates.isEmpty) {
      if (!strictMode) {
        return ['No certificate pins configured'];
      }
      return issues;
    }

    for (final pinConfig in pinnedCertificates) {
      if (pinConfig.hostname.isEmpty) {
        issues.add('Empty hostname in pin configuration');
        continue;
      }

      if (RegExp(r'^\d+\.\d+\.\d+\.\d+$').hasMatch(pinConfig.hostname)) {
        issues.add('IP address used instead of hostname: ${pinConfig.hostname}');
      }

      if (!pinConfig.hasValidPins) {
        issues.add('Invalid certificate pins for ${pinConfig.hostname}');
      }
    }

    return issues;
  }

  Future<List<String>> _testPinnedHostConnectivity() async {
    final issues = <String>[];

    for (final pinConfig in pinnedCertificates) {
      try {
        final client = HttpClient()..connectionTimeout = const Duration(seconds: 5);

        final request = await client.getUrl(
          Uri.https(pinConfig.hostname, '/'),
        );
        final response = await request.close();

        if (response.statusCode >= 200 && response.statusCode < 300) {
          continue;
        } else {
          issues.add('HTTP error ${response.statusCode} for pinned host ${pinConfig.hostname}');
        }

        client.close();
      } catch (e) {
        if (e.toString().contains('CERTIFICATE_VERIFY_FAILED') || e.toString().contains('HandshakeException')) {
          issues.add('Certificate validation failed for ${pinConfig.hostname} - verify pins are correct');
        } else {
          issues.add('Network connectivity issue with ${pinConfig.hostname}: ${e.toString().split('\n').first}');
        }
      }
    }

    return issues;
  }

  static Future<EngineCertificatePinModel?> createPinFromCertificateFile(
    final String hostname,
    final String certificatePath, {
    final bool includeSubdomains = false,
    final bool enforcePinning = true,
  }) async {
    try {
      final file = File(certificatePath);
      if (!file.existsSync()) {
        return null;
      }

      final certBytes = await file.readAsBytes();

      final hash = sha256.convert(certBytes);

      final base64Hash = base64Encode(hash.bytes);
      final hexHash = hash.bytes.map((final b) => b.toRadixString(16).padLeft(2, '0')).join();

      return EngineCertificatePinModel(
        hostname: hostname,
        pins: [base64Hash, hexHash],
        includeSubdomains: includeSubdomains,
        enforcePinning: enforcePinning,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<EngineCertificatePinModel?> createPinFromLiveHost(
    final String hostname, {
    final int port = 443,
    final bool includeSubdomains = false,
    final bool enforcePinning = true,
  }) async {
    try {
      final socket = await SecureSocket.connect(
        hostname,
        port,
        onBadCertificate: (final cert) => true,
        timeout: const Duration(seconds: 10),
      );

      final cert = socket.peerCertificate;
      if (cert == null) {
        await socket.close();
        return null;
      }

      final hash = sha256.convert(cert.der);

      final base64Hash = base64Encode(hash.bytes);
      final hexHash = hash.bytes.map((final b) => b.toRadixString(16).padLeft(2, '0')).join();

      await socket.close();

      return EngineCertificatePinModel(
        hostname: hostname,
        pins: [base64Hash, hexHash],
        includeSubdomains: includeSubdomains,
        enforcePinning: enforcePinning,
      );
    } catch (e) {
      return null;
    }
  }

  static EngineCertificatePinModel createPinFromHash(
    final String hostname,
    final String sha256Hash, {
    final bool includeSubdomains = false,
    final bool enforcePinning = true,
  }) => EngineCertificatePinModel(
    hostname: hostname,
    pins: [sha256Hash],
    includeSubdomains: includeSubdomains,
    enforcePinning: enforcePinning,
  );

  static bool isValidCertificatePin(final String pin) {
    final model = EngineCertificatePinModel(
      hostname: 'test.com',
      pins: [pin],
    );
    return model.isValidPinFormat(pin);
  }
}
