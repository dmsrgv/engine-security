# Engine Security

Plugin Flutter para funcionalidades de segurança runtime, detecção de ameaças e proteção contra instrumentação dinâmica para aplicações Android e iOS.

## Descrição

Este plugin centraliza todas as funcionalidades relacionadas à segurança runtime do aplicativo com foco exclusivo em dispositivos móveis reais:

- **Anti-Frida**: Detecção avançada do framework Frida e instrumentação dinâmica
- **Detecção de Emulador**: Identificação de execução em emuladores/simuladores
- **Detecção de Root/Jailbreak**: Verificação se o dispositivo foi comprometido
- **Detecção de Debugger**: Identificação de debuggers anexados ao processo

## Características Principais

### Detectores de Segurança Runtime
- **EngineFridaDetector**: Múltiplas técnicas de detecção do Frida
- **EngineEmulatorDetector**: Detecção de ambientes virtualizados
- **EngineRootDetector**: Verificação de root (Android) e jailbreak (iOS)
- **EngineDebuggerDetector**: Detecção de debuggers e análise dinâmica

### Arquitetura Moderna
- Interface comum para todos os detectores (`ISecurityDetector`)
- Modelos tipados para resultados e informações dos detectores
- Resultados padronizados com níveis de confiança e timestamps
- Suporte exclusivo para Android e iOS (sem Linux)
- Configuração individual de cada detector
- Null safety completo

### Sistema de Classificação de Ameaças
- Enum tipado `SecurityThreatType` com classificação automática
- Níveis de severidade de 0-10
- Descrições detalhadas das ameaças identificadas
- Métodos de detecção rastreáveis

## Estrutura do Projeto

```
engine-security/
├── lib/
│   ├── engine_security.dart                    # Exportação principal da biblioteca
│   └── src/
│       ├── src.dart                            # Exportações centralizadas dos módulos
│       ├── detectors/                          # Detectores de segurança
│       │   ├── detectors.dart                  # Exportação dos detectores
│       │   ├── i_security_detector.dart        # Interface base para detectores
│       │   ├── engine_frida_detector.dart      # Detector de Frida/instrumentação
│       │   ├── engine_emulator_detector.dart   # Detector de emulador/simulador  
│       │   ├── engine_root_detector.dart       # Detector de root/jailbreak
│       │   └── engine_debugger_detector.dart   # Detector de debugger
│       ├── models/                             # Modelos de dados
│       │   ├── models.dart                     # Exportação dos modelos
│       │   ├── detector_info_model.dart        # Modelo de informações do detector
│       │   └── security_check_model.dart       # Modelo de resultado de verificação
│       └── enums/                              # Enumerações
│           ├── enums.dart                      # Exportação dos enums
│           └── security_threat_type.dart       # Tipos de ameaças de segurança
├── pubspec.yaml                                # Dependências e metadados
├── analysis_options.yaml                      # Configurações de análise de código
└── README.md                                  # Documentação (este arquivo)
```

## Detalhamento dos Arquivos

### 📁 `/lib/`

#### `engine_security.dart`
Arquivo principal de exportação da biblioteca. Expõe todas as funcionalidades públicas através de um único ponto de entrada.

#### `src/src.dart`
Centralizador de exportações dos módulos internos. Organiza e expõe:
- Detectores de segurança
- Modelos de dados
- Enumerações

### 📁 `/lib/src/detectors/`

#### `i_security_detector.dart`
Interface abstrata que define o contrato comum para todos os detectores de segurança:
- `SecurityThreatType get threatType`: Tipo de ameaça detectada
- `String get detectorName`: Nome identificador do detector
- `Future<SecurityCheckModel> performCheck()`: Executa a verificação de segurança
- `bool get isAvailable`: Verifica disponibilidade na plataforma atual
- `DetectorInfoModel get detectorInfo`: Informações de configuração do detector

#### `engine_frida_detector.dart`
Detector especializado em identificar o framework Frida:
- Detecção de servidor Frida ativo em portas padrão (27042-27045)
- Verificação de bibliotecas Frida carregadas em memória
- Análise de processos relacionados ao Frida
- Detecção de arquivos do Frida no sistema
- Identificação de instrumentação dinâmica ativa

#### `engine_emulator_detector.dart` 
Detector de ambientes virtualizados:
- **Android**: Verificação de marca/modelo do dispositivo, hardware, fingerprint, propriedades específicas de emulador
- **iOS**: Detecção de simulador através de `DeviceInfoPlugin`, identificadores específicos, verificação de dispositivo físico
- Análise de características de hardware que indicam virtualização

