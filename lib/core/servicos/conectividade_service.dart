import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Callback chamado quando a conectividade muda.
typedef OnConectividadeMudou = void Function(bool conectado);

/// Serviço singleton de monitoramento de conectividade.
///
/// Monitora mudanças de rede e notifica os ouvintes quando a conexão
/// é restaurada, permitindo sincronização de dados com o Firebase.
class ConectividadeService {
  static final ConectividadeService _instancia =
      ConectividadeService._interno();

  factory ConectividadeService() => _instancia;
  ConectividadeService._interno();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _conectado = true;
  bool get conectado => _conectado;

  final List<OnConectividadeMudou> _ouvintes = [];

  /// Inicializa o monitoramento de conectividade.
  ///
  /// Deve ser chamado uma vez no `main()` ou no widget raiz.
  Future<void> inicializar() async {
    // Verifica estado inicial
    final resultado = await _connectivity.checkConnectivity();
    _conectado = _isConectado(resultado);

    // Escuta mudanças
    _subscription = _connectivity.onConnectivityChanged.listen((resultado) {
      final novoEstado = _isConectado(resultado);

      if (novoEstado != _conectado) {
        _conectado = novoEstado;
        debugPrint(
          '🌐 Conectividade: ${_conectado ? "ONLINE" : "OFFLINE"}',
        );

        for (final ouvinte in _ouvintes) {
          ouvinte(_conectado);
        }
      }
    });
  }

  /// Adiciona um ouvinte de mudanças de conectividade.
  void adicionarOuvinte(OnConectividadeMudou ouvinte) {
    _ouvintes.add(ouvinte);
  }

  /// Remove um ouvinte.
  void removerOuvinte(OnConectividadeMudou ouvinte) {
    _ouvintes.remove(ouvinte);
  }

  /// Verifica se alguma conexão está ativa.
  bool _isConectado(List<ConnectivityResult> resultado) {
    return resultado.any(
      (r) => r != ConnectivityResult.none,
    );
  }

  /// Libera recursos.
  void dispose() {
    _subscription?.cancel();
    _ouvintes.clear();
  }
}
