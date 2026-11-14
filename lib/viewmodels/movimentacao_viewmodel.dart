import 'package:projeto_inventario_patrimonial_frontend/models/movimentacao.dart';
import 'package:projeto_inventario_patrimonial_frontend/repositories/movimentacao_repository.dart';

class MovimentacaoViewModel {
  final MovimentacaoRepository _repository;

  MovimentacaoViewModel({MovimentacaoRepository? repository})
    : _repository = repository ?? MovimentacaoRepository();

  List<Movimentacao> _movimentacoes = [];
  bool _carregando = false;
  String? _erro;

  List<Movimentacao> get movimentacoes => _movimentacoes;
  bool get carregando => _carregando;
  String? get erro => _erro;

  Future<void> carregarPorPatrimonio(String patrimonioId) async {
    _carregando = true;
    _erro = null;

    try {
      _movimentacoes = await _repository.listarPorPatrimonio(patrimonioId);
    } catch (erro) {
      _erro = erro.toString().replaceFirst('Exception: ', '');
    } finally {
      _carregando = false;
    }
  }

  Future<void> criarTransferencia({
    required String patrimonioId,
    required String secretariaDestinoId,
    required String motivo,
    required String justificativa,
  }) async {
    await _repository.criarTransferencia(
      patrimonioId: patrimonioId,
      secretariaDestinoId: secretariaDestinoId,
      motivo: motivo,
      justificativa: justificativa,
    );
  }
}
