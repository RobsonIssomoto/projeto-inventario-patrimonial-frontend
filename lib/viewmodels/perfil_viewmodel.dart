import 'package:projeto_inventario_patrimonial_frontend/repositories/usuario_repository.dart';

class PerfilViewModel {
  final UsuarioRepository _repository;

  PerfilViewModel({UsuarioRepository? repository})
    : _repository = repository ?? UsuarioRepository();

  String? _perfil;
  bool _carregando = false;
  String? _erro;

  String? get perfil => _perfil;
  bool get carregando => _carregando;
  String? get erro => _erro;

  bool get podeReceberTransferencias =>
      _perfil == 'gerente' || _perfil == 'administrador';

  Future<void> carregar() async {
    if (_carregando) return;

    _carregando = true;
    _erro = null;
    _perfil = null;

    try {
      _perfil = await _repository.consultarPerfilAtual();
    } catch (erro) {
      _erro = erro.toString().replaceFirst('Exception: ', '');
    } finally {
      _carregando = false;
    }
  }
}
