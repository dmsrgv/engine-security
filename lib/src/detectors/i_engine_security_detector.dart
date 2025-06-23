import 'package:engine_security/engine_security.dart';

/// Interface for security detectors
abstract class IEngineSecurityDetector {
  /// Type of threat this detector checks for
  EngineSecurityThreatType get threatType;

  /// Name of the detector
  String get detectorName;

  /// Perform the security check
  Future<EngineSecurityCheckModel> performCheck();

  /// Check if the detector is available on the current platform
  bool get isAvailable;

  /// Get detector configuration or information
  EngineDetectorInfoModel get detectorInfo;
}
