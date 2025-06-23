import 'package:engine_security/engine_security.dart';

class EngineSecurityCheckModel {
  const EngineSecurityCheckModel({
    required this.isSecure,
    required this.threatType,
    this.details,
    this.detectionMethod,
    this.confidence = 1.0,
    this.timestamp,
  });

  factory EngineSecurityCheckModel.secure({
    final String? details,
    final String? detectionMethod,
    final double confidence = 1.0,
  }) => EngineSecurityCheckModel(
    isSecure: true,
    threatType: EngineSecurityThreatType.unknown,
    details: details,
    detectionMethod: detectionMethod,
    confidence: confidence,
    timestamp: DateTime.now(),
  );

  factory EngineSecurityCheckModel.threat({
    required final EngineSecurityThreatType threatType,
    final String? details,
    final String? detectionMethod,
    final double confidence = 1.0,
  }) => EngineSecurityCheckModel(
    isSecure: false,
    threatType: threatType,
    details: details,
    detectionMethod: detectionMethod,
    confidence: confidence,
    timestamp: DateTime.now(),
  );

  @override
  String toString() =>
      'EngineSecurityCheckModel('
      'isSecure: $isSecure, '
      'threatType: $threatType, '
      'details: $details, '
      'detectionMethod: $detectionMethod, '
      'confidence: $confidence, '
      'timestamp: $timestamp'
      ')';

  final bool isSecure;
  final EngineSecurityThreatType threatType;
  final double confidence;
  final String? details;
  final String? detectionMethod;
  final DateTime? timestamp;
}
