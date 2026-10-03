class Patrimonio {
  final String numeroPatrimonio;
  final String descricao;
  final String secretaria;
  final String sala;
  final String categoria;
  final String status;
  final String estadoConservacao;
  final String observacoes;

  Patrimonio({
    required this.numeroPatrimonio,
    required this.descricao,
    required this.secretaria,
    required this.sala,
    required this.categoria,
    required this.status,
    required this.estadoConservacao,
    required this.observacoes,
  });

  static List<Patrimonio> patrimonioMock = [
    Patrimonio(
      numeroPatrimonio: 'PAT-001',
      descricao: 'Notebook Dell Latitude 5420',
      secretaria: 'TI',
      sala: '101',
      categoria: 'Notebook',
      status: 'conferido',
      estadoConservacao: 'bom',
      observacoes: 'Equipamento em bom estado de conservação',
    ),
    Patrimonio(
      numeroPatrimonio: 'PAT-002',
      descricao: 'Monitor LG 24 polegadas',
      secretaria: 'TI',
      sala: '101',
      categoria: 'Monitor',
      status: 'conferido',
      estadoConservacao: 'novo',
      observacoes: '',
    ),
    Patrimonio(
      numeroPatrimonio: 'PAT-003',
      descricao: 'Cadeira de escritório ergonômica',
      secretaria: 'RH',
      sala: '205',
      categoria: 'Móvel',
      status: 'pendente',
      estadoConservacao: 'bom',
      observacoes: '',
    ),
    Patrimonio(
      numeroPatrimonio: 'PAT-004',
      descricao: 'Mesa de escritório em L',
      secretaria: 'RH',
      sala: '205',
      categoria: 'Móvel',
      status: 'conferido',
      estadoConservacao: 'regular',
      observacoes: 'Pequenos arranhões na superfície',
    ),
    Patrimonio(
      numeroPatrimonio: 'PAT-005',
      descricao: 'Impressora HP LaserJet Pro',
      secretaria: 'Administrativo',
      sala: '302',
      categoria: 'Impressora',
      status: 'pendente',
      estadoConservacao: 'bom',
      observacoes: '',
    ),
    Patrimonio(
      numeroPatrimonio: 'PAT-006',
      descricao: 'Projetor Epson PowerLite',
      secretaria: 'TI',
      sala: '101',
      categoria: 'Projetor',
      status: 'nao_localizado',
      estadoConservacao: 'regular',
      observacoes: 'Não encontrado na última conferência',
    ),
    Patrimonio(
      numeroPatrimonio: 'PAT-007',
      descricao: 'Teclado mecânico Logitech',
      secretaria: 'TI',
      sala: '102',
      categoria: 'Periférico',
      status: 'conferido',
      estadoConservacao: 'novo',
      observacoes: '',
    ),
    Patrimonio(
      numeroPatrimonio: 'PAT-008',
      descricao: 'Mouse sem fio Microsoft',
      secretaria: 'TI',
      sala: '102',
      categoria: 'Periférico',
      status: 'conferido',
      estadoConservacao: 'bom',
      observacoes: '',
    ),
    Patrimonio(
      numeroPatrimonio: 'PAT-009',
      descricao: 'Servidor Dell PowerEdge',
      secretaria: 'TI',
      sala: '110',
      categoria: 'Servidor',
      status: 'pendente',
      estadoConservacao: 'bom',
      observacoes: 'Equipamento de crítico',
    ),
    Patrimonio(
      numeroPatrimonio: 'PAT-010',
      descricao: 'Arquivo de aço 4 gavetas',
      secretaria: 'Administrativo',
      sala: '302',
      categoria: 'Móvel',
      status: 'conferido',
      estadoConservacao: 'regular',
      observacoes: '',
    ),
  ];
}
