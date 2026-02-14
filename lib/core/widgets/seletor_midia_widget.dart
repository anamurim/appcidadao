import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constantes/cores.dart';
import '../../funcionalidades/reportes/dominio/entidades/media_item.dart';

/// Widget reutilizável para seleção de mídias (fotos e vídeos) em formulários
/// de reporte.
///
/// Oferece 3 opções de captura:
/// - 📷 Câmera — tira uma foto diretamente
/// - 🖼️ Galeria — seleciona imagem(ns) da galeria
/// - 🎥 Vídeo — seleciona ou grava um vídeo
///
/// Exibe uma grade de thumbnails com preview real e botão de remoção.
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Título da seção ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                color: AppCores.neonBlue,
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
          ),
        ],
      ],
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Ações de captura / seleção
  // ────────────────────────────────────────────────────────────────────────────

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
    final picker = ImagePicker();

    // Mostra bottom sheet para escolher origem do vídeo
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppCores.lightGray,
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
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Selecionar vídeo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.videocam, color: AppCores.neonBlue),
                title: const Text(
                  'Gravar vídeo',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.pop(ctx, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(
                  Icons.video_library,
                  color: AppCores.neonBlue,
                ),
                title: const Text(
                  'Escolher da galeria',
                  style: TextStyle(color: Colors.white),
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

  // ────────────────────────────────────────────────────────────────────────────
  // Widgets privados
  // ────────────────────────────────────────────────────────────────────────────

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
          color: desabilitado ? Colors.white24 : AppCores.neonBlue,
          size: 20,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: desabilitado ? Colors.white24 : AppCores.neonBlue,
            fontSize: 13,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppCores.lightGray,
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

  Widget _buildThumbnail(BuildContext context, int index) {
    final item = midias[index];
    final bool isImage = item.type == MediaType.image;

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
              color: Colors.black87,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isImage ? Icons.image : Icons.play_circle_fill,
                  color: AppCores.neonBlue,
                  size: 12,
                ),
                const SizedBox(width: 3),
                Text(
                  isImage ? 'IMG' : 'VID',
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
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
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 14),
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
}
