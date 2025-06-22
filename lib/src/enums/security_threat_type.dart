enum SecurityThreatType {
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
  );

  final String displayName;

  final String description;

  final int severityLevel;

  const SecurityThreatType({
    required this.displayName,
    required this.description,
    required this.severityLevel,
  });
}
