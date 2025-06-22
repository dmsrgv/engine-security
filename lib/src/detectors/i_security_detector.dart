import 'package:engine_security/src/src.dart';

/// Interface for security detectors
abstract class ISecurityDetector {
  /// Type of threat this detector checks for
  SecurityThreatType get threatType;

  /// Name of the detector
  String get detectorName;

  /// Perform the security check
  Future<SecurityCheckModel> performCheck();

  /// Check if the detector is available on the current platform
  bool get isAvailable;

  /// Get detector configuration or information
  DetectorInfoModel get detectorInfo;
}
