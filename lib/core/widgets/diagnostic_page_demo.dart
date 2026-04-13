import 'package:flutter/material.dart';
import '../utilitarios/diagnostico_firebase_service.dart';

/// Página de diagnóstico para testar configuração do Firebase.
///
/// Use para verificar:
/// - Autenticação do usuário
/// - Permissões de Firestore
/// - Conexão com Firebase
class DiagnosticPageDemo extends StatefulWidget {
  const DiagnosticPageDemo({super.key});

  @override
  State<DiagnosticPageDemo> createState() => _DiagnosticPageDemoState();
}

class _DiagnosticPageDemoState extends State<DiagnosticPageDemo> {
  late Future<DiagnosticoRelatorio> _diagnostico;

  @override
  void initState() {
    super.initState();
    _diagnostico =
        DiagnosticoFirebaseService().diagnosticar();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnóstico Firebase'),
        centerTitle: true,
      ),
      body: FutureBuilder<DiagnosticoRelatorio>(
        future: _diagnostico,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao diagnosticar',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            );
          }

          final relatorio = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Status geral
                Card(
                  color: relatorio.tudoOk
                      ? Colors.green[50]
                      : Colors.red[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          relatorio.tudoOk
                              ? Icons.check_circle
                              : Icons.warning_amber_outlined,
                          color: relatorio.tudoOk
                              ? Colors.green
                              : Colors.red,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                relatorio.tudoOk
                                    ? '✅ Tudo OK!'
                                    : '⚠️ Problemas encontrados',
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: relatorio.tudoOk
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                relatorio.tudoOk
                                    ? 'Firebase configurado corretamente'
                                    : '${relatorio.problemas.length} problema(s) detectado(s)',
                                style:
                                    theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Autenticação
                _buildSection(
                  title: 'Autenticação',
                  items: [
                    _buildItem(
                      label: 'Usuário Autenticado',
                      value: relatorio.usuarioAutenticado,
                    ),
                    if (relatorio.email != null)
                      _buildItem(
                        label: 'Email',
                        value: relatorio.email!,
                        isText: true,
                      ),
                    if (relatorio.uid != null)
                      _buildItem(
                        label: 'UID',
                        value: relatorio.uid!,
                        isText: true,
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Permissões
                _buildSection(
                  title: 'Permissões Firestore',
                  items: [
                    _buildItem(
                      label: 'Escrita em /reportes',
                      value: relatorio.permissaoEscrita,
                    ),
                    _buildItem(
                      label: 'Leitura de /reportes',
                      value: relatorio.permissaoLeitura,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Conexão
                _buildSection(
                  title: 'Conexão',
                  items: [
                    _buildItem(
                      label: 'Firebase Conectado',
                      value: relatorio.firebaseConectado,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Problemas
                if (relatorio.problemas.isNotEmpty) ...[
                  _buildSection(
                    title: 'Problemas Detectados',
                    items: relatorio.problemas
                        .map(
                          (p) => Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            child: Text(
                              p,
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(
                                color:
                                    theme.colorScheme.error,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],

                const SizedBox(height: 24),

                // Botões de ação
                FilledButton.icon(
                  onPressed: () {
                    setState(() {
                      _diagnostico =
                          DiagnosticoFirebaseService()
                              .diagnosticar();
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Executar Novamente'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => _copiarRelatorio(relatorio),
                  child: const Text('Copiar Relatório'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> items,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required String label,
    required Object value,
    bool isText = false,
  }) {
    final theme = Theme.of(context);
    final isSuccess = isText ? true : (value as bool);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
          if (isText)
            Expanded(
              child: Align(
                alignment: Alignment.topRight,
                child: SelectableText(
                  value.toString(),
                  style: theme.textTheme.labelSmall,
                  textAlign: TextAlign.right,
                ),
              ),
            )
          else
            Icon(
              isSuccess ? Icons.check_circle : Icons.cancel,
              color: isSuccess ? Colors.green : Colors.red,
              size: 20,
            ),
        ],
      ),
    );
  }

  void _copiarRelatorio(DiagnosticoRelatorio relatorio) {
    final texto = relatorio.toString();
    // Nota: Em um app real, use package:flutter/services.dart Clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Relatório (veja no console)'),
        duration: const Duration(seconds: 2),
      ),
    );
    debugPrint(texto);
  }
}
