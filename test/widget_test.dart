// Testes unitários do modelo Patrimonio (conversão do JSON da API).
// Execução: flutter test

import 'package:flutter_test/flutter_test.dart';

import 'package:projeto_inventario_patrimonial_frontend/models/patrimonio.dart';

void main() {
  group('Patrimonio.fromJson', () {
    test('converte patrimônio com sala e secretaria populadas', () {
      final patrimonio = Patrimonio.fromJson({
        '_id': 'p1',
        'numeroPatrimonio': '000123',
        'descricao': 'Notebook Dell',
        'categoria': 'Informática',
        'status': 'conferido',
        'estadoConservacao': 'ruim',
        'observacoes': 'Tela riscada',
        'secretaria': {'_id': 's1', 'nome': 'Educação'},
        'sala': {'_id': 'sl1', 'nome': 'Sala 1'},
        'updatedAt': '2026-11-17T10:00:00.000Z',
      });

      expect(patrimonio.id, 'p1');
      expect(patrimonio.secretariaId, 's1');
      expect(patrimonio.secretaria, 'Educação');
      expect(patrimonio.salaId, 'sl1');
      expect(patrimonio.sala, 'Sala 1');
      expect(patrimonio.statusFormatado, 'Conferido');
      expect(patrimonio.estadoFormatado, 'Ruim');
      expect(patrimonio.atualizadoEm, isNotNull);
    });

    test('usa valores padrão quando campos opcionais não vêm da API', () {
      final patrimonio = Patrimonio.fromJson({
        'numeroPatrimonio': '000999',
        'descricao': 'Cadeira',
        'secretaria': 's1',
        'sala': 'sl1',
      });

      expect(patrimonio.secretariaId, 's1');
      expect(patrimonio.secretaria, 'Secretaria não informada');
      expect(patrimonio.categoria, 'Sem categoria');
      expect(patrimonio.status, 'pendente');
      expect(patrimonio.statusFormatado, 'Pendente');
      expect(patrimonio.estadoFormatado, 'Bom');
      expect(patrimonio.observacoes, '');
      expect(patrimonio.atualizadoEm, isNull);
    });

    test('formata status "nao_localizado" e estado "inservivel"', () {
      final patrimonio = Patrimonio.fromJson({
        'numeroPatrimonio': '000555',
        'descricao': 'Impressora',
        'status': 'nao_localizado',
        'estadoConservacao': 'inservivel',
      });

      expect(patrimonio.statusFormatado, 'Não localizado');
      expect(patrimonio.estadoFormatado, 'Inservível');
    });
  });
}
