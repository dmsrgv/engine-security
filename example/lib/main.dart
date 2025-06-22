import 'package:flutter/material.dart';
import 'package:engine_security/engine_security.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Engine Security GPS Fake Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'GPS Fake Detection Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final EngineGpsFakeDetector _gpsDetector = EngineGpsFakeDetector();
  SecurityCheckModel? _lastResult;
  bool _isChecking = false;

  Future<void> _checkGpsFake() async {
    setState(() {
      _isChecking = true;
    });

    try {
      final result = await _gpsDetector.performCheck();
      setState(() {
        _lastResult = result;
        _isChecking = false;
      });
    } catch (e) {
      setState(() {
        _lastResult = SecurityCheckModel.threat(
          threatType: SecurityThreatType.gpsFake,
          details: 'Erro ao verificar GPS Fake: $e',
          detectionMethod: 'Error Handler',
        );
        _isChecking = false;
      });
    }
  }

  Widget _buildResultCard() {
    if (_lastResult == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Nenhuma verificação realizada ainda'),
        ),
      );
    }

    final result = _lastResult!;
    final isSecure = result.isSecure;

    return Card(
      color: isSecure ? Colors.green[50] : Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSecure ? Icons.security : Icons.warning,
                  color: isSecure ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  isSecure ? 'GPS Seguro' : 'GPS Fake Detectado!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isSecure ? Colors.green[700] : Colors.red[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (result.details != null) ...[
              Text(
                'Detalhes:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                result.details!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
            ],
            if (result.detectionMethod != null) ...[
              Text(
                'Método de Detecção:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                result.detectionMethod!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                Text(
                  'Confiança: ',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  '${(result.confidence * 100).toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (result.timestamp != null) ...[
              const SizedBox(height: 4),
              Text(
                'Verificado em: ${result.timestamp!.toLocal().toString().split('.')[0]}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detector de GPS Fake',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Este detector verifica se o usuário está usando aplicativos de GPS falso ou manipulando a localização do dispositivo.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          _gpsDetector.isAvailable ? Icons.check_circle : Icons.error,
                          color: _gpsDetector.isAvailable ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _gpsDetector.isAvailable
                              ? 'Detector disponível nesta plataforma'
                              : 'Detector não disponível nesta plataforma',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isChecking || !_gpsDetector.isAvailable ? null : _checkGpsFake,
              icon: _isChecking
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.gps_fixed),
              label: Text(_isChecking ? 'Verificando...' : 'Verificar GPS Fake'),
            ),
            const SizedBox(height: 24),
            Text(
              'Resultado da Verificação',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildResultCard(),
          ],
        ),
      ),
    );
  }
}
