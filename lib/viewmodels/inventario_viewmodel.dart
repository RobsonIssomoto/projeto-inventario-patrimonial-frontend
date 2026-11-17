import 'package:projeto_inventario_patrimonial_frontend/models/patrimonio.dart';
import 'package:projeto_inventario_patrimonial_frontend/repositories/movimentacao_repository.dart';
import 'package:projeto_inventario_patrimonial_frontend/repositories/patrimonio_repository.dart';

class InventarioViewModel {
  final PatrimonioRepository _repository = PatrimonioRepository();
  final MovimentacaoRepository _movimentacaoRepository =
      MovimentacaoRepository();

  List<Patrimonio> _patrimonios = [];

  Future<void> carregarPatrimonios() async {
    final patrimonios = await _repository.listarPatrimonios();

    _patrimonios = patrimonios;
  }

  List<String> listarSalas() {
    final salas = _patrimonios
        .map((patrimonio) => patrimonio.sala)
        .toSet()
        .toList();

    salas.sort();

    return salas;
  }

  List<String> listarCategorias() {
    final categorias = _patrimonios
        .map((patrimonio) => patrimonio.categoria)
        .toSet()
        .toList();

    categorias.sort();

    return categorias;
  }

  List<Patrimonio> buscarPatrimonios({
    String busca = '',
    String? sala,
    String? categoria,
    String ordenarPor = 'descricao',
  }) {
    final termo = busca.trim().toLowerCase();

    final resultado = _patrimonios.where((patrimonio) {
      final correspondeBusca =
          patrimonio.descricao.toLowerCase().contains(termo) ||
          patrimonio.numeroPatrimonio.toLowerCase().contains(termo);

      final correspondeSala = sala == null || patrimonio.sala == sala;

      final correspondeCategoria =
          categoria == null || patrimonio.categoria == categoria;

      return correspondeBusca && correspondeSala && correspondeCategoria;
    }).toList();

    if (ordenarPor == 'numero') {
      resultado.sort(
        (patrimonio, outroPatrimonio) => patrimonio.numeroPatrimonio
            .toLowerCase()
            .compareTo(outroPatrimonio.numeroPatrimonio.toLowerCase()),
      );
    } else {
      resultado.sort(
        (patrimonio, outroPatrimonio) => patrimonio.descricao
            .toLowerCase()
            .compareTo(outroPatrimonio.descricao.toLowerCase()),
      );
    }

    return resultado;
  }

  /// Salva a conferência e, se uma nova sala foi escolhida, a troca de sala.
  /// As duas operações passam por /movimentacoes para gerar o histórico.
  Future<void> atualizarPatrimonio({
    required String id,
    required String status,
    required String estadoConservacao,
    required String observacoes,
    String? salaId,
  }) async {
    await _movimentacaoRepository.registrarConferencia(
      patrimonioId: id,
      status: status,
      estadoConservacao: estadoConservacao,
      observacoes: observacoes,
    );

    if (salaId != null) {
      await _movimentacaoRepository.atualizarLocalizacao(
        patrimonioId: id,
        salaDestinoId: salaId,
      );
    }
  }
}
