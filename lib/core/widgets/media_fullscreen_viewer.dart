import 'dart:io';
import 'package:flutter/material.dart';
import '../../funcionalidades/reportes/dominio/entidades/media_item.dart';
import '../constantes/cores.dart';

/// Visualizador de mídia em tela cheia com suporte a zoom e navegação.
///
/// Exibe imagens com pinch-to-zoom e swipe horizontal para navegar
/// entre múltiplas mídias.
class MediaFullscreenViewer extends StatefulWidget {
  final List<MediaItem> midias;
  final int initialIndex;

  const MediaFullscreenViewer({
    super.key,
    required this.midias,
    this.initialIndex = 0,
  });

  /// Abre o visualizador como uma rota fullscreen.
  static void abrir(
    BuildContext context, {
    required List<MediaItem> midias,
    int initialIndex = 0,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaFullscreenViewer(
          midias: midias,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  State<MediaFullscreenViewer> createState() => _MediaFullscreenViewerState();
}

class _MediaFullscreenViewerState extends State<MediaFullscreenViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${_currentIndex + 1} / ${widget.midias.length}',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.midias.length,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemBuilder: (context, index) {
          final item = widget.midias[index];
          return _buildMediaPage(item);
        },
      ),
      bottomNavigationBar: widget.midias.length > 1
          ? _buildIndicator()
          : null,
    );
  }

  Widget _buildMediaPage(MediaItem item) {
    if (item.type == MediaType.image && item.filePath != null) {
      return InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(
          child: Image.file(
            File(item.filePath!),
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => _buildPlaceholder(Icons.broken_image),
          ),
        ),
      );
    }

    // Placeholder para vídeos (sem player embutido)
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.videocam_outlined,
            color: AppCores.neonBlue,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            item.nomeArquivo ?? 'Vídeo',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          const Text(
            'Visualização de vídeo não disponível',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(IconData icon) {
    return Center(
      child: Icon(icon, color: Colors.white38, size: 64),
    );
  }

  Widget _buildIndicator() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.midias.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _currentIndex == index ? 24 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: _currentIndex == index
                  ? AppCores.neonBlue
                  : Colors.white24,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}
