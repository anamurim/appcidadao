import 'package:flutter/material.dart';
import '../debug/firestore_debug_servico.dart';

/// 🧪 Widget de teste para verificar dados no Firestore
/// 
/// Use em um lugar apropriado (ex: tela de configurações, ou de forma temporária)
/// 
/// Exemplo de uso:
/// ```dart
/// // Na tela de home ou settings, adicione:
/// FloatingActionButton(
///   onPressed: () {
///     showDialog(
///       context: context,
///       builder: (_) => FirestoreDebugWidget(),
///     );
///   },
///   tooltip: 'Debug Firestore',
///   child: Icon(Icons.bug_report),
/// )
/// ```
class FirestoreDebugWidget extends StatefulWidget {
  const FirestoreDebugWidget({super.key});

  @override
  State<FirestoreDebugWidget> createState() => _FirestoreDebugWidgetState();
}

class _FirestoreDebugWidgetState extends State<FirestoreDebugWidget> {
  bool _carregando = false;
  String _resultado = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('🧪 Debug Firestore'),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 300, maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Clique em um botão para consultar dados no Firestore',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              _buildBotao(
                label: '📋 Ver Reportes',
                onPressed: () async {
                  setState(() => _carregando = true);
                  try {
                    final resultado = await FirestoreDebugServico.verificarReportes();
                    setState(() {
                      _resultado = resultado;
                    });
                  } catch (e) {
                    setState(() => _resultado = 'Erro: ${e.toString()}');
                  }
                  setState(() => _carregando = false);
                },
              ),
              const SizedBox(height: 10),
              _buildBotao(
                label: '👤 Ver Usuário',
                onPressed: () async {
                  setState(() => _carregando = true);
                  try {
                    await FirestoreDebugServico.verificarUsuarioAtual();
                    setState(() {
                      _resultado = 'Usuário carregado com sucesso! Verifique o console.';
                    });
                  } catch (e) {
                    setState(() => _resultado = 'Erro: ${e.toString()}');
                  }
                  setState(() => _carregando = false);
                },
              ),
              const SizedBox(height: 10),
              _buildBotao(
                label: '📊 Ver Estatísticas',
                onPressed: () async {
                  setState(() => _carregando = true);
                  try {
                    await FirestoreDebugServico.verificarEstatisticas();
                    setState(() {
                      _resultado = 'Estatísticas carregadas com sucesso! Verifique o console.';
                    });
                  } catch (e) {
                    setState(() => _resultado = 'Erro: ${e.toString()}');
                  }
                  setState(() => _carregando = false);
                },
              ),
              if (_resultado.isNotEmpty) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    _resultado,
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              const Text(
                '📍 Dados detalhados aparecem no console do terminal (veja os logs abaixo)',
                style: TextStyle(fontSize: 10, color: Colors.orange),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() => _resultado = '');
            Navigator.pop(context);
          },
          child: const Text('Fechar'),
        ),
      ],
    );
  }

  Widget _buildBotao({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: _carregando ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 45),
      ),
      child: _carregando
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label),
    );
  }
}
