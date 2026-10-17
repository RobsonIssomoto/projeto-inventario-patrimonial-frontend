import 'package:flutter/material.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/patrimonio.dart';

class PatrimonioCardSm extends StatelessWidget {
  final Patrimonio patrimonio;

  const PatrimonioCardSm({super.key, required this.patrimonio});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
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

                    // Com imagem cadastrada: tenta carregar o arquivo.
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
            const SizedBox(width: 8),

            // Número e descrição
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFBFDBFE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      patrimonio.numeroPatrimonio,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1E3A8A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    patrimonio.descricao,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
