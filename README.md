# 🛡️ Engine Security

[![CI/CD Pipeline](https://github.com/thiagomoreira/engine-security/actions/workflows/ci.yml/badge.svg)](https://github.com/thiagomoreira/engine-security/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/thiagomoreira/engine-security/branch/main/graph/badge.svg)](https://codecov.io/gh/thiagomoreira/engine-security)
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
- 🛡️ **5 Detectores Especializados** - Frida, Root/Jailbreak, Emulator, Debugger, GPS Fake
- ⚡ **Detecção Assíncrona** - Performance otimizada
- 🎨 **API Intuitiva** - Fácil integração e uso
- 📊 **Sistema de Confiança** - Níveis de confiança calibrados
- 🔒 **Zero Dependências Externas** - Seguro e leve

## 📦 Instalação

Adicione ao seu `pubspec.yaml`:

```yaml
dependencies:
  engine_security: ^1.0.0
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
    EngineEmulatorDetector(),
    EngineDebuggerDetector(),
    EngineGpsFakeDetector(),
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
- **Ameaça**: `SecurityThreatType.rootJailbreak`
- **Confiança**: 90%
- **Métodos**: Arquivos de sistema, apps instalados, permissões
- **Plataformas**: Android, iOS

### 3. 📱 Emulator Detector (`EngineEmulatorDetector`)
- **Ameaça**: `SecurityThreatType.emulator`
- **Confiança**: 85%
- **Métodos**: Hardware, sensores, características do sistema
- **Plataformas**: Android, iOS

### 4. 🐛 Debugger Detector (`EngineDebuggerDetector`)
- **Ameaça**: `SecurityThreatType.debugger`
- **Confiança**: 85%
- **Métodos**: Processos de debug, timing attacks
- **Plataformas**: Android, iOS

### 5. 🗺️ GPS Fake Detector (`EngineGpsFakeDetector`)
- **Ameaça**: `SecurityThreatType.gpsFake`
- **Confiança**: 90%
- **Métodos**: Mock location, apps falsos, consistência GPS, análise de localização
- **Plataformas**: Android, iOS

## 📊 Modelos de Dados

### SecurityCheckModel

```dart
class SecurityCheckModel {
  final bool isSecure;
  final SecurityThreatType threatType;
  final double confidence;
  final String? details;
  final String? detectionMethod;
  final DateTime? timestamp;
  
  // Factories
  SecurityCheckModel.secure({...});
  SecurityCheckModel.threat({required SecurityThreatType threatType, ...});
}
```

### DetectorInfoModel

```dart
class DetectorInfoModel {
  final String name;
  final SecurityThreatType threatType;
  final bool enabled;
  final String platform;
}
```

### SecurityThreatType

```dart
enum SecurityThreatType {
  unknown,      // Severidade: 5
  frida,        // Severidade: 9
  emulator,     // Severidade: 6
  rootJailbreak,// Severidade: 8
  debugger,     // Severidade: 2
  gpsFake,      // Severidade: 7
}
```

## 🔧 Interface

### ISecurityDetector

```dart
abstract class ISecurityDetector {
  SecurityThreatType get threatType;
  String get detectorName;
  Future<SecurityCheckModel> performCheck();
  bool get isAvailable;
  DetectorInfoModel get detectorInfo;
}
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
| Build | [![CI/CD Pipeline](https://github.com/thiagomoreira/engine-security/actions/workflows/ci.yml/badge.svg)](https://github.com/thiagomoreira/engine-security/actions/workflows/ci.yml) | Análise, testes e build |
| Coverage | [![codecov](https://codecov.io/gh/thiagomoreira/engine-security/branch/main/graph/badge.svg)](https://codecov.io/gh/thiagomoreira/engine-security) | Cobertura de testes |
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

