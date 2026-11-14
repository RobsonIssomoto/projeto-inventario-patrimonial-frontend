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
}