#### `engine_root_detector.dart`
Detector de dispositivos comprometidos:
- **Android**: Verificação de arquivos de root, aplicativos de root, comando `su`, build tags de teste
- **iOS**: Detecção de arquivos de jailbreak, aplicações como Cydia, acesso a diretórios restritos
- Testes de escrita em diretórios protegidos

#### `engine_debugger_detector.dart`
Detector de debuggers e análise dinâmica:
- **Android**: Verificação de `TracerPid` em `/proc/self/status`, detecção de processos de debug (gdb, lldb, strace, ltrace, ptrace)
- **iOS**: Detecção de processos específicos (debugserver, lldb, gdb, cycript)
- Detecção de timing attack (execução anormalmente lenta pode indicar debugging)
- Implementação otimizada com spread operators

### 📁 `/lib/src/models/`

#### `detector_info_model.dart`
Modelo tipado para informações dos detectores:
```dart
class DetectorInfoModel {
  final String name;              // Nome do detector
  final SecurityThreatType threatType; // Tipo de ameaça
  final bool enabled;             // Status de habilitação
  final String platform;         // Plataforma atual
}
```

#### `security_check_model.dart`
Modelo tipado para resultados de verificação de segurança:
```dart
class SecurityCheckModel {
  final bool isSecure;                    // Resultado da verificação
  final SecurityThreatType threatType;    // Tipo de ameaça detectada
  final String? details;                  // Detalhes da detecção
  final String? detectionMethod;          // Método usado na detecção
  final double confidence;                // Nível de confiança (0.0-1.0)
  final DateTime? timestamp;              // Timestamp da verificação
}
```

Factories convenientes:
- `SecurityCheckModel.secure()`: Para resultados seguros
- `SecurityCheckModel.threat()`: Para ameaças detectadas

### 📁 `/lib/src/enums/`

#### `security_threat_type.dart`
Enumeração tipada dos tipos de ameaças de segurança:
- `SecurityThreatType.frida`: Instrumentação dinâmica (Severidade: 9)
- `SecurityThreatType.rootJailbreak`: Dispositivo comprometido (Severidade: 8)
- `SecurityThreatType.emulator`: Ambiente virtualizado (Severidade: 7)
- `SecurityThreatType.debugger`: Debugging ativo (Severidade: 8)
- `SecurityThreatType.unknown`: Tipo desconhecido (Severidade: 1)

Cada tipo inclui:
- Nome para exibição (`displayName`)
- Descrição detalhada (`description`)
- Nível de severidade de 0-10 (`severityLevel`)

## Instalação

### Via Git

Adicione no seu `pubspec.yaml`:

```yaml
dependencies:
  engine_security:
    git:
      url: https://github.com/stmr/engine.git
      path: packages/engine-security
      ref: main
```

### Via Path Local

```yaml
dependencies:
  engine_security:
    path: ../packages/engine-security
```

## Uso Atualizado

### Detecção Individual com Novos Modelos

```dart
import 'package:engine_security/engine_security.dart';

final fridaDetector = EngineFridaDetector(enabled: true);
final fridaResult = await fridaDetector.performCheck();

if (!fridaResult.isSecure) {
  print('ALERTA: ${fridaResult.details}');
  print('Confiança: ${fridaResult.confidence}');
  print('Severidade: ${fridaResult.threatType.severityLevel}');
  print('Detectado em: ${fridaResult.timestamp}');
}

final debuggerDetector = EngineDebuggerDetector(enabled: true);
final debuggerResult = await debuggerDetector.performCheck();

print('Informações do Detector:');
print('Nome: ${debuggerDetector.detectorInfo.name}');
print('Plataforma: ${debuggerDetector.detectorInfo.platform}');
print('Tipo de Ameaça: ${debuggerDetector.detectorInfo.threatType.displayName}');
```

### Verificação Completa de Segurança

