class Secretaria {
  final String id;
  final String nome;
  final bool ativa;

  Secretaria({required this.id, required this.nome, required this.ativa});

  factory Secretaria.fromJson(Map<String, dynamic> json) {
    return Secretaria(
      id: json['_id'] as String,
      nome: json['nome'] as String? ?? 'Secretaria sem nome',
      ativa: json['ativa'] as bool? ?? true,
    );
  }
}
