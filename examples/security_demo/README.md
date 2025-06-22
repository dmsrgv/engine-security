# 🔐 Engine Security Demo

Uma aplicação Flutter de demonstração elegante e moderna para testar todos os detectores de segurança da biblioteca **Engine Security**.

## 📱 Características

- **Interface Moderna**: Design escuro com cores vibrantes (azul, roxo, verde, preto e branco)
- **Testes em Tempo Real**: Execute detectores individuais ou todos de uma vez
- **Resumo Detalhado**: Dashboard com estatísticas completas de segurança
- **Resultados Visuais**: Cards interativos com informações detalhadas
- **Estado Reativo**: Interface atualizada em tempo real usando Riverpod

## 🎨 Design

A aplicação utiliza um tema dark moderno com:
- **Cores Primárias**: Azul (#6366F1) e Roxo (#8B5CF6)
- **Cores de Sucesso**: Verde (#10B981)
- **Cores de Alerta**: Vermelho (#EF4444)
- **Gradientes**: Transições suaves entre cores
- **Material Design 3**: Componentes modernos e responsivos

## 🔍 Detectores Testados

### 1. Detecção Frida
- **Descrição**: Detecta frameworks de instrumentação dinâmica como Frida
- **Ícone**: 🐛 bug_report
- **Plataformas**: Android, iOS

### 2. Detecção Root/Jailbreak  
- **Descrição**: Verifica se o dispositivo foi comprometido (root/jailbreak)
- **Ícone**: 🛡️ admin_panel_settings
- **Plataformas**: Android, iOS

### 3. Detecção Emulador
- **Descrição**: Identifica se está executando em emulador/simulador
- **Ícone**: 📱 phone_android  
- **Plataformas**: Android, iOS

### 4. Detecção Debugger
- **Descrição**: Detecta debuggers anexados ao processo
- **Ícone**: 💻 code
- **Plataformas**: Android, iOS

## 📊 Informações Exibidas

Para cada teste executado, a aplicação mostra:

- **Status**: Seguro/Ameaça Detectada/Executando
- **Detalhes**: Informações específicas do detector
- **Confiança**: Percentual e descrição (0-100%)
- **Método**: Técnica de detecção utilizada
- **Tempo**: Duração da execução em millisegundos
- **Severidade**: Nível de ameaça (quando aplicável)

## 🏗️ Arquitetura

```
lib/
├── main.dart                           # Ponto de entrada
├── core/
│   └── theme/
│       └── app_theme.dart             # Tema e cores
├── features/
│   └── dashboard/
│       └── dashboard_screen.dart      # Tela principal
└── shared/
    ├── models/
    │   └── detector_test_result.dart  # Modelo de resultado
    ├── providers/
    │   └── security_test_provider.dart # Estado global
    └── widgets/
        └── security_card.dart         # Card de teste
```

## 🚀 Como Executar

1. **Pré-requisitos**:
   ```bash
   flutter --version  # Flutter 3.0+
   ```

2. **Instalar Dependências**:
   ```bash
   cd examples/security_demo
   flutter pub get
   ```

3. **Executar no Android**:
   ```bash
   flutter run -d android
   ```

4. **Executar no iOS**:
   ```bash
   flutter run -d ios
   ```

## 📋 Funcionalidades

### Dashboard Principal
- Resumo geral de segurança
- Progresso dos testes
- Contadores de ameaças e testes seguros
- Botão para executar todos os testes

### Cards de Teste
- Execução individual de cada detector
- Indicadores visuais de status
- Resultados detalhados expandíveis
- Animações de carregamento

### Ações Disponíveis
- **Testar Todos**: Executa todos os detectores sequencialmente
- **Executar Teste**: Roda um detector específico
- **Limpar**: Remove todos os resultados

## 🎯 Estados dos Testes

- **🔄 Executando**: Teste em andamento com spinner
- **✅ Seguro**: Nenhuma ameaça detectada
- **⚠️ Ameaça**: Problema de segurança identificado
- **❓ Não Testado**: Teste ainda não executado

## 📱 Compatibilidade

- **Android**: API 21+ (Android 5.0)
- **iOS**: iOS 12.0+
- **Plataformas Suportadas**: Apenas mobile (Android/iOS)

## 🛠️ Tecnologias Utilizadas

- **Flutter**: Framework de desenvolvimento
- **Riverpod**: Gerenciamento de estado
- **Engine Security**: Biblioteca de detectores
- **Material Design 3**: Sistema de design

## 📈 Métricas de Confiança

- **95-100%**: Extremamente confiável
- **85-94%**: Muito confiável  
- **70-84%**: Confiável
- **50-69%**: Incerto
- **0-49%**: Não confiável

## 🔧 Personalização

O tema pode ser facilmente customizado em `lib/core/theme/app_theme.dart`:

```dart
class AppColors {
  static const Color primary = Color(0xFF6366F1);    // Azul
  static const Color secondary = Color(0xFF8B5CF6);  // Roxo
  static const Color accent = Color(0xFF10B981);     // Verde
  // ... outras cores
}
```

## 📝 Exemplo de Uso

```dart
// Executar teste específico
ref.read(securityTestProvider.notifier).runDetectorTest('Frida');

// Executar todos os testes
ref.read(securityTestProvider.notifier).runAllTests();

// Obter resultados
final results = ref.watch(securityTestProvider);
final summary = ref.watch(securitySummaryProvider);
```

---

**Desenvolvido com ❤️ para demonstrar as capacidades da Engine Security**
