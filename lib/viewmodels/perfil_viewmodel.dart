import 'package:projeto_inventario_patrimonial_frontend/repositories/usuario_repository.dart';

class PerfilViewModel {
  final UsuarioRepository _repository;

  PerfilViewModel({UsuarioRepository? repository})
    : _repository = repository ?? UsuarioRepository();

  String? _perfil;
  Map<String, dynamic>? _dadosUsuario;
  bool _carregando = false;
  String? _erro;

  String? get perfil => _perfil;

  /// Dados completos do usuário logado (nome, e-mail, perfil, secretaria)
  Map<String, dynamic>? get dadosUsuario => _dadosUsuario;
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

  /// Usado pela tela de Perfil: busca os dados completos do usuário (GET /usuarios/eu).
  Future<void> carregarDadosUsuario() async {
    _carregando = true;
    _erro = null;

    try {
      _dadosUsuario = await _repository.consultarUsuarioAtual();
      _perfil = _dadosUsuario?['perfil'] as String?;
    } catch (erro) {
      _erro = erro.toString().replaceFirst('Exception: ', '');
    } finally {
      _carregando = false;
    }
  }
}
