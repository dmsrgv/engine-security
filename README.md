# 🛡️ Engine Security

[![CI/CD Pipeline](https://github.com/moreirawbmaster/engine-security/actions/workflows/ci.yml/badge.svg)](https://github.com/moreirawbmaster/engine-security/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/moreirawbmaster/engine-security/branch/main/graph/badge.svg)](https://codecov.io/gh/moreirawbmaster/engine-security)
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
- **Ameaça**: `SecurityThreatType.frida`
- **Confiança**: 95%
- **Métodos**: Detecção de processos, bibliotecas e portas
- **Plataformas**: Android, iOS

### 2. 🔑 Root/Jailbreak Detector (`EngineRootDetector`)
- **Ameaça**: `EngineSecurityThreatType.rootJailbreak`
- **Confiança**: 90%
- **Métodos**: Arquivos de sistema, apps instalados, permissões
- **Plataformas**: Android, iOS

### 3. 🔒 HTTPS Certificate Pinning Detector (`EngineHttpsPinningDetector`)
- **Ameaça**: `EngineSecurityThreatType.httpsPinning`
- **Confiança**: 95%
- **Métodos**: Validação de certificados SSL/TLS, fingerprints SHA-256
- **Plataformas**: Android, iOS
- **Formatos**: Base64 e Hexadecimal

### 4. 🗺️ GPS Fake Detector (`EngineGpsFakeDetector`)
- **Ameaça**: `EngineSecurityThreatType.gpsFake`
- **Confiança**: 90%
- **Métodos**: Mock location, apps falsos, consistência GPS, análise de localização
- **Plataformas**: Android, iOS

### 5. 📱 Emulator Detector (`EngineEmulatorDetector`)
- **Ameaça**: `EngineSecurityThreatType.emulator`
- **Confiança**: 85%
- **Métodos**: Hardware, sensores, características do sistema
- **Plataformas**: Android, iOS

### 6. 🐛 Debugger Detector (`EngineDebuggerDetector`)
- **Ameaça**: `EngineSecurityThreatType.debugger`
- **Confiança**: 85%
- **Métodos**: Processos de debug, timing attacks
- **Plataformas**: Android, iOS

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
  final detector = EngineHttpsPinningDetector();
  final result = await detector.performCheck();
  
  if (!result.isSecure) {
    print('Certificate pinning não está configurado!');
    print('Severidade: ${result.threatType.severityLevel}');
  }
}
```

### Exemplo Completo com stmr.tech

```dart
import 'package:flutter/material.dart';
import 'package:engine_security/engine_security.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class CertificatePinningDemo extends StatefulWidget {
  @override
  _CertificatePinningDemoState createState() => _CertificatePinningDemoState();
}

class _CertificatePinningDemoState extends State<CertificatePinningDemo> {
  String _validationStatus = 'Não testado';
  String _detectorStatus = 'Não verificado';

  @override
  void initState() {
    super.initState();
    _setupCertificatePinning();
  }

  void _setupCertificatePinning() {
    final pins = [
      EngineCertificatePinModel(
        hostname: 'stmr.tech',
        pins: ['17a8d38a1f559246194bccae62a794ff80d419e849fa78811a4910d7283c1f75'], // SHA-256 fingerprint real
        enforcePinning: true,
        includeSubdomains: true,
      ),
    ];

    HttpOverrides.global = EngineSecurityHttpOverrides(
      pinnedCertificates: pins,
      onPinningValidation: (hostname, isValid, error) {
        setState(() {
          _validationStatus = '$hostname: ${isValid ? 'VÁLIDO' : 'INVÁLIDO'}';
          if (error != null) _validationStatus += ' - $error';
        });
      },
    );
  }

  Future<void> _testHttpsConnection() async {
    try {
      final response = await http.get(Uri.parse('https://stmr.tech'));
      print('Conexão HTTPS bem-sucedida: ${response.statusCode}');
    } catch (e) {
      print('Erro na conexão HTTPS: $e');
    }
  }

