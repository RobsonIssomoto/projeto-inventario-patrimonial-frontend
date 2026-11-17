import 'package:projeto_inventario_patrimonial_frontend/models/movimentacao.dart';
import 'package:projeto_inventario_patrimonial_frontend/services/movimentacao_service.dart';

class MovimentacaoRepository {
  final MovimentacaoService _service;

  MovimentacaoRepository({MovimentacaoService? service})
    : _service = service ?? MovimentacaoService();

  Future<List<Movimentacao>> listarPorPatrimonio(String patrimonioId) {
    return _service.listarPorPatrimonio(patrimonioId);
  }

  Future<void> criarTransferencia({
    required String patrimonioId,
    required String secretariaDestinoId,
    required String motivo,
    required String justificativa,
  }) {
    return _service.criarTransferencia(
      patrimonioId: patrimonioId,
      secretariaDestinoId: secretariaDestinoId,
      motivo: motivo,
      justificativa: justificativa,
    );
  }

  Future<void> cancelarTransferencia(String movimentacaoId) {
    return _service.cancelarTransferencia(movimentacaoId);
  }

  Future<List<Movimentacao>> listarRecebimentosPendentes() {
    return _service.listarRecebimentosPendentes();
  }

  Future<void> receberTransferencia({
    required String movimentacaoId,
    required String salaDestinoId,
  }) {
    return _service.receberTransferencia(
      movimentacaoId: movimentacaoId,
      salaDestinoId: salaDestinoId,
    );
  }

  Future<void> registrarConferencia({
    required String patrimonioId,
    required String status,
    required String estadoConservacao,
    required String observacoes,
  }) {
    return _service.registrarConferencia(
      patrimonioId: patrimonioId,
      status: status,
      estadoConservacao: estadoConservacao,
      observacoes: observacoes,
    );
  }

  Future<void> atualizarLocalizacao({
    required String patrimonioId,
    required String salaDestinoId,
  }) {
    return _service.atualizarLocalizacao(
      patrimonioId: patrimonioId,
      salaDestinoId: salaDestinoId,
    );
  }
}
