import 'package:projeto_inventario_patrimonial_frontend/data/network/api_requester.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/secretaria.dart';

class SecretariaService {
  final ApiRequester _requester = ApiRequester();

  Future<List<Secretaria>> listarSecretarias() async {
    final dados = await _requester.get('/secretarias');

    final lista = _extrairLista(dados);

    return lista
        .map((item) => Secretaria.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  List<dynamic> _extrairLista(dynamic dados) {
    if (dados is List) {
      return dados;
    }

    if (dados is Map && dados['dados'] is List) {
      return dados['dados'] as List;
    }

    if (dados is Map && dados['data'] is List) {
      return dados['data'] as List;
    }

    throw Exception('A API retornou uma lista em formato inválido.');
  }
}
