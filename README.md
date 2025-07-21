# 🛡️ Engine Security

[![CI/CD Pipeline](https://github.com/moreirawebmaster/engine-security/actions/workflows/ci.yml/badge.svg)](https://github.com/moreirawebmaster/engine-security/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/moreirawebmaster/engine-security/branch/main/graph/badge.svg)](https://codecov.io/gh/moreirawebmaster/engine-security)
[![Pub Version](https://img.shields.io/pub/v/engine_security)](https://pub.dev/packages/engine_security)
[![Pana Score](https://img.shields.io/badge/pana-100%2F100-brightgreen)](https://pub.dev/packages/engine_security/score)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-blue)](https://pub.dev/packages/engine_security)

> **Современная система обнаружения угроз безопасности для Flutter-приложений, ориентированная на Android и iOS**

## 📋 Оглавление

- [Возможности](#-возможности)
- [Установка](#-установка)
- [Быстрый старт](#-быстрый-старт)
- [Доступные детекторы](#-доступные-детекторы)
- [HTTPS Certificate Pinning](#-https-certificate-pinning)
- [Обнаружение поддельного GPS](#-обнаружение-поддельного-gps)
- [Модели данных](#-модели-данных)
- [Интерфейс](#-интерфейс)
- [Примеры](#-примеры)
- [Разработка](#-разработка)
- [Качество и тесты](#-качество-и-тесты)
- [Вклад](#-вклад)
- [Лицензия](#-лицензия)

## 🚀 Возможности

- ✅ **100% покрытие тестами** — все компоненты протестированы
- 🎯 **Pana Score 100/100** — максимальное качество на pub.dev
- 🔄 **Автоматизированный CI/CD** — полный pipeline на GitHub Actions
- 📱 **Только Android & iOS** — оптимизировано для мобильных устройств
- 🛡️ **6 специализированных детекторов** — Frida, Root/Jailbreak, HTTPS Pinning, GPS Fake, Эмулятор, Отладчик
- ⚡ **Асинхронное обнаружение** — оптимизированная производительность
- 🎨 **Интуитивно понятный API** — простая интеграция и использование
- 📊 **Система доверия** — калиброванные уровни доверия
- 🔒 **Без внешних зависимостей** — безопасно и легко

## 📦 Установка

Добавьте в ваш `pubspec.yaml`:

```yaml
dependencies:
  engine_security: ^1.2.0
```

Выполните:

```bash
flutter pub get
```

## ⚡ Быстрый старт

```dart
import 'package:engine_security/engine_security.dart';

void main() async {
  // Обнаружение Frida
  final fridaDetector = EngineFridaDetector();
  final fridaResult = await fridaDetector.performCheck();
  
  if (!fridaResult.isSecure) {
    print('⚠️ Обнаружен Frida: ${fridaResult.details}');
    print('🎯 Доверие: ${fridaResult.confidence}');
  }
  
  // Обнаружение Root/Jailbreak
  final rootDetector = EngineRootDetector();
  final rootResult = await rootDetector.performCheck();
  
  if (!rootResult.isSecure) {
    print('⚠️ Устройство скомпрометировано: ${rootResult.details}');
  }
  
  // Полная проверка
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
  
  print('🔍 Запуск полной проверки безопасности...\n');
  
  for (final detector in detectors) {
    if (detector.isAvailable) {
      final result = await detector.performCheck();
      final status = result.isSecure ? '✅' : '❌';
      
      print('$status ${detector.detectorName}');
      print('   Доверие: ${(result.confidence * 100).toStringAsFixed(1)}%');
      print('   Детали: ${result.details ?? 'N/A'}');
      print('');
    }
  }
}
```

## 🛡️ Доступные детекторы

### 1. 🔴 Frida Detector (`EngineFridaDetector`)

- **Угроза**: `EngineSecurityThreatType.frida`
- **Серьёзность**: 9/10
- **Доверие**: 95%
- **Методы**: Обнаружение процессов, библиотек и портов
- **Платформы**: Android ✅ | iOS ✅

### 2. 🔑 Root/Jailbreak Detector (`EngineRootDetector`)

- **Угроза**: `EngineSecurityThreatType.rootJailbreak`
- **Серьёзность**: 8/10
- **Доверие**: 90%
- **Методы**: Системные файлы, установленные приложения, разрешения
- **Платформы**: Android ✅ | iOS ✅

### 3. 🔒 HTTPS Certificate Pinning Detector (`EngineHttpsPinningDetector`)

- **Угроза**: `EngineSecurityThreatType.httpsPinning`
- **Серьёзность**: 8/10
- **Доверие**: 95%
- **Методы**: Валидация SSL/TLS сертификатов, SHA-256 отпечатки
- **Платформы**: Android ✅ | iOS ✅

### 4. 🗺️ GPS Fake Detector (`EngineGpsFakeDetector`)

- **Угроза**: `EngineSecurityThreatType.gpsFake`
- **Серьёзность**: 7/10
- **Доверие**: 90%
- **Методы**: Mock location, поддельные приложения, консистентность GPS
- **Платформы**: Android ✅ | iOS ✅

### 5. 📱 Emulator Detector (`EngineEmulatorDetector`)

- **Угроза**: `EngineSecurityThreatType.emulator`
- **Серьёзность**: 6/10
- **Доверие**: 85%
- **Методы**: Аппаратные характеристики, сенсоры, системные признаки
- **Платформы**: Android ✅ | iOS ✅

### 6. 🐛 Debugger Detector (`EngineDebuggerDetector`)

- **Угроза**: `EngineSecurityThreatType.debugger`
- **Серьёзность**: 2/10
- **Доверие**: 85%
- **Методы**: Процессы отладки, timing-атаки
- **Платформы**: Android ✅ | iOS ✅

## 🔒 HTTPS Certificate Pinning

Engine Security включает надёжную систему certificate pinning для защиты от атак типа man-in-the-middle и перехвата трафика.

### Базовая настройка

```dart
import 'package:engine_security/engine_security.dart';
import 'dart:io';

void setupCertificatePinning() {
  // Настройка pins для разных доменов
  final pins = [
    EngineCertificatePinModel(
      hostname: 'api.example.com',
      pins: [
        'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=', // SHA-256 в base64
        '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef', // SHA-256 в hex
      ],
      includeSubdomains: true,
      enforcePinning: true,
    ),
    EngineCertificatePinModel(
      hostname: 'stmr.tech',
      pins: [
        '17a8d38a1f559246194bccae62a794ff80d419e849fa78811a4910d7283c1f75', // Реальный SHA-256 отпечаток
      ],
      includeSubdomains: true,
      enforcePinning: true,
    ),
  ];

  // Глобальная настройка HttpOverrides
  final httpOverrides = EngineSecurityHttpOverrides(
    pinnedCertificates: pins,
    onPinningValidation: (hostname, isValid, error) {
      print('Проверка pin для $hostname: ${isValid ? 'OK' : 'ОШИБКА'}');
      if (error != null) print('Ошибка: $error');
    },
  );

  HttpOverrides.global = httpOverrides;
}
```

### Детектор Certificate Pinning

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
    strictMode: false, // true = только проверка существующих pins
  );
  
  final result = await detector.performCheck();
  
  if (!result.isSecure) {
    print('Certificate pinning не настроен!');
    print('Детали: ${result.details}');
  } else {
    print('Certificate pinning настроен корректно!');
    print('Защищённые сайты: ${result.details}');
  }
}
```

### Получение отпечатков сертификатов

#### Метод 1: Использование Engine Security (автоматически)

```dart
// Получить отпечаток напрямую с сервера
final pinModel = await EngineHttpsPinningDetector.createPinFromLiveHost('stmr.tech');
print('Полученные отпечатки: ${pinModel?.pins}');
```

#### Метод 2: OpenSSL

```bash
echo | openssl s_client -connect stmr.tech:443 2>/dev/null | openssl x509 -fingerprint -sha256 -noout
```

#### Метод 3: Chrome DevTools

1. Откройте сайт в Chrome
2. F12 → Security → View Certificate
3. Скопируйте SHA-256 отпечаток

#### Метод 4: Из файла

```dart
// Если у вас есть .crt или .pem файл
final pinModel = await EngineHttpsPinningDetector.createPinFromCertificateFile(
  'api.example.com',
  '/path/to/certificate.crt',
);
```

#### Метод 5: Известный хеш

```dart
// Если у вас уже есть SHA-256 хеш
final pinModel = EngineHttpsPinningDetector.createPinFromHash(
  'stmr.tech',
  '17a8d38a1f559246194bccae62a794ff80d419e849fa78811a4910d7283c1f75',
);
```

## 🗺️ Обнаружение поддельного GPS

`EngineGpsFakeDetector` использует несколько техник для обнаружения подделки GPS:

### Техники обнаружения

#### 1. 🔧 Проверка Mock Location (Android)

- Обнаруживает, включена ли опция mock location для разработчиков
- Проверяет системные настройки Android

#### 2. 📱 Обнаружение приложений для подделки GPS

- Проверяет установку более 25 известных приложений для подделки GPS
- Актуальный список основных приложений для spoofing

#### 3. 📊 Анализ достоверности источника

- Проверяет подозрительную точность GPS (< 100м может быть подделкой)
- Обнаруживает невозможные значения (высота и скорость равны нулю)

#### 4. 🔄 Проверка консистентности GPS

- Анализирует невозможные перемещения между GPS-отметками
- Обнаруживает "телепортацию" (расстояние > 1км за < 10с)

#### 5. 🔐 Анализ разрешений

- Проверяет вмешательство в разрешения на определение местоположения
- Обнаруживает подозрительное отключение сервисов геолокации

### Пример использования

```dart
import 'package:engine_security/engine_security.dart';

Future<void> checkGPSFake() async {
  final gpsDetector = EngineGpsFakeDetector();
  
  // Базовая проверка
  final result = await gpsDetector.performCheck();
  
  if (!result.isSecure) {
    print('⚠️ Обнаружен поддельный GPS!');
    print('📍 Детали: ${result.details}');
    print('🔍 Метод: ${result.detectionMethod}');
    print('🎯 Доверие: ${(result.confidence * 100).toStringAsFixed(1)}%');
  } else {
    print('✅ GPS достоверен');
  }
}
```

## 📊 Модели данных

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
  final List<String> pins; // SHA-256 в base64 или hex
  final bool includeSubdomains;
  final bool enforcePinning;
  
  // Методы валидации
  bool isValidPinFormat(String pin);
  bool matchesHostname(String host);
}
```

### EngineSecurityThreatType

```dart
enum EngineSecurityThreatType {
  unknown,        // Серьёзность: 5
  frida,          // Серьёзность: 9
  rootJailbreak,  // Серьёзность: 8
  httpsPinning,   // Серьёзность: 8
  gpsFake,        // Серьёзность: 7
  emulator,       // Серьёзность: 6
  debugger,       // Серьёзность: 2
}
```

## 🔧 Интерфейс

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

## 📱 Примеры

Запустите интерактивный пример:

```bash
cd demo/security_demo
flutter run
```

### Кастомная реализация

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
            details: 'Ошибка при обнаружении: $e',
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

## 🔧 Разработка

### Структура проекта

```
lib/
├── engine_security.dart           # Главная точка входа
└── src/
    ├── src.dart                    # Централизованные экспорты
    ├── detectors/                  # Детекторы безопасности
    │   ├── i_engine_security_detector.dart     # Базовый интерфейс
    │   ├── engine_frida_detector.dart          # Детектор Frida
    │   ├── engine_root_detector.dart           # Детектор Root/Jailbreak
    │   ├── engine_https_pinning_detector.dart  # Детектор HTTPS Pinning
    │   ├── engine_gps_fake_detector.dart       # Детектор GPS Fake
    │   ├── engine_emulator_detector.dart       # Детектор Emulator
    │   └── engine_debugger_detector.dart       # Детектор Debugger
    ├── models/                     # Модели данных
    │   ├── engine_security_check_model.dart    # Модель результата
    │   ├── engine_detector_info_model.dart     # Информация о детекторе
    │   └── engine_certificate_pin_model.dart   # Модель certificate pin
    ├── enums/                      # Перечисления
    │   └── engine_security_threat_type.dart    # Типы угроз
    └── network/                    # Сетевые компоненты
        └── engine_security_http_overrides.dart # HttpOverrides для pinning

test/
├── all_tests.dart                  # Полный набор тестов
├── models/                         # Тесты моделей
├── enums/                          # Тесты перечислений
├── interface/                      # Тесты интерфейса
└── detectors/                      # Тесты детекторов

demo/
└── security_demo/                  # Демонстрационное приложение

scripts/
├── test_coverage.sh               # Скрипт покрытия тестами
└── pana_analysis.sh               # Скрипт анализа Pana
```

### Скрипты для разработки

```bash
# Запуск тестов с покрытием
./scripts/test_coverage.sh

# Анализ качества Pana
./scripts/pana_analysis.sh

# Статический анализ
dart analyze

# Форматирование кода
dart format .

# Публикация (dry-run)
dart pub publish --dry-run
```

### Команды для проверки качества

```bash
# Запуск всех тестов
flutter test

# Тесты с покрытием
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Проверка минимального покрытия
dart pub global activate test_coverage
dart pub global run test_coverage --min-coverage=50

# Анализ Pana
dart pub global activate pana
dart pub global run pana
```

## 🤝 Вклад

Вклады приветствуются! Пожалуйста:

1. Сделайте fork проекта
2. Создайте ветку для вашей фичи (`git checkout -b feature/AmazingFeature`)
3. Зафиксируйте изменения (`git commit -m 'Добавить AmazingFeature'`)
4. Отправьте ветку (`git push origin feature/AmazingFeature`)
5. Откройте Pull Request

### Рекомендации по вкладу

- Поддерживайте 100% покрытие тестами
- Следуйте существующему стилю кода
- Документируйте новые функции
- Тестируйте на Android и iOS
- Обновляйте CHANGELOG.md

## 📄 Лицензия

Этот проект лицензирован по лицензии MIT — смотрите файл [LICENSE](LICENSE) для подробностей.

---

**⚠️ Внимание по безопасности**: Этот пакет — инструмент обнаружения, а не полноценное решение по безопасности. Всегда реализуйте несколько уровней защиты в ваших приложениях.

**Разработано:** [Thiago Moreira](https://github.com/moreirawebmaster)  
**Организация:** [STMR](https://stmr.tech)  
**Домен:** tech.stmr

---

**⭐ Если этот проект был вам полезен, поставьте звезду репозиторию!**

[![GitHub stars](https://img.shields.io/github/stars/moreirawebmaster/engine-security?style=social)](https://github.com/moreirawebmaster/engine-security/stargazers)

**🤝 Вклады всегда приветствуются!**

[![GitHub issues](https://img.shields.io/github/issues/moreirawebmaster/engine-security)](https://github.com/moreirawebmaster/engine-security/issues)
[![GitHub pull requests](https://img.shields.io/github/issues-pr/moreirawebmaster/engine-security)](https://github.com/moreirawebmaster/engine-security/pulls)

---

**📧 Контакт:** [Email](mailto:moreirawebmaster@gmail.com)  
**🌐 Сайт:** [stmr.tech](https://stmr.tech)  
**🐦 Twitter:** [@moreirawebmaster](https://twitter.com/parabastech)
