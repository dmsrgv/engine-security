# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-19

### Added
- Initial release of Engine Security package
- `SecurityCheckModel` for representing security check results
- `DetectorInfoModel` for detector metadata
- `SecurityThreatType` enum with support for:
  - Unknown threats
  - Frida framework detection
  - Emulator/Simulator detection
  - Root/Jailbreak detection
  - Debugger detection
- `ISecurityDetector` interface for implementing custom detectors
- Four built-in security detectors:
  - `EngineDebuggerDetector` - Detects debugging tools and processes
  - `EngineEmulatorDetector` - Detects Android emulators and iOS simulators
  - `EngineFridaDetector` - Detects Frida dynamic instrumentation framework
  - `EngineRootDetector` - Detects rooted Android devices and jailbroken iOS devices
- Comprehensive test suite with 100+ unit tests
- Support for Android and iOS platforms
- Configurable detection methods with confidence scoring
- Async security checking with detailed results

### Security Features
- Multi-vector threat detection
- Platform-specific detection algorithms
- Process and file system monitoring
- Network port scanning for security tools
- Hardware fingerprinting for emulator detection
- Root/jailbreak file and binary detection

### Documentation
- Complete API documentation
- Usage examples and best practices
- Integration guides for Flutter applications 