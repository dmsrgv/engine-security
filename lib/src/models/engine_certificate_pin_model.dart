class EngineCertificatePinModel {
  const EngineCertificatePinModel({
    required this.hostname,
    required this.pins,
    this.includeSubdomains = false,
    this.enforcePinning = true,
  });

  final String hostname;

  final List<String> pins;

  final bool includeSubdomains;

  final bool enforcePinning;

  bool isValidPinFormat(final String pin) {
    final base64Pattern = RegExp(r'^[A-Za-z0-9+/]{42,44}={0,2}$');

    final hexPattern = RegExp(r'^[A-Fa-f0-9]{64}$');

    return base64Pattern.hasMatch(pin) || hexPattern.hasMatch(pin);
  }

  bool get hasValidPins {
    if (pins.isEmpty) {
      return false;
    }
    return pins.every((final pin) => isValidPinFormat(pin));
  }

  bool matchesHostname(final String host) {
    if (host == hostname) {
      return true;
    }

    if (includeSubdomains) {
      return host.endsWith('.$hostname');
    }

    return false;
  }

  @override
  String toString() =>
      'EngineCertificatePinModel('
      'hostname: $hostname, '
      'pins: ${pins.length} pins, '
      'includeSubdomains: $includeSubdomains, '
      'enforcePinning: $enforcePinning)';
}
