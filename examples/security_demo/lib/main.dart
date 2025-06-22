import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/dashboard/dashboard_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: SecurityDemoApp(),
    ),
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
