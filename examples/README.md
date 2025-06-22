# 📚 Engine Security - Examples

Esta pasta contém exemplos práticos e aplicações de demonstração da biblioteca **Engine Security**.

## 🎯 Projetos Disponíveis

### 🔐 Security Demo
> **Pasta**: `security_demo/`

Uma aplicação Flutter completa e moderna para testar todos os detectores de segurança em tempo real.

**Características:**
- Interface elegante com tema dark
- Cores vibrantes (azul, roxo, verde, preto, branco)
- Testes individuais e em lote
- Dashboard com resumo de segurança
- Resultados detalhados e visuais
- Arquitetura limpa com Riverpod

**Detectores Incluídos:**
- ✅ Detecção Frida
- ✅ Detecção Root/Jailbreak
- ✅ Detecção Emulador
- ✅ Detecção Debugger

**Como Executar:**
```bash
cd security_demo
flutter pub get
flutter run
```

## 🏗️ Estrutura

```
examples/
├── README.md                    # Este arquivo
└── security_demo/              # App de demonstração
    ├── lib/
    │   ├── main.dart           # Ponto de entrada
    │   ├── core/               # Configurações centrais
    │   ├── features/           # Funcionalidades principais
    │   └── shared/             # Componentes compartilhados
    ├── pubspec.yaml            # Dependências
    └── README.md               # Documentação específica
```

## 🎨 Padrões de Design

Todos os exemplos seguem:
- **Material Design 3**: Componentes modernos
- **Tema Escuro**: Foco na usabilidade
- **Cores Consistentes**: Paleta definida
- **Responsividade**: Adaptável a diferentes telas
- **Acessibilidade**: Padrões de acessibilidade

## 🔧 Tecnologias Utilizadas

- **Flutter**: Framework principal
- **Riverpod**: Gerenciamento de estado
- **Engine Security**: Biblioteca de segurança
- **Material 3**: Sistema de design

## 📱 Compatibilidade

- **Plataformas**: Android e iOS
- **Versão Mínima**: 
  - Android: API 21+ (Android 5.0)
  - iOS: iOS 12.0+
- **Flutter**: 3.32.0+

## 🚀 Começando

1. **Clone o repositório**:
   ```bash
   git clone <repository-url>
   cd engine-security/examples
   ```

2. **Escolha um exemplo**:
   ```bash
   cd security_demo
   ```

3. **Instale as dependências**:
   ```bash
   flutter pub get
   ```

4. **Execute no dispositivo**:
   ```bash
   flutter run
   ```

## 📊 Propósito dos Exemplos

### Para Desenvolvedores
- Entender como integrar a Engine Security
- Ver implementações práticas
- Aprender padrões de uso
- Testar funcionalidades

### Para Testes
- Validar detectores em dispositivos reais
- Verificar comportamento em diferentes cenários
- Demonstrar capacidades para stakeholders
- Identificar falsos positivos/negativos

## 🤝 Contribuindo

Quer adicionar um novo exemplo? Siga estas diretrizes:

1. **Crie uma nova pasta** com nome descritivo
2. **Siga a estrutura** dos exemplos existentes
3. **Documente bem** com README detalhado
4. **Use as cores** da paleta padrão
5. **Teste** em Android e iOS

## 📝 Licença

Os exemplos seguem a mesma licença da biblioteca Engine Security.

---

**Explore, teste e contribua! 🎉** 