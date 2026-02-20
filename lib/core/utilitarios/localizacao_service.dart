import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocalizacaoService {
  /// Obtém o endereço legível a partir da localização atual do dispositivo.
  /// Retorna uma string com o endereço formatado ou lança uma exceção em caso de erro.
  static Future<String> obterEnderecoAtual() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Serviço de localização desativado';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw 'Permissão de localização negada';
    }
    if (permission == LocationPermission.deniedForever) {
      throw 'Permissão de localização negada permanentemente';
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isEmpty) {
        return '${position.latitude}, ${position.longitude}';
      }
      final p = placemarks.first;
      final parts = [p.street, p.subLocality, p.locality, p.administrativeArea, p.postalCode, p.country];
      final address = parts.where((s) => s != null && s.isNotEmpty).join(', ');
      return address.isNotEmpty ? address : '${position.latitude}, ${position.longitude}';
    } catch (e) {
      return '${position.latitude}, ${position.longitude}';
    }
  }
}
