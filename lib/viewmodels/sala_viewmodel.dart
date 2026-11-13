import 'package:projeto_inventario_patrimonial_frontend/models/sala.dart';
import 'package:projeto_inventario_patrimonial_frontend/repositories/sala_repository.dart';

class SalaViewModel {
  final SalaRepository _repository;

  SalaViewModel({SalaRepository? repository})
    : _repository = repository ?? SalaRepository();

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
      _salas = await _repository.listarSalas();
    } catch (e) {
      _erro = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _carregando = false;
    }
  }

  Future<void> carregarSalasDaSecretaria(String secretariaId) async {
    _carregando = true;
    _erro = null;
    _salas = [];

    try {
      _salas = await _repository.listarSalasDaSecretaria(secretariaId);
    } catch (e) {
      _erro = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _carregando = false;
    }
  }
}
