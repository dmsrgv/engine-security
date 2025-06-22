# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2024-12-27

### Added
- **GPS Fake Detector** (`EngineGpsFakeDetector`) - Detecta aplicativos de GPS falso e manipulação de localização
  - Verifica configurações de mock location no Android
  - Detecta mais de 25 apps conhecidos de GPS fake instalados
  - Analisa confiabilidade da fonte de GPS (precisão suspeita, valores impossíveis)
  - Verifica consistência do GPS ao longo do tempo (detecta "teletransporte")
  - Monitora permissões de localização e serviços GPS
  - Nível de severidade: 7 (alto)
  - Confiança de detecção: 90%
  - Suporte para Android e iOS

### Dependencies
- Adicionado `geolocator: ^13.0.1` para análise de localização GPS
- Adicionado `location: ^7.0.0` para serviços de localização
- Adicionado `permission_handler: ^11.3.1` para verificação de permissões

### Enhanced
- Expandido enum `SecurityThreatType` com novo tipo `gpsFake`
- Implementado código nativo Android para detecção de mock location
- Adicionados métodos estáticos para verificações específicas:
  - `EngineGpsFakeDetector.checkMockLocationEnabled()`
  - `EngineGpsFakeDetector.getInstalledFakeGpsApps()`

### Examples
- Novo exemplo de app demonstrando detecção de GPS Fake
- Interface completa mostrando resultados detalhados da detecção
- Documentação expandida no README com exemplos de uso

### Tests
- 100% de cobertura de testes mantida
- Novos testes unitários para o detector de GPS Fake
- Testes de integração para verificar funcionamento completo

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