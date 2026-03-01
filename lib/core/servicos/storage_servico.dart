import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Serviço para upload de arquivos de mídia (fotos/vídeos) no Firebase Storage.
///
/// Os arquivos são organizados na estrutura:
///   reportes/{reporteId}/{nomeArquivo}
///
/// Retorna a URL de download público após o upload.
class StorageServico {
  final FirebaseStorage _storage;

  StorageServico({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  /// Faz upload de um arquivo e retorna a URL de download.
  ///
  /// [arquivo] — o File local (foto ou vídeo capturado pela câmera/galeria).
  /// [reporteId] — ID do reporte para organizar os arquivos em pastas.
  /// [nomeArquivo] — nome do arquivo (ex: 'foto_1.jpg').
  ///
  /// Retorna `null` se o upload falhar.
  Future<String?> uploadArquivo({
    required File arquivo,
    required String reporteId,
    String? nomeArquivo,
  }) async {
    try {
      final nome = nomeArquivo ?? arquivo.uri.pathSegments.last;
      final ref = _storage.ref().child('reportes/$reporteId/$nome');

      final metadata = SettableMetadata(
        contentType: _detectarContentType(nome),
      );

      final uploadTask = ref.putFile(arquivo, metadata);

      // Aguarda o upload completar
      final snapshot = await uploadTask;

      // Retorna a URL pública de download
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('❌ Erro no upload: $e');
      return null;
    }
  }

  /// Faz upload de múltiplos arquivos e retorna as URLs de download.
  Future<List<String>> uploadMultiplosArquivos({
    required List<File> arquivos,
    required String reporteId,
  }) async {
    final urls = <String>[];
    for (int i = 0; i < arquivos.length; i++) {
      final url = await uploadArquivo(
        arquivo: arquivos[i],
        reporteId: reporteId,
        nomeArquivo: 'midia_${i + 1}_${DateTime.now().millisecondsSinceEpoch}',
      );
      if (url != null) urls.add(url);
    }
    return urls;
  }

  /// Remove um arquivo do Storage pela URL de download.
  Future<void> removerArquivo(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
    } catch (e) {
      debugPrint('❌ Erro ao remover arquivo: $e');
    }
  }

  /// Detecta o content-type baseado na extensão do arquivo.
  String _detectarContentType(String nomeArquivo) {
    final ext = nomeArquivo.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      default:
        return 'application/octet-stream';
    }
  }
}