```dart
import 'package:engine_security/engine_security.dart';

Future<List<SecurityCheckModel>> performSecurityScan() async {
  final detectors = <ISecurityDetector>[
    EngineFridaDetector(enabled: true),
    EngineEmulatorDetector(enabled: true),
    EngineRootDetector(enabled: true),
    EngineDebuggerDetector(enabled: true),
  ];

  final results = <SecurityCheckModel>[];
  
  for (final detector in detectors) {
    if (detector.isAvailable) {
      try {
        final result = await detector.performCheck();
        results.add(result);
        
        if (!result.isSecure) {
          print('AMEAÇA DETECTADA:');
          print('Tipo: ${result.threatType.displayName}');
          print('Detalhes: ${result.details}');
          print('Método: ${result.detectionMethod}');
          print('Confiança: ${result.confidence}');
          print('Severidade: ${result.threatType.severityLevel}/10');
          print('Timestamp: ${result.timestamp}');
          print('---');
        }
      } catch (e) {
        print('Erro no detector ${detector.detectorName}: $e');
      }
    }
  }

  return results;
}

final securityResults = await performSecurityScan();
final threatsDetected = securityResults.where((r) => !r.isSecure).toList();

if (threatsDetected.isNotEmpty) {
  print('${threatsDetected.length} ameaça(s) detectada(s)!');
  
  final criticalThreats = threatsDetected
      .where((t) => t.threatType.severityLevel >= 8)
      .toList();
      
  if (criticalThreats.isNotEmpty) {
    print('AMEAÇAS CRÍTICAS DETECTADAS!');
  }
} else {
  print('Nenhuma ameaça detectada.');
}
```

### Análise de Severidade

```dart
final threatType = SecurityThreatType.frida;

print('Nome: ${threatType.displayName}');
print('Descrição: ${threatType.description}');
print('Severidade: ${threatType.severityLevel}/10');

switch (threatType.severityLevel) {
  case >= 9:
    print('AMEAÇA EXTREMAMENTE CRÍTICA!');
  case >= 8:
    print('AMEAÇA CRÍTICA!');
  case >= 6:
    print('Ameaça moderada');
  case >= 3:
    print('Ameaça baixa');
  default:
    print('Ameaça mínima');
}
```

## Detectores Disponíveis

### EngineFridaDetector
**Severidade: 9/10** - Detecção de instrumentação dinâmica
- Verificação de servidor Frida em portas padrão
- Análise de bibliotecas Frida carregadas
- Detecção de processos Frida ativos
- Verificação de arquivos Frida no sistema
- Detecção de instrumentação em runtime

### EngineEmulatorDetector  
**Severidade: 7/10** - Detecção de ambientes virtualizados
- **Android**: Análise de marca, modelo, hardware, fingerprint de emulador
- **iOS**: Detecção de simulador através de APIs nativas
- Verificação de características de dispositivo físico vs virtual

### EngineRootDetector
**Severidade: 8/10** - Detecção de dispositivos comprometidos
- **Android**: Verificação de arquivos root, apps de root, comando su, build tags
- **iOS**: Detecção de jailbreak, Cydia, acesso a diretórios restritos
- Testes de escrita em áreas protegidas

### EngineDebuggerDetector
**Severidade: 8/10** - Detecção de debugging ativo
- **Android**: Análise de TracerPid, processos de debug
- **iOS**: Detecção de debugserver, lldb, cycript
- Detecção de timing attack para debugging
- Implementação otimizada com spread operators

## Compatibilidade

- ✅ **Android**: API 21+ (Android 5.0+)
- ✅ **iOS**: iOS 12.0+
- ❌ **Linux**: Não suportado (removido)
- ❌ **Windows**: Não suportado
- ❌ **macOS**: Não suportado
- ❌ **Web**: Não suportado

## Dependências

- `flutter`: SDK Flutter
- `device_info_plus: ^10.1.0`: Informações do dispositivo
- `package_info_plus: ^8.0.0`: Informações do pacote

## Notas Técnicas

### Otimizações Implementadas
- Uso de spread operators para coleta eficiente de indicadores
- Null safety completo com retorno `String?` onde apropriado
- Modelos tipados para melhor type safety
- Implementação de `// ignore_for_file: empty_catches` para catches vazios intencionais

### Considerações de Segurança
- Todos os detectores executam verificações assíncronas
- Tratamento robusto de erros com fallback seguro
- Níveis de confiança ajustáveis por detector
- Timestamps para auditoria de detecções
- Sem dependências de plataformas desktop ou web

### Performance
- Verificações otimizadas para dispositivos móveis
- Timeout configurável para operações de rede
- Processamento paralelo de múltiplos indicadores
- Cache inteligente de resultados quando aplicável

Este plugin segue as melhores práticas de segurança mobile e está alinhado com os padrões da indústria para proteção runtime de aplicações móveis. 