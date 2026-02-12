/// Tipos de mídia suportados pelo sistema de reportes.
enum MediaType { image, video }

/// Representa um item de mídia (foto ou vídeo) anexado a um reporte.
class MediaItem {
  final String url;
  final MediaType type;

  const MediaItem({required this.url, required this.type});

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'type': type.name,
    };
  }

  factory MediaItem.fromMap(Map<String, dynamic> map) {
    return MediaItem(
      url: map['url'] as String,
      type: MediaType.values.byName(map['type'] as String),
    );
  }
}
