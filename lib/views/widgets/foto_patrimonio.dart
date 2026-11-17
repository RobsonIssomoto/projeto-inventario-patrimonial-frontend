import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:projeto_inventario_patrimonial_frontend/viewmodels/foto_viewmodel.dart';

/// Mostra uma foto do patrimônio buscando os bytes na API.
///
/// - [fotoId] nulo: mostra o ícone de "sem foto".
/// - Carregando: mostra um indicador de progresso.
/// - Erro: volta para o ícone de "sem foto".
class FotoPatrimonio extends StatefulWidget {
  final String? fotoId;
  final BoxFit fit;
  final double tamanhoIcone;

  const FotoPatrimonio({
    super.key,
    required this.fotoId,
    this.fit = BoxFit.cover,
    this.tamanhoIcone = 26,
  });

  @override
  State<FotoPatrimonio> createState() => _FotoPatrimonioState();
}

class _FotoPatrimonioState extends State<FotoPatrimonio> {
  final FotoViewModel _viewModel = FotoViewModel();

  // Guardamos o Future no State para não baixar de novo a cada rebuild
  Future<Uint8List>? _download;

  @override
  void initState() {
    super.initState();
    _iniciarDownload();
  }

  @override
  void didUpdateWidget(covariant FotoPatrimonio oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Se a foto mudou (ex.: nova foto principal), baixa a nova
    if (oldWidget.fotoId != widget.fotoId) {
      _iniciarDownload();
    }
  }

  void _iniciarDownload() {
    final id = widget.fotoId;
    _download = (id == null || id.isEmpty) ? null : _viewModel.baixarFoto(id);
  }

  Widget _semFoto() {
    return Container(
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: Icon(
        Icons.hide_image_outlined,
        size: widget.tamanhoIcone,
        color: Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final download = _download;
    if (download == null) return _semFoto();

    return FutureBuilder<Uint8List>(
      future: download,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            color: Colors.grey.shade100,
            alignment: Alignment.center,
            child: const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        final bytes = snapshot.data;
        if (snapshot.hasError || bytes == null || bytes.isEmpty) {
          return _semFoto();
        }

        return Image.memory(
          bytes,
          fit: widget.fit,
          errorBuilder: (context, error, stackTrace) => _semFoto(),
        );
      },
    );
  }
}
