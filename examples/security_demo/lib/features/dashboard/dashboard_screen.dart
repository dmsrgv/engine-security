import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/providers/security_test_provider.dart';
import '../../shared/widgets/security_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testResults = ref.watch(securityTestProvider);
    final summary = ref.watch(securitySummaryProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              centerTitle: true,
              backgroundColor: AppColors.background,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: const Text(
                  'Security Demo',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        const Icon(
                          Icons.security,
                          size: 48,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Engine Security',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Teste todos os detectores',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCard(context, summary),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Text(
                          'Detectores de Segurança',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const Spacer(),
                        OutlinedButton.icon(
                          onPressed:
                              summary.isRunning ? null : () => ref.read(securityTestProvider.notifier).runAllTests(),
                          icon: summary.isRunning
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.play_arrow),
                          label: Text(summary.isRunning ? 'Executando...' : 'Testar Todos'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SecurityCard(
                    title: 'Detecção Frida',
                    icon: Icons.bug_report,
                    description: 'Detecta frameworks de instrumentação dinâmica como Frida',
                    testResult: testResults['Frida'],
                    isRunning: testResults['Frida']?.isRunning ?? false,
                    onTest: () => ref.read(securityTestProvider.notifier).runDetectorTest('Frida'),
                  ),
                  const SizedBox(height: 16),
                  SecurityCard(
                    title: 'Detecção Root/Jailbreak',
                    icon: Icons.admin_panel_settings,
                    description: 'Verifica se o dispositivo foi comprometido (root/jailbreak)',
                    testResult: testResults['Root/Jailbreak'],
                    isRunning: testResults['Root/Jailbreak']?.isRunning ?? false,
                    onTest: () => ref.read(securityTestProvider.notifier).runDetectorTest('Root/Jailbreak'),
                  ),
                  const SizedBox(height: 16),
                  SecurityCard(
                    title: 'Detecção Emulador',
                    icon: Icons.phone_android,
                    description: 'Identifica se está executando em emulador/simulador',
                    testResult: testResults['Emulator'],
                    isRunning: testResults['Emulator']?.isRunning ?? false,
                    onTest: () => ref.read(securityTestProvider.notifier).runDetectorTest('Emulator'),
                  ),
                  const SizedBox(height: 16),
                  SecurityCard(
                    title: 'Detecção Debugger',
                    icon: Icons.code,
                    description: 'Detecta debuggers anexados ao processo',
                    testResult: testResults['Debugger'],
                    isRunning: testResults['Debugger']?.isRunning ?? false,
                    onTest: () => ref.read(securityTestProvider.notifier).runDetectorTest('Debugger'),
                  ),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => ref.read(securityTestProvider.notifier).clearResults(),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.refresh),
        label: const Text('Limpar'),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, SecuritySummary summary) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: summary.threatsDetected > 0 ? AppColors.warningGradient : AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    summary.threatsDetected > 0 ? Icons.warning : Icons.shield,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resumo de Segurança',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        summary.overallStatus,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: summary.threatsDetected > 0 ? AppColors.error : AppColors.success,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
                if (summary.isRunning)
                  const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
              ],
            ),
            if (summary.totalTests > 0) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryItem(
                      context,
                      'Testes Executados',
                      '${summary.completedTests}/${summary.totalTests}',
                      Icons.check_circle_outline,
                      AppColors.info,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryItem(
                      context,
                      'Ambiente Seguro',
                      '${summary.secureTests}',
                      Icons.shield,
                      AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryItem(
                      context,
                      'Ameaças',
                      '${summary.threatsDetected}',
                      Icons.warning,
                      AppColors.error,
                    ),
                  ),
                ],
              ),
              if (summary.completedTests > 0) ...[
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: summary.completionPercentage / 100,
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    summary.threatsDetected > 0 ? AppColors.error : AppColors.success,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${summary.completionPercentage.toInt()}% Completo',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
