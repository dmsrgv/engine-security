import 'package:engine_security/src/src.dart';

class SecurityCheckModel {
  const SecurityCheckModel({
    required this.isSecure,
    required this.threatType,
    this.details,
    this.detectionMethod,
    this.confidence = 1.0,
    this.timestamp,
  });

  factory SecurityCheckModel.secure({
    final String? details,
    final String? detectionMethod,
    final double confidence = 1.0,
  }) => SecurityCheckModel(
    isSecure: true,
    threatType: SecurityThreatType.unknown,
    details: details,
    detectionMethod: detectionMethod,
    confidence: confidence,
    timestamp: DateTime.now(),
  );

  factory SecurityCheckModel.threat({
    required final SecurityThreatType threatType,
    final String? details,
    final String? detectionMethod,
    final double confidence = 1.0,
  }) => SecurityCheckModel(
    isSecure: false,
    threatType: threatType,
    details: details,
    detectionMethod: detectionMethod,
    confidence: confidence,
    timestamp: DateTime.now(),
  );

  @override
  String toString() =>
      'SecurityCheckModel('
      'isSecure: $isSecure, '
      'threatType: $threatType, '
      'details: $details, '
      'detectionMethod: $detectionMethod, '
      'confidence: $confidence, '
      'timestamp: $timestamp'
      ')';

  final bool isSecure;
  final SecurityThreatType threatType;
  final double confidence;
  final String? details;
  final String? detectionMethod;
  final DateTime? timestamp;
}
