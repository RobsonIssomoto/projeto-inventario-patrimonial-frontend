class Sala {
  final String id;
  final String nome;

  Sala({required this.id, required this.nome});

  factory Sala.fromJson(Map<String, dynamic> json) {
    return Sala(
      id: json['_id'] as String,
      nome: json['nome'] as String? ?? 'Sala sem nome',
    );
  }
}
