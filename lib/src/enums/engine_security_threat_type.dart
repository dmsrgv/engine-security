enum EngineSecurityThreatType {
  unknown(
    displayName: 'Unknown Threat',
    description: 'Unknown security threat detected',
    severityLevel: 5,
  ),
  frida(
    displayName: 'Frida Detection',
    description: 'Frida framework detected',
    severityLevel: 9,
  ),

  emulator(
    displayName: 'Emulator Detection',
    description: 'Application running on emulator or simulator',
    severityLevel: 6,
  ),

  rootJailbreak(
    displayName: 'Root/Jailbreak Detection',
    description: 'Device has been rooted (Android) or jailbroken (iOS)',
    severityLevel: 8,
  ),

  debugger(
    displayName: 'Debugger Detection',
    description: 'Debugger attachment detected',
    severityLevel: 2,
  ),

  gpsFake(
    displayName: 'GPS Fake Detection',
    description: 'GPS location spoofing or fake GPS app detected',
    severityLevel: 7,
  ),

  httpsPinning(
    displayName: 'HTTPS Certificate Pinning',
    description: 'HTTPS certificate pinning validation failed or bypassed',
    severityLevel: 8,
  );

  final String displayName;

  final String description;

  final int severityLevel;

  const EngineSecurityThreatType({
    required this.displayName,
    required this.description,
    required this.severityLevel,
  });
}
