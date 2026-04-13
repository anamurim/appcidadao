/// Status possíveis de um reporte urbano.
enum ReporteStatus {
  pendente,
  enviado,
  emAnalise,
  rejeitado,
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
      case ReporteStatus.rejeitado:
        return 'Rejeitado';
      case ReporteStatus.resolvido:
        return 'Resolvido';
    }
  }
}
