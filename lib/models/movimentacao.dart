class Movimentacao {
  final String id;
  final String tipo;
  final String usuario;
  final String patrimonio;
  final String secretaria;
  final String sala;
  final DateTime dataHora;
  final String? salaOrigem;
  final String? salaDestino;
  final String? secretariaOrigem;
  final String? secretariaDestino;
  final String? motivo;
  final String? status;
  final String? estadoConservacao;
  final String? observacoes;
  final String? statusTransferencia;

  Movimentacao({
    required this.id,
    required this.tipo,
    required this.usuario,
    required this.patrimonio,
    required this.secretaria,
    required this.sala,
    required this.dataHora,
    this.salaOrigem,
    this.salaDestino,
    this.secretariaOrigem,
    this.secretariaDestino,
    this.motivo,
    this.status,
    this.estadoConservacao,
    this.observacoes,
    this.statusTransferencia,
  });

  factory Movimentacao.fromJson(Map<String, dynamic> json) {
    final dados = json['dados'] as Map<String, dynamic>? ?? {};

    return Movimentacao(
      id: json['_id']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? '',
      usuario: _nomeReferencia(json['usuario']),
      patrimonio: json['patrimonio']?.toString() ?? '',
      secretaria: _nomeReferencia(json['secretaria']),
      sala: _nomeReferencia(json['sala']),
      dataHora: DateTime.parse(json['dataHora'].toString()),
      salaOrigem: _nomeReferencia(dados['salaOrigem']),
      salaDestino: _nomeReferencia(dados['salaDestino']),
      secretariaOrigem: _nomeReferencia(dados['secretariaOrigem']),
      secretariaDestino: _nomeReferencia(dados['secretariaDestino']),
      motivo: dados['motivo']?.toString(),
      status: dados['status']?.toString(),
      estadoConservacao: dados['estadoConservacao']?.toString(),
      observacoes: dados['observacoes']?.toString(),
      statusTransferencia: json['status']?.toString(),
    );
  }

  static String _nomeReferencia(dynamic valor) {
    if (valor is Map) {
      return valor['nome']?.toString() ?? '';
    }

    return valor?.toString() ?? '';
  }
}
