import 'package:flutter/material.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/cores.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/patrimonio.dart';

class PatrimonioCardSm extends StatelessWidget {
  final Patrimonio patrimonio;
  final VoidCallback? onTap;

  const PatrimonioCardSm({super.key, required this.patrimonio, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto do patrimônio
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: Builder(
                    builder: (context) {
                      final String? imagem = patrimonio.imagem;
                      final nomeImagem = imagem?.trim() ?? '';

                      // Sem imagem cadastrada: mostra o placeholder.
                      if (nomeImagem.isEmpty) {
                        return Container(
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.hide_image_outlined,
                            size: 26,
                            color: Colors.grey,
                          ),
                        );
                      }

                      return Image.asset(
                        'assets/images/$nomeImagem',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Arquivo inexistente ou inválido: mostra o placeholder.
                          return Container(
                            color: Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.hide_image_outlined,
                              size: 26,
                              color: Colors.grey,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Número e descrição
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppCores.azulClaro,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            patrimonio.numeroPatrimonio,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppCores.azulEscuro,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              const WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 4),
                                  child: Icon(
                                    Icons.door_sliding_outlined,
                                    size: 15,
                                    color: AppCores.textoSecundario,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: patrimonio.sala.trim().isEmpty
                                    ? 'Sala não informada'
                                    : 'Sala: ${patrimonio.sala}',
                              ),
                            ],
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppCores.textoSecundario,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      patrimonio.descricao,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppCores.texto,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
