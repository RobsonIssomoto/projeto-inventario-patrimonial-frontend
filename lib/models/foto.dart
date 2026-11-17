/// Foto de um patrimônio, como a API devolve em /arquivos.
class Foto {
  final String id;
  final String nomeOriginal;

  // true = foto que aparece no card da lista de patrimônios
  final bool principal;

  final DateTime? enviadaEm;

  Foto({
    required this.id,
    required this.nomeOriginal,
    required this.principal,
    this.enviadaEm,
  });

  factory Foto.fromJson(Map<String, dynamic> json) {
    return Foto(
      id: json['_id'] as String,
      nomeOriginal: json['nomeOriginal'] as String? ?? 'foto',
      principal: json['principal'] as bool? ?? false,
      enviadaEm: DateTime.tryParse(json['createdAt'] as String? ?? ''),
    );
  }
}
