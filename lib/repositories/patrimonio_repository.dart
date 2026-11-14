import 'package:projeto_inventario_patrimonial_frontend/models/patrimonio.dart';
import 'package:projeto_inventario_patrimonial_frontend/services/patrimonio_service.dart';

class PatrimonioRepository {
  final PatrimonioService _service;
  PatrimonioRepository({PatrimonioService? service})
    : _service = service ?? PatrimonioService();

  Future<List<Patrimonio>> listarPatrimonios() {
    return _service.listarPatrimonios();
  }

  Future<void> atualizarPatrimonio({
    required String id,
    required String status,
    required String estadoConservacao,
    required String observacoes,
    String? salaId,
  }) {
    return _service.atualizarPatrimonio(
      id: id,
      status: status,
      estadoConservacao: estadoConservacao,
      observacoes: observacoes,
      salaId: salaId,
    );
  }
}
