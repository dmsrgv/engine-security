import 'package:flutter_test/flutter_test.dart';

import 'detectors/engine_debugger_detector_test.dart' as engine_debugger_detector_test;
import 'detectors/engine_detectors_integration_test.dart' as engine_detectors_integration_test;
import 'detectors/engine_emulator_detector_test.dart' as engine_emulator_detector_test;
import 'detectors/engine_frida_detector_test.dart' as engine_frida_detector_test;
import 'detectors/engine_root_detector_test.dart' as engine_root_detector_test;
import 'edge_cases/security_edge_cases_test.dart' as security_edge_cases_test;
import 'enums/security_threat_type_test.dart' as security_threat_type_test;
import 'interface/i_security_detector_test.dart' as i_security_detector_test;
import 'models/detector_info_model_test.dart' as detector_info_model_test;
import 'models/security_check_model_test.dart' as security_check_model_test;

void main() {
  group('Engine Security - All Tests', () {
    group('Models', () {
      security_check_model_test.main();
      detector_info_model_test.main();
    });

    group('Enums', () {
      security_threat_type_test.main();
    });

    group('Interfaces', () {
      i_security_detector_test.main();
    });

    group('Detectors', () {
      engine_debugger_detector_test.main();
      engine_emulator_detector_test.main();
      engine_frida_detector_test.main();
      engine_root_detector_test.main();
      engine_detectors_integration_test.main();
    });

    group('Edge Cases', () {
      security_edge_cases_test.main();
    });
  });
}
