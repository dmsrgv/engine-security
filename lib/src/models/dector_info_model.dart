import 'package:engine_security/src/src.dart';

class DetectorInfoModel {
  const DetectorInfoModel({
    required this.name,
    required this.threatType,
    required this.enabled,
    required this.platform,
  });

  final String name;

  final SecurityThreatType threatType;

  final bool enabled;

  final String platform;

  @override
  String toString() =>
      'DetectorInfoModel(name: $name, threatType: $threatType, enabled: $enabled, platform: $platform)';
}
