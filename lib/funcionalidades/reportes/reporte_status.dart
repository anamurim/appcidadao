/// Status possíveis de um reporte urbano.
enum ReporteStatus {
  pendente,
  enviado,
  emAnalise,
  resolvido;

  /// Retorna um rótulo amigável para exibição na UI.
  String get rotulo {
    switch (this) {
      case ReporteStatus.pendente:
        return 'Pendente';
      case ReporteStatus.enviado:
        return 'Enviado';
      case ReporteStatus.emAnalise:
        return 'Em Análise';
      case ReporteStatus.resolvido:
        return 'Resolvido';
    }
  }
}
