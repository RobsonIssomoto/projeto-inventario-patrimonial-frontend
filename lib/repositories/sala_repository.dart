import 'package:projeto_inventario_patrimonial_frontend/models/sala.dart';
import 'package:projeto_inventario_patrimonial_frontend/services/sala_service.dart';

class SalaRepository {
  final SalaService _service;

  SalaRepository({SalaService? service}) : _service = service ?? SalaService();

  Future<List<Sala>> listarSalas() {
    return _service.listarSalas();
  }

  Future<List<Sala>> listarSalasDaSecretaria(String secretariaId) {
    return _service.listarSalasDaSecretaria(secretariaId);
  }

  Future<List<Sala>> buscarSalasDaSecretaria(String secretariaId) {
    return _service.listarSalasDaSecretaria(secretariaId);
  }
}
