import 'dart:io';

import 'package:engine_security/engine_security.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/dashboard/dashboard_screen.dart';

void main() {
  // Configurar Certificate Pinning
  _setupCertificatePinning();

  runApp(const ProviderScope(child: SecurityDemoApp()));
}

void _setupCertificatePinning() {
  final pins = [
    EngineCertificatePinModel(
      hostname: 'stmr.tech',
      pins: ['17a8d38a1f559246194bccae62a794ff80d419e849fa78811a4910d7283c1f75'],
      includeSubdomains: false,
      enforcePinning: true,
    ),
    // Exemplo adicional com base64
    EngineCertificatePinModel(
      hostname: 'google.com',
      pins: ['KwccWaCgrnaw6tsrrSO61FgLacNgG2MMLq8GE6+oP5I='],
      includeSubdomains: true,
      enforcePinning: false, // Modo apenas reporting para google.com
    ),
  ];

  HttpOverrides.global = EngineSecurityHttpOverrides(
    pinnedCertificates: pins,
    onPinningValidation: (hostname, isValid, error) {
      debugPrint('Certificate pinning para $hostname: ${isValid ? 'VÁLIDO' : 'INVÁLIDO'}');
      if (error != null) debugPrint('Erro: $error');
    },
  );
}

class SecurityDemoApp extends StatelessWidget {
  const SecurityDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Engine Security Demo',
      theme: AppTheme.darkTheme,
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
