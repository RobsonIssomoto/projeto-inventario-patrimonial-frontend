import 'package:projeto_inventario_patrimonial_frontend/models/secretaria.dart';
import 'package:projeto_inventario_patrimonial_frontend/services/secretaria_service.dart';

class SecretariaRepository {
  final SecretariaService _service;

  SecretariaRepository({SecretariaService? service})
    : _service = service ?? SecretariaService();

  Future<List<Secretaria>> listarSecretarias() {
    return _service.listarSecretarias();
  }
}
