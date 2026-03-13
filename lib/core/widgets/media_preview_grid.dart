import 'dart:io';
import 'package:flutter/material.dart';
import '../../funcionalidades/reportes/dominio/entidades/media_item.dart';
import '../constantes/cores.dart';
import 'media_fullscreen_viewer.dart';

/// Grid horizontal de thumbnails de mídia com suporte a remoção e
/// visualização em tela cheia.
///
/// Extraído do `SeletorMidiaWidget` para reutilização e separação
/// de responsabilidades.
class MediaPreviewGrid extends StatelessWidget {
  /// Lista de mídias a exibir.
  final List<MediaItem> midias;

  /// Callback quando o usuário remove um item.
  final ValueChanged<List<MediaItem>>? onChanged;

  /// Altura da grade de thumbnails.
  final double altura;

  /// Se true, mostra botão de remoção nos thumbnails.
  final bool editavel;

  const MediaPreviewGrid({
    super.key,
    required this.midias,
    this.onChanged,
    this.altura = 100,
    this.editavel = true,
  });

  @override
  Widget build(BuildContext context) {
    if (midias.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: altura,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: midias.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (ctx, index) => _buildThumbnail(context, index),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context, int index) {
    final item = midias[index];
    final bool isImage = item.type == MediaType.image;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => MediaFullscreenViewer.abrir(
        context,
        midias: midias,
        initialIndex: index,
      ),
      child: Stack(
        children: [
          // ── Conteúdo do thumbnail ──
          Container(
            width: altura,
            height: altura,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppCores.neonBlue.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: isImage && item.filePath != null
                ? Image.file(
                    File(item.filePath!),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        _buildPlaceholderIcon(isImage),
                  )
                : _buildPlaceholderIcon(isImage),
          ),

          // ── Badge de tipo ──
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isImage ? Icons.image : Icons.play_circle_fill,
                    color: Colors.white70,
                    size: 12,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    isImage ? 'IMG' : 'VID',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Ícone de zoom ──
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.zoom_in,
                color: Colors.white70,
                size: 14,
              ),
            ),
          ),

          // ── Botão remover ──
          if (editavel && onChanged != null)
            Positioned(
              top: -2,
              right: -2,
              child: GestureDetector(
                onTap: () {
                  final novaLista = List<MediaItem>.from(midias)
                    ..removeAt(index);
                  onChanged!(novaLista);
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderIcon(bool isImage) {
    return Container(
      color: AppCores.lightGray,
      child: Center(
        child: Icon(
          isImage ? Icons.image_outlined : Icons.videocam_outlined,
          color: AppCores.neonBlue.withValues(alpha: 0.6),
          size: 36,
        ),
      ),
    );
  }
}
