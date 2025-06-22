import 'package:engine_security/engine_security.dart';

class DetectorTestResult {
  final String detectorName;
  final EngineSecurityCheckModel result;
  final DateTime timestamp;
  final Duration executionTime;
  final bool isRunning;

  const DetectorTestResult({
    required this.detectorName,
    required this.result,
    required this.timestamp,
    required this.executionTime,
    this.isRunning = false,
  });

  DetectorTestResult copyWith({
    String? detectorName,
    EngineSecurityCheckModel? result,
    DateTime? timestamp,
    Duration? executionTime,
    bool? isRunning,
  }) {
    return DetectorTestResult(
      detectorName: detectorName ?? this.detectorName,
      result: result ?? this.result,
      timestamp: timestamp ?? this.timestamp,
      executionTime: executionTime ?? this.executionTime,
      isRunning: isRunning ?? this.isRunning,
    );
  }

  String get confidencePercentage => '${(result.confidence * 100).toInt()}%';

  String get confidenceDescription {
    if (result.confidence >= 0.95) return 'Extremamente confiável';
    if (result.confidence >= 0.85) return 'Muito confiável';
    if (result.confidence >= 0.70) return 'Confiável';
    if (result.confidence >= 0.50) return 'Incerto';
    return 'Não confiável';
  }

  String get statusDescription {
    if (isRunning) return 'Executando...';
    return result.isSecure ? 'Seguro' : 'Ameaça Detectada';
  }
}
