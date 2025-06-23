# 🛡️ Engine Security

[![CI/CD Pipeline](https://github.com/moreirawebmaster/engine-security/actions/workflows/ci.yml/badge.svg)](https://github.com/moreirawebmaster/engine-security/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/moreirawebmaster/engine-security/branch/main/graph/badge.svg)](https://codecov.io/gh/moreirawebmaster/engine-security)
[![Pub Version](https://img.shields.io/pub/v/engine_security)](https://pub.dev/packages/engine_security)
[![Pana Score](https://img.shields.io/badge/pana-100%2F100-brightgreen)](https://pub.dev/packages/engine_security/score)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-blue)](https://pub.dev/packages/engine_security)

> **Sistema avançado de detecção de segurança para aplicações Flutter focado em Android e iOS**

## 📋 Índice

- [Recursos](#-recursos)
- [Instalação](#-instalação)
- [Uso Rápido](#-uso-rápido)
- [Detectores Disponíveis](#-detectores-disponíveis)
- [HTTPS Certificate Pinning](#-https-certificate-pinning)
- [GPS Fake Detection](#-gps-fake-detection)
- [Modelos de Dados](#-modelos-de-dados)
- [Interface](#-interface)
- [Exemplos](#-exemplos)
- [Desenvolvimento](#-desenvolvimento)
- [Qualidade e Testes](#-qualidade-e-testes)
- [Contribuição](#-contribuição)
- [Licença](#-licença)

## 🚀 Recursos

- ✅ **100% de Cobertura de Testes** - Todos os componentes testados
- 🎯 **Pontuação Pana 100/100** - Qualidade máxima no pub.dev
- 🔄 **CI/CD Automatizado** - Pipeline completo com GitHub Actions
- 📱 **Android & iOS Exclusivo** - Otimizado para dispositivos móveis
- 🛡️ **6 Detectores Especializados** - Frida, Root/Jailbreak, HTTPS Pinning, GPS Fake, Emulator, Debugger
- ⚡ **Detecção Assíncrona** - Performance otimizada
- 🎨 **API Intuitiva** - Fácil integração e uso
- 📊 **Sistema de Confiança** - Níveis de confiança calibrados
- 🔒 **Zero Dependências Externas** - Seguro e leve

## 📦 Instalação

Adicione ao seu `pubspec.yaml`:

```yaml
dependencies:
  engine_security: ^1.2.0
```

Execute:

```bash
flutter pub get
```

## ⚡ Uso Rápido

```dart
import 'package:engine_security/engine_security.dart';

void main() async {
  // Detectar Frida
  final fridaDetector = EngineFridaDetector();
  final fridaResult = await fridaDetector.performCheck();
  
  if (!fridaResult.isSecure) {
    print('⚠️ Frida detectado: ${fridaResult.details}');
    print('🎯 Confiança: ${fridaResult.confidence}');
  }
  
  // Detectar Root/Jailbreak
  final rootDetector = EngineRootDetector();
  final rootResult = await rootDetector.performCheck();
  
  if (!rootResult.isSecure) {
    print('⚠️ Device comprometido: ${rootResult.details}');
  }
  
  // Verificação completa
  await performFullSecurityCheck();
}

Future<void> performFullSecurityCheck() async {
  final detectors = [
    EngineFridaDetector(),
    EngineRootDetector(),
    EngineHttpsPinningDetector(),
    EngineGpsFakeDetector(),
    EngineEmulatorDetector(),
    EngineDebuggerDetector(),
  ];
  
  print('🔍 Executando verificação completa de segurança...\n');
  
  for (final detector in detectors) {
    if (detector.isAvailable) {
      final result = await detector.performCheck();
      final status = result.isSecure ? '✅' : '❌';
      
      print('$status ${detector.detectorName}');
      print('   Confiança: ${(result.confidence * 100).toStringAsFixed(1)}%');
      print('   Detalhes: ${result.details ?? 'N/A'}');
      print('');
    }
  }
}
```

## 🛡️ Detectores Disponíveis

### 1. 🔴 Frida Detector (`EngineFridaDetector`)
- **Ameaça**: `EngineSecurityThreatType.frida`
- **Severidade**: 9/10
- **Confiança**: 95%
- **Métodos**: Detecção de processos, bibliotecas e portas
- **Plataformas**: Android ✅ | iOS ✅

### 2. 🔑 Root/Jailbreak Detector (`EngineRootDetector`)
- **Ameaça**: `EngineSecurityThreatType.rootJailbreak`
- **Severidade**: 8/10
- **Confiança**: 90%
- **Métodos**: Arquivos de sistema, apps instalados, permissões
- **Plataformas**: Android ✅ | iOS ✅

### 3. 🔒 HTTPS Certificate Pinning Detector (`EngineHttpsPinningDetector`)
- **Ameaça**: `EngineSecurityThreatType.httpsPinning`
- **Severidade**: 8/10
- **Confiança**: 95%
- **Métodos**: Validação de certificados SSL/TLS, fingerprints SHA-256
- **Plataformas**: Android ✅ | iOS ✅

### 4. 🗺️ GPS Fake Detector (`EngineGpsFakeDetector`)
- **Ameaça**: `EngineSecurityThreatType.gpsFake`
- **Severidade**: 7/10
- **Confiança**: 90%
- **Métodos**: Mock location, apps falsos, consistência GPS
- **Plataformas**: Android ✅ | iOS ✅

### 5. 📱 Emulator Detector (`EngineEmulatorDetector`)
- **Ameaça**: `EngineSecurityThreatType.emulator`
- **Severidade**: 6/10
- **Confiança**: 85%
- **Métodos**: Hardware, sensores, características do sistema
- **Plataformas**: Android ✅ | iOS ✅

### 6. 🐛 Debugger Detector (`EngineDebuggerDetector`)
- **Ameaça**: `EngineSecurityThreatType.debugger`
- **Severidade**: 2/10
- **Confiança**: 85%
- **Métodos**: Processos de debug, timing attacks
- **Plataformas**: Android ✅ | iOS ✅

## 🔒 HTTPS Certificate Pinning

O Engine Security inclui um sistema robusto de certificate pinning que protege contra ataques man-in-the-middle e interceptação de tráfego.

### Configuração Básica

```dart
import 'package:engine_security/engine_security.dart';
import 'dart:io';

void setupCertificatePinning() {
  // Configurar pins para diferentes domínios
  final pins = [
    EngineCertificatePinModel(
      hostname: 'api.example.com',
      pins: [
        'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=', // SHA-256 em base64
        '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef', // SHA-256 em hex
      ],
      includeSubdomains: true,
      enforcePinning: true,
    ),
    EngineCertificatePinModel(
      hostname: 'stmr.tech',
      pins: [
        '17a8d38a1f559246194bccae62a794ff80d419e849fa78811a4910d7283c1f75', // SHA-256 fingerprint real
      ],
      includeSubdomains: true,
      enforcePinning: true,
    ),
  ];

  // Configurar HttpOverrides global
  final httpOverrides = EngineSecurityHttpOverrides(
    pinnedCertificates: pins,
    onPinningValidation: (hostname, isValid, error) {
      print('Validação de pin para $hostname: ${isValid ? 'OK' : 'FALHA'}');
      if (error != null) print('Erro: $error');
    },
  );

  HttpOverrides.global = httpOverrides;
}
```

### Detector de Certificate Pinning

```dart
Future<void> checkCertificatePinning() async {
  final detector = EngineHttpsPinningDetector(
    enabled: true,
    pinnedCertificates: [
      EngineCertificatePinModel(
        hostname: 'stmr.tech',
        pins: ['17a8d38a1f559246194bccae62a794ff80d419e849fa78811a4910d7283c1f75'],
        includeSubdomains: true,
      ),
    ],
    testConnectivity: false,
    strictMode: false, // true = só valida pins existentes
  );
  
  final result = await detector.performCheck();
  
  if (!result.isSecure) {
    print('Certificate pinning não está configurado!');
    print('Detalhes: ${result.details}');
  } else {
    print('Certificate pinning configurado corretamente!');
    print('Sites protegidos: ${result.details}');
  }
}
```

### Obtendo Fingerprints de Certificados

#### Método 1: Usando Engine Security (Automático)
```dart
// Obter o fingerprint diretamente do servidor ativo
final pinModel = await EngineHttpsPinningDetector.createPinFromLiveHost('stmr.tech');
print('Fingerprints obtidos: ${pinModel?.pins}');
```

#### Método 2: OpenSSL
```bash
echo | openssl s_client -connect stmr.tech:443 2>/dev/null | openssl x509 -fingerprint -sha256 -noout
```

#### Método 3: Chrome DevTools
1. Abra o site no Chrome
2. F12 → Security → View Certificate
3. Copie o SHA-256 fingerprint

#### Método 4: A partir de arquivo
```dart
// Se você tem um arquivo .crt ou .pem
final pinModel = await EngineHttpsPinningDetector.createPinFromCertificateFile(
  'api.example.com',
  '/path/to/certificate.crt',
);
```

#### Método 5: Hash conhecido
```dart
// Se você já tem o hash SHA-256
final pinModel = EngineHttpsPinningDetector.createPinFromHash(
  'stmr.tech',
  '17a8d38a1f559246194bccae62a794ff80d419e849fa78811a4910d7283c1f75',
);
```

## 🗺️ GPS Fake Detection

O `EngineGpsFakeDetector` utiliza múltiplas técnicas para detectar manipulação de GPS:

### Técnicas de Detecção

#### 1. 🔧 Verificação de Mock Location (Android)
- Detecta se as "opções de desenvolvedor" têm mock location habilitado
- Verifica configurações do sistema Android

#### 2. 📱 Detecção de Apps de GPS Fake
- Verifica instalação de mais de 25 apps conhecidos de GPS fake
- Lista atualizada dos principais apps de spoofing de localização

#### 3. 📊 Análise de Confiabilidade da Fonte
- Verifica precisão suspeita do GPS (< 100m pode indicar fake)
- Detecta valores impossíveis (altitude e velocidade zero)

#### 4. 🔄 Verificação de Consistência GPS
- Analisa movimento impossível entre leituras GPS
- Detecta "teletransporte" (distância > 1km em < 10s)

#### 5. 🔐 Análise de Permissões
- Verifica interferência em permissões de localização
- Detecta desabilitação suspeita de serviços de localização

### Exemplo de Uso

```dart
import 'package:engine_security/engine_security.dart';

Future<void> checkGPSFake() async {
  final gpsDetector = EngineGpsFakeDetector();
  
  // Verificação básica
  final result = await gpsDetector.performCheck();
  
  if (!result.isSecure) {
    print('⚠️ GPS Fake detectado!');
    print('📍 Detalhes: ${result.details}');
    print('🔍 Método: ${result.detectionMethod}');
    print('🎯 Confiança: ${(result.confidence * 100).toStringAsFixed(1)}%');
  } else {
    print('✅ GPS é confiável');
  }
}
```

## 📊 Modelos de Dados

### EngineSecurityCheckModel

```dart
class EngineSecurityCheckModel {
  final bool isSecure;
  final EngineSecurityThreatType threatType;
  final double confidence;
  final String? details;
  final String? detectionMethod;
  final DateTime? timestamp;
  
  EngineSecurityCheckModel.secure({...});
  EngineSecurityCheckModel.threat({required EngineSecurityThreatType threatType, ...});
}
```

### EngineDetectorInfoModel

```dart
class EngineDetectorInfoModel {
  final String name;
  final EngineSecurityThreatType threatType;
  final bool enabled;
  final String platform;
}
```

### EngineCertificatePinModel

```dart
class EngineCertificatePinModel {
  final String hostname;
  final List<String> pins; // SHA-256 em base64 ou hexadecimal
  final bool includeSubdomains;
  final bool enforcePinning;
  
  // Métodos de validação
  bool isValidPinFormat(String pin);
  bool matchesHostname(String host);
}
```

### EngineSecurityThreatType

```dart
enum EngineSecurityThreatType {
  unknown,        // Severidade: 5
  frida,          // Severidade: 9
  rootJailbreak,  // Severidade: 8
  httpsPinning,   // Severidade: 8
  gpsFake,        // Severidade: 7
  emulator,       // Severidade: 6
  debugger,       // Severidade: 2
}
```

## 🔧 Interface

### IEngineSecurityDetector

```dart
abstract class IEngineSecurityDetector {
  EngineSecurityThreatType get threatType;
  String get detectorName;
  Future<EngineSecurityCheckModel> performCheck();
  bool get isAvailable;
  EngineDetectorInfoModel get detectorInfo;
}
```

## 📱 Exemplos

Execute o exemplo interativo:

```bash
cd demo/security_demo
flutter run
```

### Implementação Personalizada

```dart
class MySecurityManager {
  final List<IEngineSecurityDetector> _detectors = [
    EngineFridaDetector(),
    EngineRootDetector(),
    EngineHttpsPinningDetector(),
    EngineGpsFakeDetector(),
    EngineEmulatorDetector(),
    EngineDebuggerDetector(),
  ];
  
  Future<List<EngineSecurityCheckModel>> scanAllThreats() async {
    final results = <EngineSecurityCheckModel>[];
    
    for (final detector in _detectors) {
      if (detector.isAvailable) {
        try {
          final result = await detector.performCheck();
          results.add(result);
        } catch (e) {
          results.add(EngineSecurityCheckModel.threat(
            threatType: detector.threatType,
            details: 'Erro na detecção: $e',
            confidence: 0.5,
          ));
        }
      }
    }
    
    return results;
  }
  
  Future<bool> isDeviceSecure({double minimumConfidence = 0.8}) async {
    final results = await scanAllThreats();
    
    for (final result in results) {
      if (!result.isSecure && result.confidence >= minimumConfidence) {
        return false;
      }
    }
    
    return true;
  }
}
```

## 🔧 Desenvolvimento

### Estrutura do Projeto

```
lib/
├── engine_security.dart           # Ponto de entrada principal
└── src/
    ├── src.dart                    # Exportações centralizadas
    ├── detectors/                  # Detectores de segurança
    │   ├── i_engine_security_detector.dart     # Interface base
    │   ├── engine_frida_detector.dart          # Detector Frida
    │   ├── engine_root_detector.dart           # Detector Root/Jailbreak
    │   ├── engine_https_pinning_detector.dart  # Detector HTTPS Pinning
    │   ├── engine_gps_fake_detector.dart       # Detector GPS Fake
    │   ├── engine_emulator_detector.dart       # Detector Emulator
    │   └── engine_debugger_detector.dart       # Detector Debugger
    ├── models/                     # Modelos de dados
    │   ├── engine_security_check_model.dart    # Modelo de resultado
    │   ├── engine_detector_info_model.dart     # Informações do detector
    │   └── engine_certificate_pin_model.dart   # Modelo de certificate pin
    ├── enums/                      # Enumerações
    │   └── engine_security_threat_type.dart    # Tipos de ameaças
    └── network/                    # Componentes de rede
        └── engine_security_http_overrides.dart # HttpOverrides para pinning

test/
├── all_tests.dart                  # Suite completa de testes
├── models/                         # Testes dos modelos
├── enums/                          # Testes dos enums
├── interface/                      # Testes da interface
└── detectors/                      # Testes dos detectores

demo/
└── security_demo/                  # App demonstrativo

scripts/
├── test_coverage.sh               # Script de cobertura
└── pana_analysis.sh              # Script de análise Pana
```

### Scripts de Desenvolvimento

```bash
# Executar testes com cobertura
./scripts/test_coverage.sh

# Análise de qualidade Pana
./scripts/pana_analysis.sh

# Análise estática
dart analyze

# Formatação de código
dart format .

# Publicar (dry-run)
dart pub publish --dry-run
```

### Comandos de Qualidade

```bash
# Executar todos os testes
flutter test

# Testes com cobertura
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Verificar cobertura mínima
dart pub global activate test_coverage
dart pub global run test_coverage --min-coverage=50

# Análise Pana
dart pub global activate pana
dart pub global run pana
```

## 🤝 Contribuição

Contribuições são bem-vindas! Por favor:

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

### Diretrizes de Contribuição

- Mantenha 100% de cobertura de testes
- Siga o padrão de código existente
- Documente novas funcionalidades
- Teste em Android e iOS
- Atualize o CHANGELOG.md

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🏢 Sobre a STMR

Desenvolvido pela [STMR](https://stmr.tech) - Especialistas em soluções móveis.

---

**⚠️ Aviso de Segurança**: Este pacote é uma ferramenta de detecção, não uma solução de segurança completa. Sempre implemente múltiplas camadas de segurança em suas aplicações.

