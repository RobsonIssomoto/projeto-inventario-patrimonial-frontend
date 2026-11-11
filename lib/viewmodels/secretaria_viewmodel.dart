import 'package:projeto_inventario_patrimonial_frontend/repositories/secretaria_repository.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/secretaria.dart';

class SecretariaViewModel {
  final SecretariaRepository _repository;

  SecretariaViewModel({SecretariaRepository? repository})
    : _repository = repository ?? SecretariaRepository();

  List<Secretaria> _secretarias = [];
  bool _carregando = false;
  String? _erro;

  List<Secretaria> get secretarias => _secretarias;
  bool get carregando => _carregando;
  String? get erro => _erro;

  Future<void> carregarSecretarias() async {
    _carregando = true;
    _erro = null;

    try {
      _secretarias = await _repository.listarSecretarias();
    } catch (e) {
      _erro = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _carregando = false;
    }
  }
}
