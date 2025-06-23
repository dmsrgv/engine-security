import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:engine_security/engine_security.dart';

class EngineSecurityHttpOverrides extends HttpOverrides {
  EngineSecurityHttpOverrides({
    required this.pinnedCertificates,
    this.allowBadCertificates = false,
    this.onPinningValidation,
  });

  final List<EngineCertificatePinModel> pinnedCertificates;

  final bool allowBadCertificates;

  final Function(String hostname, bool isValid, String? error)? onPinningValidation;

  static final Map<String, bool> _validationCache = {};

  @override
  HttpClient createHttpClient(final SecurityContext? context) => super.createHttpClient(context)
    ..connectionTimeout = const Duration(seconds: 30)
    ..badCertificateCallback = (final cert, final host, final port) => _validateCertificatePinning(cert, host);

  bool _validateCertificatePinning(final X509Certificate certificate, final String hostname) {
    try {
      final pinConfig = _findPinConfigForHost(hostname);

      if (pinConfig == null) {
        _notifyValidation(hostname, true, 'No pinning configured');
        return true;
      }

      final cacheKey = '${hostname}_${certificate.sha1}';
      if (_validationCache.containsKey(cacheKey)) {
        final isValid = _validationCache[cacheKey]!;
        _notifyValidation(hostname, isValid, isValid ? 'Cache hit - valid' : 'Cache hit - invalid');
        return isValid;
      }

      final publicKeyHashes = _calculatePublicKeyHashes(certificate);

      if (publicKeyHashes == null) {
        _validationCache[cacheKey] = false;
        _notifyValidation(hostname, false, 'Failed to calculate public key hash');
        return pinConfig.enforcePinning;
      }

      var isValid = false;
      for (final pinnedHash in pinConfig.pins) {
        if (publicKeyHashes.base64 == pinnedHash || publicKeyHashes.hex == pinnedHash) {
          isValid = true;
          break;
        }
      }

      _validationCache[cacheKey] = isValid;

      if (isValid) {
        _notifyValidation(hostname, true, 'Certificate pin validation successful');
        return true;
      } else {
        _notifyValidation(hostname, false, 'Certificate pin mismatch');
        return pinConfig.enforcePinning;
      }
    } catch (e) {
      _notifyValidation(hostname, false, 'Validation error: $e');
      return allowBadCertificates;
    }
  }

  EngineCertificatePinModel? _findPinConfigForHost(final String hostname) {
    for (final pinConfig in pinnedCertificates) {
      if (pinConfig.matchesHostname(hostname)) {
        return pinConfig;
      }
    }
    return null;
  }

  EngineCertificateHashesModel? _calculatePublicKeyHashes(final X509Certificate certificate) {
    try {
      final certBytes = certificate.der;

      final hash = sha256.convert(certBytes);
      final base64Hash = base64Encode(hash.bytes);
      final hexHash = hash.bytes.map((final b) => b.toRadixString(16).padLeft(2, '0')).join();

      return EngineCertificateHashesModel(
        base64: base64Hash,
        hex: hexHash,
      );
    } catch (e) {
      return null;
    }
  }

  void _notifyValidation(final String hostname, final bool isValid, final String? message) {
    onPinningValidation?.call(hostname, isValid, message);
  }

  static void clearCache() {
    _validationCache.clear();
  }

  void addPinConfiguration(final EngineCertificatePinModel pinConfig) {
    pinnedCertificates.add(pinConfig);
    clearCache();
  }

  void removePinConfiguration(final String hostname) {
    pinnedCertificates.removeWhere((final config) => config.hostname == hostname);
    clearCache();
  }

  EngineCertificatePinModel? getPinConfiguration(final String hostname) => _findPinConfigForHost(hostname);
}