  Future<void> _runPinningDetector() async {
    final detector = EngineHttpsPinningDetector();
    final result = await detector.performCheck();
    
    setState(() {
      _detectorStatus = result.isSecure ? 
        'CONFIGURADO - Certificate pinning ativo' : 
        'NÃO CONFIGURADO - ${result.details}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Certificate Pinning Demo')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status do Detector:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(_detectorStatus),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status da Validação:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(_validationStatus),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _runPinningDetector,
              child: Text('Verificar Certificate Pinning'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _testHttpsConnection,
              child: Text('Testar Conexão HTTPS com stmr.tech'),
            ),
          ],
        ),
      ),
    );
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
  Future<EngineSecurityCheckModel> detect();
  bool get isAvailable;
  EngineDetectorInfoModel get detectorInfo;
}
```

## 🛠️ Obtendo Fingerprints de Certificados

Para usar o certificate pinning, você precisa obter o fingerprint SHA-256 do certificado do seu servidor:

### Método 1: Usando Engine Security (Automático)
```dart
// Obter o fingerprint diretamente do servidor ativo
final pinModel = await EngineHttpsPinningDetector.createPinFromLiveHost('stmr.tech');
print('Fingerprints obtidos: ${pinModel?.pins}');
```

### Método 2: OpenSSL
```bash
echo | openssl s_client -connect stmr.tech:443 2>/dev/null | openssl x509 -fingerprint -sha256 -noout
```

### Método 3: Chrome DevTools
1. Abra o site no Chrome
2. F12 → Security → View Certificate
3. Copie o SHA-256 fingerprint

### Método 4: A partir de arquivo
```dart
// Se você tem um arquivo .crt ou .pem
final pinModel = await EngineHttpsPinningDetector.createPinFromCertificateFile(
  'api.example.com',
  '/path/to/certificate.crt',
);
```

### Método 5: Hash conhecido
```dart
// Se você já tem o hash SHA-256
final pinModel = EngineHttpsPinningDetector.createPinFromHash(
  'stmr.tech',
  '17a8d38a1f559246194bccae62a794ff80d419e849fa78811a4910d7283c1f75',
);
```

## 📱 Exemplos

Execute o exemplo interativo:

```bash
cd examples/security_demo
flutter run
```

### Implementação Personalizada

```dart
### Detector de GPS Fake - Exemplo Avançado

```dart
import 'package:engine_security/engine_security.dart';

void main() async {
  final gpsDetector = EngineGpsFakeDetector();
  
  // Verificação básica
  final result = await gpsDetector.performCheck();
  
  if (!result.isSecure) {
    print('⚠️ GPS Fake detectado!');
    print('📍 Detalhes: ${result.details}');
    print('🔍 Método: ${result.detectionMethod}');
    print('🎯 Confiança: ${(result.confidence * 100).toStringAsFixed(1)}%');
    
    // Tomar ações de segurança
    await handleGpsFakeDetection(result);
  } else {
    print('✅ GPS é confiável');
  }
  
  // Verificações específicas
  final mockEnabled = await EngineGpsFakeDetector.checkMockLocationEnabled();
  final fakeApps = await EngineGpsFakeDetector.getInstalledFakeGpsApps();
  
  print('📱 Mock Location habilitado: $mockEnabled');
  print('🚫 Apps de GPS Fake encontrados: ${fakeApps.length}');
  
  for (final app in fakeApps) {
    print('   - $app');
  }
}

Future<void> handleGpsFakeDetection(SecurityCheckModel result) async {
  // Bloquear funcionalidades baseadas em localização
  // Registrar tentativa de fraude
  // Solicitar verificação adicional do usuário
  // Etc.
}
```

### Técnicas de Detecção de GPS Fake

O `EngineGpsFakeDetector` utiliza múltiplas técnicas para detectar manipulação de GPS:

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

class MySecurityManager {
  final List<ISecurityDetector> _detectors = [
    EngineFridaDetector(),
    EngineRootDetector(),
    EngineEmulatorDetector(),
    EngineDebuggerDetector(),
  ];
  
