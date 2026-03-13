import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constantes/cores.dart';
import '../../funcionalidades/reportes/dominio/entidades/media_item.dart';
<<<<<<< HEAD
import 'media_preview_grid.dart';
=======
//import '../../../../../../core/widgets/seletor_midia_widget.dart';
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f

/// Widget reutilizável para seleção de mídias (fotos e vídeos) em formulários
/// de reporte.
///
/// Oferece 3 opções de captura:
/// - 📷 Câmera — tira uma foto diretamente
/// - 🖼️ Galeria — seleciona imagem(ns) da galeria
/// - 🎥 Vídeo — seleciona ou grava um vídeo
///
<<<<<<< HEAD
/// Exibe uma grade de thumbnails via [MediaPreviewGrid], com suporte a
/// visualização em tela cheia ao clicar.
=======
/// Exibe uma grade de thumbnails com preview real e botão de remoção.
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
///
/// ```dart
/// SeletorMidiaWidget(
///   midias: _minhasMidias,
///   onChanged: (novaLista) => setState(() => _minhasMidias = novaLista),
/// )
/// ```
class SeletorMidiaWidget extends StatelessWidget {
  /// Lista atual de mídias selecionadas.
  final List<MediaItem> midias;

  /// Callback disparado sempre que a lista é alterada (adição ou remoção).
  final ValueChanged<List<MediaItem>> onChanged;

  /// Quantidade máxima de arquivos permitidos.
  final int maxItems;

  /// Título exibido acima dos botões.
  final String titulo;

  const SeletorMidiaWidget({
    super.key,
    required this.midias,
    required this.onChanged,
    this.maxItems = 5,
    this.titulo = 'Mídia (imagens ou vídeos)',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Título da seção ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              titulo,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${midias.length} / $maxItems',
              style: TextStyle(
                color: midias.length >= maxItems
                    ? Colors.redAccent
                    : Colors.white54,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ── Botões de ação ──
        Row(
          children: [
            _buildBotao(
              context: context,
              icon: Icons.camera_alt_rounded,
              label: 'Câmera',
              onPressed: midias.length >= maxItems
                  ? null
                  : () => _capturarDaCamera(context),
            ),
            const SizedBox(width: 8),
            _buildBotao(
              context: context,
              icon: Icons.photo_library_rounded,
              label: 'Galeria',
              onPressed: midias.length >= maxItems
                  ? null
                  : () => _selecionarDaGaleria(context),
            ),
            const SizedBox(width: 8),
            _buildBotao(
              context: context,
              icon: Icons.videocam_rounded,
              label: 'Vídeo',
              onPressed: midias.length >= maxItems
                  ? null
                  : () => _selecionarVideo(context),
            ),
          ],
        ),

<<<<<<< HEAD
        // ── Grade de thumbnails (delegada ao MediaPreviewGrid) ──
        if (midias.isNotEmpty) ...[
          const SizedBox(height: 16),
          MediaPreviewGrid(
            midias: midias,
            onChanged: onChanged,
=======
        // ── Grade de thumbnails ──
        if (midias.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: midias.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (ctx, index) => _buildThumbnail(context, index),
            ),
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
          ),
        ],
      ],
    );
  }

<<<<<<< HEAD
  // ──────────────────────────────────────────────────────────
  // Ações de captura / seleção
  // ──────────────────────────────────────────────────────────
=======
  // ────────────────────────────────────────────────────────────────────────────
  // Ações de captura / seleção
  // ────────────────────────────────────────────────────────────────────────────
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f

  Future<void> _capturarDaCamera(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? foto = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1920,
    );

    if (foto != null) {
      final novaLista = List<MediaItem>.from(midias)
        ..add(
          MediaItem.fromFile(
            filePath: foto.path,
            type: MediaType.image,
            nomeArquivo: foto.name,
          ),
        );
      onChanged(novaLista);
    }
  }

  Future<void> _selecionarDaGaleria(BuildContext context) async {
    final picker = ImagePicker();
    final List<XFile> imagens = await picker.pickMultiImage(
      imageQuality: 80,
      maxWidth: 1920,
    );

    if (imagens.isNotEmpty) {
      final novaLista = List<MediaItem>.from(midias);
      for (final img in imagens) {
        if (novaLista.length >= maxItems) break;
        novaLista.add(
          MediaItem.fromFile(
            filePath: img.path,
            type: MediaType.image,
            nomeArquivo: img.name,
          ),
        );
      }
      onChanged(novaLista);
    }
  }

  Future<void> _selecionarVideo(BuildContext context) async {
    final theme = Theme.of(context);
    final picker = ImagePicker();

    // Mostra bottom sheet para escolher origem do vídeo
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Selecionar vídeo',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.videocam, color: AppCores.neonBlue),
                title: Text(
                  'Gravar vídeo',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                onTap: () => Navigator.pop(ctx, ImageSource.camera),
              ),
              ListTile(
                leading: Icon(
                  Icons.video_library,
                  color: theme.colorScheme.onSurface,
                ),
                title: Text(
                  'Escolher da galeria',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

    final XFile? video = await picker.pickVideo(
      source: source,
      maxDuration: const Duration(minutes: 2),
    );

    if (video != null) {
      final novaLista = List<MediaItem>.from(midias)
        ..add(
          MediaItem.fromFile(
            filePath: video.path,
            type: MediaType.video,
            nomeArquivo: video.name,
          ),
        );
      onChanged(novaLista);
    }
  }

<<<<<<< HEAD
  // ──────────────────────────────────────────────────────────
  // Widgets privados
  // ──────────────────────────────────────────────────────────
=======
  // ────────────────────────────────────────────────────────────────────────────
  // Widgets privados
  // ────────────────────────────────────────────────────────────────────────────
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f

  Widget _buildBotao({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    final bool desabilitado = onPressed == null;

    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: desabilitado
              ? Colors.white24
              : Theme.of(context).colorScheme.onSurface,
          size: 20,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: desabilitado
                ? Colors.white24
                : Theme.of(context).colorScheme.onSurface,
            fontSize: 13,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: desabilitado
                  ? Colors.white10
                  : AppCores.neonBlue.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

  Widget _buildThumbnail(BuildContext context, int index) {
    final item = midias[index];
    final bool isImage = item.type == MediaType.image;
    final theme = Theme.of(context);

    return Stack(
      children: [
        // ── Conteúdo do thumbnail ──
        Container(
          width: 100,
          height: 100,
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
                  errorBuilder: (_, _, _) => _buildPlaceholderIcon(isImage),
                )
              : _buildPlaceholderIcon(isImage),
        ),

        // ── Badge de tipo (canto inferior esquerdo) ──
        Positioned(
          bottom: 4,
          left: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isImage ? Icons.image : Icons.play_circle_fill,
                  color: theme.colorScheme.onSurface,
                  size: 12,
                ),
                const SizedBox(width: 3),
                Text(
                  isImage ? 'IMG' : 'VID',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Botão remover (canto superior direito) ──
        Positioned(
          top: -2,
          right: -2,
          child: GestureDetector(
            onTap: () {
              final novaLista = List<MediaItem>.from(midias)..removeAt(index);
              onChanged(novaLista);
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.close,
                color: theme.colorScheme.onSurface,
                size: 14,
              ),
            ),
          ),
        ),
      ],
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
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
}
