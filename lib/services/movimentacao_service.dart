import 'package:projeto_inventario_patrimonial_frontend/data/network/api_requester.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/movimentacao.dart';

class MovimentacaoService {
  final ApiRequester _requester;

  MovimentacaoService({ApiRequester? requester})
    : _requester = requester ?? ApiRequester();

  Future<List<Movimentacao>> listarPorPatrimonio(String patrimonioId) async {
    final dados = await _requester.get(
      '/movimentacoes',
      queryParameters: {'patrimonio': patrimonioId},
    );

    return _converterLista(dados);
  }

  List<Movimentacao> _converterLista(dynamic dados) {
    final List<dynamic> lista;

    if (dados is List) {
      lista = dados;
    } else if (dados is Map && dados['dados'] is List) {
      lista = dados['dados'] as List;
    } else if (dados is Map && dados['data'] is List) {
      lista = dados['data'] as List;
    } else {
      throw Exception('A API retornou uma lista em formato inválido.');
    }

    return lista
        .map<Movimentacao>(
          (item) => Movimentacao.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> criarTransferencia({
    required String patrimonioId,
    required String secretariaDestinoId,
    required String motivo,
    required String justificativa,
  }) async {
    await _requester.post(
      '/movimentacoes',
      dados: {
        'patrimonioId': patrimonioId,
        'tipo': 'transferencia',
        'dados': {
          'secretariaDestino': secretariaDestinoId,
          'motivo': motivo,
          'justificativa': justificativa,
        },
      },
    );
  }

  Future<void> cancelarTransferencia(String movimentacaoId) async {
    await _requester.patch(
      '/movimentacoes/$movimentacaoId/cancelar',
      dados: {},
    );
  }

  Future<List<Movimentacao>> listarRecebimentosPendentes() async {
    final dados = await _requester.get('/movimentacoes/recebimentos');

    return _converterLista(dados);
  }

  Future<void> receberTransferencia({
    required String movimentacaoId,
    required String salaDestinoId,
  }) async {
    await _requester.patch(
      '/movimentacoes/$movimentacaoId/receber',
      dados: {'salaDestinoId': salaDestinoId},
    );
  }

  /// Registra uma conferência (gera histórico e atualiza status/estado do bem).
  Future<void> registrarConferencia({
    required String patrimonioId,
    required String status,
    required String estadoConservacao,
    required String observacoes,
  }) async {
    await _requester.post(
      '/movimentacoes',
      dados: {
        'patrimonioId': patrimonioId,
        'tipo': 'conferencia',
        'dados': {
          'status': status,
          'estadoConservacao': estadoConservacao,
          'observacoes': observacoes,
        },
      },
    );
  }

  /// Troca o bem de sala dentro da mesma secretaria (gera histórico).
  Future<void> atualizarLocalizacao({
    required String patrimonioId,
    required String salaDestinoId,
  }) async {
    await _requester.post(
      '/movimentacoes',
      dados: {
        'patrimonioId': patrimonioId,
        'tipo': 'atualizacao_localizacao',
        'dados': {'salaDestino': salaDestinoId, 'motivo': 'Troca de sala'},
      },
    );
  }
}
