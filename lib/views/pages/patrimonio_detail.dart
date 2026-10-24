import 'package:flutter/material.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/patrimonio.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/widgets/patrimonio_card_sm.dart';
import 'package:projeto_inventario_patrimonial_frontend/views/widgets/patrimonio_validation_card.dart';

class PatrimonioDetail extends StatefulWidget {
  final Patrimonio patrimonio;

  const PatrimonioDetail({super.key, required this.patrimonio});

  @override
  State<PatrimonioDetail> createState() => _PatrimonioDetailState();
}

class _PatrimonioDetailState extends State<PatrimonioDetail> {
  String? _statusSelecionado;
  String? _estadoSelecionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF3FA),
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO FIXO
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: BackButton(color: Color(0xFF1E3A8A)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Detalhes do Patrimônio',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // CONTEÚDO ROLÁVEL
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // CARTÃO DE DESCRIÇÃO
                    PatrimonioCardSm(patrimonio: widget.patrimonio),

                    const SizedBox(height: 8),

                    // CARTÃO DE VALIDAÇÃO
                    PatrimonioValidationCard(
                      statusSelecionado: _statusSelecionado,
                      estadoSelecionado: _estadoSelecionado,
                      onStatusChanged: (status) {
                        setState(() {
                          _statusSelecionado = status;
                        });
                      },
                      onEstadoChanged: (estado) {
                        setState(() {
                          _estadoSelecionado = estado;
                        });
                      },
                    ),

                    //BOTÃO DE TRANSFERÊNCIA
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          //Direcionar para tela de transferência
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF97316),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14.0,
                            horizontal: 16.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.fact_check, size: 24),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Transferir',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
