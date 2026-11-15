import 'package:projeto_inventario_patrimonial_frontend/services/usuario_service.dart';

class UsuarioRepository {
  final UsuarioService _service;

  UsuarioRepository({UsuarioService? service})
    : _service = service ?? UsuarioService();

  Future<String> consultarPerfilAtual() {
    return _service.consultarPerfilAtual();
  }
}