  Future<List<SecurityCheckModel>> scanAllThreats() async {
    final results = <SecurityCheckModel>[];
    
    for (final detector in _detectors) {
      if (detector.isAvailable) {
        try {
          final result = await detector.performCheck();
          results.add(result);
        } catch (e) {
          results.add(SecurityCheckModel(
            isSecure: false,
            threatType: detector.threatType,
            confidence: 0.5,
            details: 'Erro na detecção: $e',
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
    │   ├── i_security_detector.dart        # Interface base
    │   ├── engine_frida_detector.dart      # Detector Frida
    │   ├── engine_root_detector.dart       # Detector Root/Jailbreak
    │   ├── engine_emulator_detector.dart   # Detector Emulator
    │   └── engine_debugger_detector.dart   # Detector Debugger
    ├── models/                     # Modelos de dados
    │   ├── security_check_model.dart       # Modelo de resultado
    │   └── dector_info_model.dart          # Informações do detector
    └── enums/                      # Enumerações
        └── security_threat_type.dart       # Tipos de ameaças

test/
├── all_tests.dart                  # Suite completa de testes
├── models/                         # Testes dos modelos
├── enums/                          # Testes dos enums
├── interface/                      # Testes da interface
└── detectors/                      # Testes dos detectores

examples/
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

## 🧪 Qualidade e Testes

### Cobertura de Testes: 100%
- ✅ Todos os modelos testados
- ✅ Todos os enums testados
- ✅ Interface completamente testada
- ✅ Casos de borda cobertos
- ✅ Tratamento de erros validado

### Pipeline CI/CD

- 🔍 **Análise Estática** - dart analyze com warnings fatais
- 🧪 **Testes Unitários** - 100% de cobertura obrigatória
- 📊 **Codecov Integration** - Relatórios automáticos de cobertura
- 📝 **Pana Analysis** - Pontuação 100/100 obrigatória
- 🔒 **Security Scan** - Verificação de vulnerabilidades
- 🏗️ **Build Test** - Compilação e teste dos exemplos
- 📦 **Auto Publish** - Publicação automática em tags

### Comandos de Qualidade

```bash
# Executar todos os testes
dart test

# Testes com cobertura
dart test --coverage=coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib

# Verificar cobertura mínima
dart pub global activate test_coverage
dart pub global run test_coverage --min-coverage=100

# Análise Pana
dart pub global activate pana
dart pub global run pana
```

## 🔄 CI/CD Status

| Pipeline | Status | Descrição |
|----------|--------|-----------|
| Build | [![CI/CD Pipeline](https://github.com/moreirawbmaster/engine-security/actions/workflows/ci.yml/badge.svg)](https://github.com/moreirawbmaster/engine-security/actions/workflows/ci.yml) | Análise, testes e build |
| Coverage | [![codecov](https://codecov.io/gh/moreirawbmaster/engine-security/branch/main/graph/badge.svg)](https://codecov.io/gh/moreirawbmaster/engine-security) | Cobertura de testes |
| Quality | [![Pana Score](https://img.shields.io/badge/pana-100%2F100-brightgreen)](https://pub.dev/packages/engine_security/score) | Qualidade do código |
| Publish | [![Pub Version](https://img.shields.io/pub/v/engine_security)](https://pub.dev/packages/engine_security) | Versão publicada |

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

### Diretrizes de Contribuição

- ✅ Manter 100% de cobertura de testes
- ✅ Seguir as convenções Dart/Flutter
- ✅ Adicionar documentação para APIs públicas
- ✅ Testar em Android e iOS
- ✅ Garantir pontuação Pana 100/100

## 📄 Licença

Este projeto está licenciado sob a MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🏆 Reconhecimentos

- Comunidade Dart/Flutter
- Contribuidores do projeto

---

<div align="center">

**🛡️ Engine Security - Protegendo suas aplicações Flutter**

[![Pub.dev](https://img.shields.io/badge/pub.dev-engine__security-blue)](https://pub.dev/packages/engine_security)

</div>

