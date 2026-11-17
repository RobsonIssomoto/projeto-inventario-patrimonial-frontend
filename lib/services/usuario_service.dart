import 'package:projeto_inventario_patrimonial_frontend/data/network/api_requester.dart';

class UsuarioService {
  final ApiRequester _requester;

  UsuarioService({ApiRequester? requester})
    : _requester = requester ?? ApiRequester();

  Future<String> consultarPerfilAtual() async {
    final dados = await _requester.get('/usuarios/eu');

    if (dados is! Map || dados['perfil'] is! String) {
      throw Exception('A API retornou um perfil inválido.');
    }

    final perfil = dados['perfil'] as String;

    if (perfil != 'operador' &&
        perfil != 'gerente' &&
        perfil != 'administrador') {
      throw Exception('Perfil de usuário não reconhecido.');
    }

    return perfil;
  }

  /// Retorna os dados completos do usuário autenticado (GET /usuarios/eu).
  Future<Map<String, dynamic>> consultarUsuarioAtual() async {
    final dados = await _requester.get('/usuarios/eu');

    if (dados is! Map<String, dynamic>) {
      throw Exception('A API retornou os dados do usuário em formato inválido.');
    }

    return dados;
  }
}
