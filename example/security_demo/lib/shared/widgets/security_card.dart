import 'package:engine_security/engine_security.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../models/detector_test_result.dart';

class SecurityCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final DetectorTestResult? testResult;
  final VoidCallback? onTest;
  final bool isRunning;

  const SecurityCard({
    super.key,
    required this.title,
    required this.icon,
    required this.description,
    this.testResult,
    this.onTest,
    this.isRunning = false,
  });

  @override
  Widget build(BuildContext context) {
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
                    gradient: _getIconGradient(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
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
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                _buildStatusIcon(),
              ],
            ),
            const SizedBox(height: 20),
            if (testResult != null) ...[
              _buildTestResults(context),
              const SizedBox(height: 16),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isRunning ? null : onTest,
                child: isRunning
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Testando...'),
                        ],
                      )
                    : const Text('Executar Teste'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    if (isRunning) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    if (testResult == null) {
      return const Icon(
        Icons.help_outline,
        color: AppColors.onSurfaceVariant,
        size: 20,
      );
    }

    return Icon(
      testResult!.result.isSecure ? Icons.check_circle : Icons.warning,
      color: testResult!.result.isSecure ? AppColors.success : AppColors.error,
      size: 20,
    );
  }

  Widget _buildTestResults(BuildContext context) {
    if (testResult == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: testResult!.result.isSecure ? AppColors.success.withOpacity(0.3) : AppColors.error.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                testResult!.result.isSecure ? Icons.shield : Icons.warning,
                color: testResult!.result.isSecure ? AppColors.success : AppColors.error,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                testResult!.statusDescription,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: testResult!.result.isSecure ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildResultRow(
            context,
            'Detalhes:',
            testResult!.result.details ?? 'Nenhum detalhe disponível',
          ),
          const SizedBox(height: 8),
          _buildResultRow(
            context,
            'Confiança:',
            '${testResult!.confidencePercentage} (${testResult!.confidenceDescription})',
          ),
          const SizedBox(height: 8),
          _buildResultRow(
            context,
            'Método:',
            testResult!.result.detectionMethod ?? 'Não especificado',
          ),
          const SizedBox(height: 8),
          _buildResultRow(
            context,
            'Tempo:',
            '${testResult!.executionTime.inMilliseconds}ms',
          ),
          if (testResult!.result.threatType != SecurityThreatType.unknown) ...[
            const SizedBox(height: 8),
            _buildResultRow(
              context,
              'Severidade:',
              '${testResult!.result.threatType.severityLevel}/10',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  LinearGradient _getIconGradient() {
    if (testResult != null && !testResult!.result.isSecure) {
      return AppColors.warningGradient;
    }
    if (testResult != null && testResult!.result.isSecure) {
      return AppColors.accentGradient;
    }
    return AppColors.primaryGradient;
  }
}
