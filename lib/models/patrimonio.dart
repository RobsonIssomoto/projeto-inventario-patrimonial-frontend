class Patrimonio {
  final String? id;
  final String? secretariaId;
  final String? salaId;

  final String numeroPatrimonio;
  final String descricao;
  final String secretaria;
  final String sala;
  final String categoria;
  final String status;
  final String estadoConservacao;
  final String observacoes;
  final String? imagem;

  // Datas criadas automaticamente pela API (timestamps do MongoDB)
  final DateTime? cadastradoEm;
  final DateTime? atualizadoEm;

  Patrimonio({
    this.id,
    this.secretariaId,
    this.salaId,
    required this.numeroPatrimonio,
    required this.descricao,
    required this.secretaria,
    required this.sala,
    required this.categoria,
    required this.status,
    required this.estadoConservacao,
    required this.observacoes,
    this.imagem,
    this.cadastradoEm,
    this.atualizadoEm,
  });

  // Texto do status para mostrar na tela
  String get statusFormatado {
    if (status == 'conferido') return 'Conferido';
    if (status == 'nao_localizado') return 'Não localizado';
    return 'Pendente';
  }

  // Texto do estado de conservação para mostrar na tela.
  String get estadoFormatado {
    if (estadoConservacao == 'novo') return 'Novo';
    if (estadoConservacao == 'regular') return 'Regular';
    if (estadoConservacao == 'ruim') return 'Ruim';
    if (estadoConservacao == 'inservivel') return 'Inservível';
    return 'Bom';
  }

  factory Patrimonio.fromJson(Map<String, dynamic> json) {
    final secretariaDados = json['secretaria'];
    final salaDados = json['sala'];

    String? secretariaId;
    String secretariaNome = 'Secretaria não informada';

    if (secretariaDados is Map) {
      secretariaId = secretariaDados['_id'] as String?;
      secretariaNome =
          secretariaDados['nome'] as String? ?? 'Secretaria não informada';
    } else if (secretariaDados is String) {
      secretariaId = secretariaDados;
    }

    String? salaId;
    String salaNome = 'Sala não informada';

    if (salaDados is Map) {
      salaId = salaDados['_id'] as String?;
      salaNome = salaDados['nome'] as String? ?? 'Sala não informada';
    } else if (salaDados is String) {
      salaId = salaDados;
    }

    return Patrimonio(
      id: json['_id'] as String?,
      secretariaId: secretariaId,
      salaId: salaId,
      numeroPatrimonio: json['numeroPatrimonio'] as String,
      descricao: json['descricao'] as String,
      secretaria: secretariaNome,
      sala: salaNome,
      categoria: json['categoria'] as String? ?? 'Sem categoria',
      status: json['status'] as String? ?? 'pendente',
      estadoConservacao: json['estadoConservacao'] as String? ?? 'bom',
      observacoes: json['observacoes'] as String? ?? '',
      imagem: json['imagem'] as String?,
      // tryParse devolve null se a data vier vazia ou inválida
      cadastradoEm: DateTime.tryParse(json['createdAt'] as String? ?? ''),
      atualizadoEm: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
    );
  }
}
