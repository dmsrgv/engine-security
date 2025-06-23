import 'package:engine_security/engine_security.dart';

class EngineDetectorInfoModel {
  const EngineDetectorInfoModel({
    required this.name,
    required this.threatType,
    required this.enabled,
    required this.platform,
  });

  final String name;

  final EngineSecurityThreatType threatType;

  final bool enabled;

  final String platform;

  @override
  String toString() =>
      'EngineDetectorInfoModel(name: $name, threatType: $threatType, enabled: $enabled, platform: $platform)';
}
