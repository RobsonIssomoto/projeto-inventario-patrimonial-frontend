import 'package:projeto_inventario_patrimonial_frontend/models/movimentacao.dart';
import 'package:projeto_inventario_patrimonial_frontend/repositories/movimentacao_repository.dart';

class RecebimentosViewModel {
  final MovimentacaoRepository _repository;

  RecebimentosViewModel({MovimentacaoRepository? repository})
    : _repository = repository ?? MovimentacaoRepository();

  List<Movimentacao> _recebimentos = [];
  bool _carregando = false;
  bool _recebendo = false;
  String? _erro;

  List<Movimentacao> get recebimentos => List.unmodifiable(_recebimentos);

  bool get carregando => _carregando;
  bool get recebendo => _recebendo;
  String? get erro => _erro;

  Future<void> carregar() async {
    _carregando = true;
    _erro = null;

    try {
      _recebimentos = await _repository.listarRecebimentosPendentes();
    } catch (erro) {
      _erro = erro.toString().replaceFirst('Exception: ', '');
    } finally {
      _carregando = false;
    }
  }

  Future<bool> receber({
    required String movimentacaoId,
    required String salaDestinoId,
  }) async {
    if (_recebendo) return false;

    _recebendo = true;
    _erro = null;

    try {
      await _repository.receberTransferencia(
        movimentacaoId: movimentacaoId,
        salaDestinoId: salaDestinoId,
      );

      _recebimentos.removeWhere(
        (movimentacao) => movimentacao.id == movimentacaoId,
      );

      return true;
    } catch (erro) {
      _erro = erro.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _recebendo = false;
    }
  }
}
