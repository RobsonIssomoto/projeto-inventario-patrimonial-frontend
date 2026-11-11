import 'package:projeto_inventario_patrimonial_frontend/models/secretaria.dart';
import 'package:projeto_inventario_patrimonial_frontend/services/secretaria_service.dart';

class SecretariaViewModel {
  final SecretariaService _secretariaService = SecretariaService();

  List<Secretaria> _secretarias = [];
  bool _carregando = false;
  String? _erro;

  List<Secretaria> get secretarias => _secretarias;
  bool get carregando => _carregando;
  String? get erro => _erro;

  Future<void> carregarSecretarias() async {
    _carregando = true;
    _erro = null;

    try {
      _secretarias = await _secretariaService.listarSecretarias();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _carregando = false;
    }
  }
}
