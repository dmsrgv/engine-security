import 'package:flutter_test/flutter_test.dart';

import 'detectors/engine_debugger_detector_test.dart' as engine_debugger_detector_test;
import 'detectors/engine_detectors_integration_test.dart' as engine_detectors_integration_test;
import 'detectors/engine_emulator_detector_test.dart' as engine_emulator_detector_test;
import 'detectors/engine_frida_detector_test.dart' as engine_frida_detector_test;
import 'detectors/engine_gps_fake_detector_test.dart' as engine_gps_fake_detector_test;
import 'detectors/engine_root_detector_test.dart' as engine_root_detector_test;
import 'edge_cases/security_edge_cases_test.dart' as security_edge_cases_test;
import 'enums/engine_security_threat_type_test.dart' as engine_security_threat_type_test;
import 'interface/i_engine_security_detector_test.dart' as i_engine_security_detector_test;
import 'models/engine_detector_info_model_test.dart' as engine_detector_info_model_test;
import 'models/engine_security_check_model_test.dart' as engine_security_check_model_test;

void main() {
  group('Engine Security - All Tests', () {
    group('Models', () {
      engine_security_check_model_test.main();
      engine_detector_info_model_test.main();
    });

    group('Enums', () {
      engine_security_threat_type_test.main();
    });

    group('Interfaces', () {
      i_engine_security_detector_test.main();
    });

    group('Detectors', () {
      engine_debugger_detector_test.main();
      engine_emulator_detector_test.main();
      engine_frida_detector_test.main();
      engine_gps_fake_detector_test.main();
      engine_root_detector_test.main();
      engine_detectors_integration_test.main();
    });

    group('Edge Cases', () {
      security_edge_cases_test.main();
    });
  });
}
