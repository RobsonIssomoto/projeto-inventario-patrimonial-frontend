import 'package:projeto_inventario_patrimonial_frontend/models/sala.dart';
import 'package:projeto_inventario_patrimonial_frontend/services/sala_service.dart';

class SalaViewModel {
  final SalaService _salaService = SalaService();

  List<Sala> _salas = [];
  bool _carregando = false;
  String? _erro;

  List<Sala> get salas => _salas;
  bool get carregando => _carregando;
  String? get erro => _erro;

  Future<void> carregarSalas() async {
    _carregando = true;
    _erro = null;

    try {
      _salas = await _salaService.listarSalas();
    } catch (e) {
      _erro = e.toString();
    } finally {
      _carregando = false;
    }
  }
}
