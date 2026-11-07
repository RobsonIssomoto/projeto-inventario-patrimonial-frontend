import 'package:projeto_inventario_patrimonial_frontend/models/patrimonio.dart';
import 'package:projeto_inventario_patrimonial_frontend/services/patrimonio_service.dart';

class PatrimonioRepository {
  final PatrimonioService _service = PatrimonioService();

  Future<List<Patrimonio>> listarPatrimonios() {
    return _service.listarPatrimonios();
  }
}
