import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/foto.dart';
import 'package:projeto_inventario_patrimonial_frontend/viewmodels/foto_viewmodel.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/cores.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/widgets/foto_patrimonio.dart';

/// Card de fotos da tela de detalhes.
///
/// Regras (as mesmas da API):
/// - até 3 fotos por patrimônio;
/// - a primeira foto enviada vira a principal (aparece no card da lista);
/// - o usuário pode escolher outra como principal ou excluir uma foto.
class GaleriaFotosCard extends StatefulWidget {
  final String patrimonioId;

  /// Avisa a tela de detalhes que as fotos mudaram
  /// (para a lista recarregar e mostrar a nova foto principal).
  final VoidCallback onAlterado;

  const GaleriaFotosCard({
    super.key,
    required this.patrimonioId,
    required this.onAlterado,
  });

  @override
  State<GaleriaFotosCard> createState() => _GaleriaFotosCardState();
}

class _GaleriaFotosCardState extends State<GaleriaFotosCard> {
  // Toda a lógica (lista, limite, envio) fica no ViewModel.
  // Este widget só desenha a tela e chama setState depois de cada ação.
  final FotoViewModel _viewModel = FotoViewModel();
  final ImagePicker _seletorDeImagem = ImagePicker();

  @override
  void initState() {
    super.initState();
    // carregar() já marca "carregando" antes do primeiro desenho da tela
    _viewModel.carregar(widget.patrimonioId).then((_) {
      if (mounted) setState(() {});
    });
  }

  // ---------- AÇÕES ----------

  // Usado pelo botão "Tentar novamente"
  Future<void> _carregarFotos() async {
    final carga = _viewModel.carregar(widget.patrimonioId);
    setState(() {}); // mostra o "carregando"
    await carga;
    if (mounted) setState(() {});
  }

  Future<void> _adicionarFoto() async {
    // 1. Pergunta de onde vem a foto
    final origem = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Tirar foto'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Escolher da galeria'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (origem == null) return; // fechou sem escolher

    // 2. Abre a câmera/galeria. maxWidth e imageQuality reduzem o tamanho
    //    da imagem antes do envio (a API aceita até 5 MB).
    final XFile? imagem = await _seletorDeImagem.pickImage(
      source: origem,
      maxWidth: 1600,
      imageQuality: 80,
    );

    if (imagem == null) return; // cancelou

    final tipo = _viewModel.tipoDaImagem(
      tipoInformado: imagem.mimeType,
      nomeArquivo: imagem.name,
    );

    if (tipo == null) {
      _mostrarAviso('Formato inválido. Use uma imagem JPG, PNG ou WEBP.');
      return;
    }

    // 3. Envia pelo ViewModel
    try {
      final bytes = await imagem.readAsBytes();
      if (!mounted) return;

      // enviar() marca "enviando" logo no início; o setState abaixo
      // redesenha o botão "Adicionar" com o indicador de progresso
      final envio = _viewModel.enviar(
        patrimonioId: widget.patrimonioId,
        bytes: bytes,
        nomeArquivo: imagem.name,
        tipoConteudo: tipo,
      );
      setState(() {});
      await envio;

      _mostrarAviso('Foto enviada com sucesso.');
      widget.onAlterado();
    } catch (erro) {
      _mostrarAviso(_mensagem(erro));
    } finally {
      if (mounted) setState(() {});
    }
  }

  Future<void> _definirPrincipal(Foto foto) async {
    try {
      await _viewModel.definirPrincipal(
        patrimonioId: widget.patrimonioId,
        fotoId: foto.id,
      );
      _mostrarAviso('Foto principal atualizada.');
      widget.onAlterado();
    } catch (erro) {
      _mostrarAviso(_mensagem(erro));
    } finally {
      if (mounted) setState(() {});
    }
  }

  Future<void> _excluir(Foto foto) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir foto'),
        content: const Text('Tem certeza que deseja excluir esta foto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Excluir',
              style: TextStyle(color: AppCores.vermelho),
            ),
          ),
        ],
      ),
    );

    if (confirmou != true) return;

    try {
      await _viewModel.excluir(
        patrimonioId: widget.patrimonioId,
        fotoId: foto.id,
      );
      _mostrarAviso('Foto excluída.');
      widget.onAlterado();
    } catch (erro) {
      _mostrarAviso(_mensagem(erro));
    } finally {
      if (mounted) setState(() {});
    }
  }

  // Menu que abre ao tocar numa foto
  Future<void> _abrirOpcoes(Foto foto) async {
    final opcao = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.zoom_in),
              title: const Text('Ver foto'),
              onTap: () => Navigator.pop(context, 'ver'),
            ),
            if (!foto.principal)
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: const Text('Definir como principal'),
                onTap: () => Navigator.pop(context, 'principal'),
              ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppCores.vermelho),
              title: const Text(
                'Excluir foto',
                style: TextStyle(color: AppCores.vermelho),
              ),
              onTap: () => Navigator.pop(context, 'excluir'),
            ),
          ],
        ),
      ),
    );

    if (!mounted) return;

    if (opcao == 'ver') _verFoto(foto);
    if (opcao == 'principal') await _definirPrincipal(foto);
    if (opcao == 'excluir') await _excluir(foto);
  }

  void _verFoto(Foto foto) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: FotoPatrimonio(
                fotoId: foto.id,
                fit: BoxFit.contain,
                tamanhoIcone: 48,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- AUXILIARES ----------

  String _mensagem(Object erro) {
    return erro.toString().replaceFirst('Exception: ', '');
  }

  void _mostrarAviso(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  // ---------- TELA ----------

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.photo_outlined, color: AppCores.azulEscuro),
                const SizedBox(width: 8),
                Text(
                  'Fotos (${_viewModel.fotos.length}/${FotoViewModel.limiteFotos})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppCores.texto,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Toque numa foto para ver, definir como principal ou excluir. '
              'A foto com estrela aparece na lista.',
              style: TextStyle(fontSize: 12, color: AppCores.textoSecundario),
            ),
            const SizedBox(height: 12),
            _conteudo(),
          ],
        ),
      ),
    );
  }

  Widget _conteudo() {
    if (_viewModel.carregando) {
      return const SizedBox(
        height: 90,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final erro = _viewModel.erro;
    if (erro != null) {
      return Row(
        children: [
          Expanded(
            child: Text(
              erro,
              style: const TextStyle(color: AppCores.vermelho),
            ),
          ),
          TextButton(
            onPressed: _carregarFotos,
            child: const Text('Tentar novamente'),
          ),
        ],
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final foto in _viewModel.fotos) _miniatura(foto),
        if (_viewModel.podeAdicionar) _botaoAdicionar(),
      ],
    );
  }

  Widget _miniatura(Foto foto) {
    return InkWell(
      onTap: () => _abrirOpcoes(foto),
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 90,
              height: 90,
              child: FotoPatrimonio(fotoId: foto.id),
            ),
          ),
          // Estrela na foto principal
          if (foto.principal)
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star, size: 16, color: AppCores.amarelo),
              ),
            ),
        ],
      ),
    );
  }

  Widget _botaoAdicionar() {
    return InkWell(
      onTap: _viewModel.enviando ? null : _adicionarFoto,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: AppCores.azulClaro,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppCores.azul),
        ),
        alignment: Alignment.center,
        child: _viewModel.enviando
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_a_photo_outlined, color: AppCores.azulEscuro),
                  SizedBox(height: 4),
                  Text(
                    'Adicionar',
                    style: TextStyle(fontSize: 12, color: AppCores.azulEscuro),
                  ),
                ],
              ),
      ),
    );
  }
}
