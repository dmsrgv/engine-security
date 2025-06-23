# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2024-12-27

### Added
- **HTTPS Certificate Pinning** (`EngineHttpsPinningDetector`) - Sistema avançado de validação de certificados SSL/TLS
  - `EngineCertificatePinModel` para configuração de pins por domínio
  - `EngineSecurityHttpOverrides` para validação transparente de requisições HTTP
  - Suporte a fingerprints SHA-256 em formato base64 e hexadecimal
  - Configuração flexível por hostname com suporte a subdomínios
  - Cache de validação para otimização de performance
  - Modo enforcement (falha na validação) vs. modo reporting (apenas notifica)
  - Callbacks para eventos de validação de certificados
  - Nível de severidade: 8 (crítico)
  - Detecção de bypass attempts e configurações inadequadas

### Enhanced
- Expandido enum `EngineSecurityThreatType` com novo tipo `httpsPinning`
- Criada estrutura `lib/src/network/` para componentes de rede
- Adicionados métodos estáticos para configuração rápida:
  - `EngineHttpsPinningDetector.isHttpOverridesConfigured()`
  - `EngineHttpsPinningDetector.hasValidPinConfiguration()`
  - `EngineHttpsPinningDetector.testConnectivity()`

### Dependencies
- Adicionado `crypto: ^3.0.5` para cálculos de hash SHA-256

### Security Features
- Validação automática de certificados em tempo real
- Proteção contra ataques man-in-the-middle
- Detecção de proxies maliciosos e interceptação de tráfego
- Suporte a múltiplos pins por domínio para rotação de certificados
- Validação de formato de pins com regex otimizado

### Examples
- Exemplo completo de configuração de certificate pinning
- Demo com teste real usando domínio `stmr.tech`
- Documentação expandida com guias de obtenção de fingerprints

### Tests
- 87 novos testes unitários para certificate pinning
- Testes de validação de formato de pins
- Testes de matching de hostnames e subdomínios
- Testes de configuração e enforcement
- 100% de cobertura de código mantida (235 testes totais)

### Breaking Changes
- Renomenação de todas as classes para seguir padrão "Engine":
  - `SecurityThreatType` → `EngineSecurityThreatType`
  - `DetectorInfoModel` → `EngineDetectorInfoModel`
  - `SecurityCheckModel` → `EngineSecurityCheckModel`
  - `ISecurityDetector` → `IEngineSecurityDetector`

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