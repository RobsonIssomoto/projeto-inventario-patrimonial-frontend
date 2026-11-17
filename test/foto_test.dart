// Testes da conversão das fotos (JSON da API -> modelos do app).
// Execução: flutter test

import 'package:flutter_test/flutter_test.dart';

import 'package:projeto_inventario_patrimonial_frontend/models/foto.dart';
import 'package:projeto_inventario_patrimonial_frontend/models/patrimonio.dart';

void main() {
  test('Foto.fromJson lê id, nome e se é a principal', () {
    final foto = Foto.fromJson({
      '_id': 'f1',
      'nomeOriginal': 'notebook.jpg',
      'principal': true,
      'createdAt': '2026-11-17T10:00:00.000Z',
    });

    expect(foto.id, 'f1');
    expect(foto.nomeOriginal, 'notebook.jpg');
    expect(foto.principal, isTrue);
    expect(foto.enviadaEm, isNotNull);
  });

  test('Patrimonio sem foto fica com fotoPrincipalId nulo', () {
    final patrimonio = Patrimonio.fromJson({
      'numeroPatrimonio': 'PAT-001',
      'descricao': 'Notebook',
      'fotoPrincipal': null,
    });

    expect(patrimonio.fotoPrincipalId, isNull);
  });

  test('Patrimonio lê o ID da foto principal', () {
    final patrimonio = Patrimonio.fromJson({
      'numeroPatrimonio': 'PAT-002',
      'descricao': 'Monitor',
      'fotoPrincipal': 'abc123',
    });

    expect(patrimonio.fotoPrincipalId, 'abc123');
  });
}
