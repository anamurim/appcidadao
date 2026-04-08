/// Tipos de mídia suportados pelo sistema de reportes.
enum MediaType { image, video }

/// Representa um item de mídia (foto ou vídeo) anexado a um reporte.
///
/// Armazena tanto o caminho local do arquivo ([filePath]) quanto uma URL
/// remota ([url]) para quando o arquivo for sincronizado com o servidor.
class MediaItem {
  /// Caminho absoluto do arquivo no dispositivo.
  final String? filePath;

  /// URL remota do arquivo (preenchida após upload ao servidor).
  final String url;

  /// Tipo da mídia: imagem ou vídeo.
  final MediaType type;

  /// Nome original do arquivo para exibição na UI.
  final String? nomeArquivo;

  const MediaItem({
    this.filePath,
    required this.url,
    required this.type,
    this.nomeArquivo,
  });

  /// Cria um MediaItem a partir de um arquivo local selecionado pelo usuário.
  factory MediaItem.fromFile({
    required String filePath,
    required MediaType type,
    String? nomeArquivo,
  }) {
    return MediaItem(
      filePath: filePath,
      url: filePath, // Usa o caminho local como URL até o upload remoto
      type: type,
      nomeArquivo: nomeArquivo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'filePath': filePath,
      'url': url,
      'type': type.name,
      'nomeArquivo': nomeArquivo,
    };
  }

  factory MediaItem.fromMap(Map<String, dynamic> map) {
    return MediaItem(
      filePath: map['filePath'] as String?,
      url: map['url'] as String,
      type: MediaType.values.byName(map['type'] as String),
      nomeArquivo: map['nomeArquivo'] as String?,
    );
  }
}
