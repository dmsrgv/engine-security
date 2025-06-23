import 'package:engine_security/engine_security.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CertificatePinningDemo extends StatefulWidget {
  const CertificatePinningDemo({super.key});

  @override
  State<CertificatePinningDemo> createState() => _CertificatePinningDemoState();
}

class _CertificatePinningDemoState extends State<CertificatePinningDemo> {
  String _testResult = 'Aguardando teste...';
  String _detectorResult = 'Não verificado';
  bool _isLoading = false;
  final List<String> _validationLogs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Certificate Pinning Demo'), backgroundColor: Colors.blueGrey[800]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card com informações sobre o certificate pinning
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.https, color: Colors.green[600], size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'Certificate Pinning Configurado',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('Hostname: stmr.tech'),
                    const Text('Pin (SHA-256 Hex): 17a8d38a1f559246194bccae62a794ff...'),
                    const Text('Enforcement: Ativo'),
                    const Text('Subdomínios: Desabilitado'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card com resultado do detector
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Status do Detector', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(_detectorResult),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card com resultado do teste
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Resultado do Teste HTTPS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(_testResult),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Logs de validação
            if (_validationLogs.isNotEmpty)
              Expanded(
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Logs de Validação', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _validationLogs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.0),
                                child: Text(
                                  _validationLogs[index],
                                  style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // Botões de ação
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _runDetectorTest,
                    icon: _isLoading
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.security),
                    label: const Text('Testar Detector'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[600], foregroundColor: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _testHttpsConnection,
                    icon: _isLoading
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.https),
                    label: const Text('Testar HTTPS'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green[600], foregroundColor: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _clearLogs,
              icon: const Icon(Icons.clear),
              label: const Text('Limpar Logs'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[600], foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _runDetectorTest() async {
    setState(() {
      _isLoading = true;
      _detectorResult = 'Executando detector...';
    });

    try {
      final detector = EngineHttpsPinningDetector();
      final result = await detector.performCheck();

      setState(() {
        _detectorResult = result.isSecure
            ? '✅ CONFIGURADO - Certificate pinning ativo'
            : '❌ NÃO CONFIGURADO - ${result.details}';
        _validationLogs.add(
          '[${DateTime.now().toIso8601String()}] Detector: ${result.isSecure ? 'OK' : 'FALHA'} - ${result.details}',
        );
      });
    } catch (e) {
      setState(() {
        _detectorResult = '❌ ERRO - $e';
        _validationLogs.add('[${DateTime.now().toIso8601String()}] Erro no detector: $e');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testHttpsConnection() async {
    setState(() {
      _isLoading = true;
      _testResult = 'Conectando com stmr.tech...';
    });

    try {
      final response = await http
          .get(Uri.parse('https://stmr.tech'), headers: {'User-Agent': 'EngineSecurityDemo/1.0'})
          .timeout(const Duration(seconds: 10));

      setState(() {
        _testResult =
            '✅ SUCESSO - Código: ${response.statusCode}\n'
            'Tamanho: ${response.body.length} bytes\n'
            'Certificate pinning funcionando!';
        _validationLogs.add('[${DateTime.now().toIso8601String()}] HTTPS: Sucesso ${response.statusCode}');
      });
    } catch (e) {
      setState(() {
        _testResult =
            '❌ FALHA - $e\n'
            'Possível causa: Certificate pinning bloqueou a conexão ou erro de rede.';
        _validationLogs.add('[${DateTime.now().toIso8601String()}] HTTPS: Falha - $e');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearLogs() {
    setState(() {
      _validationLogs.clear();
      _testResult = 'Aguardando teste...';
      _detectorResult = 'Não verificado';
    });
  }
}
