import 'package:projeto_inventario_patrimonial_frontend/models/patrimonio.dart';

class InventarioViewModel {
  final List<Patrimonio> _patrimonios = Patrimonio.patrimonioMock;

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
        (a, b) => a.numeroPatrimonio.toLowerCase().compareTo(
          b.numeroPatrimonio.toLowerCase(),
        ),
      );
    } else {
      resultado.sort(
        (a, b) =>
            a.descricao.toLowerCase().compareTo(b.descricao.toLowerCase()),
      );
    }

    return resultado;
  }
}
