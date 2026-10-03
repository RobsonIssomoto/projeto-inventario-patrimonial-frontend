import 'package:flutter/material.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/patrimonio.dart';

class PatrimonioCard extends StatelessWidget {
  final Patrimonio patrimonio;

  const PatrimonioCard({super.key, required this.patrimonio});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: (Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            //LINHA 1 - Nº do patrimônio e Tipo
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffbfdbfe),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    patrimonio.numeroPatrimonio,
                    style: const TextStyle(
                      color: Color(0xff1e3a8a),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Text(
                  patrimonio.categoria,
                  style: const TextStyle(color: Colors.grey, fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            //Linha 2 - Descrição do Patrimônio
            Text(
              patrimonio.descricao,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 16.0),

            //Linha 3 - Container Interno com Secretaria e Sala
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.corporate_fare,
                        color: Color(0xff1e3a8a),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        patrimonio.secretaria,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Icons.door_sliding, color: Colors.grey),
                      const SizedBox(width: 8.0),
                      Text(
                        patrimonio.sala,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // LINHA 4 - Botões Detalhes e Transferir
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Ação do botão Detalhes
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('Detalhes'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Ação do botão Transferir
                    },
                    icon: const Icon(Icons.assignment_turned_in),
                    label: const Text('Transferir'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2563eb), // Azul do botão
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
