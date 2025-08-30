import 'package:flutter_test/flutter_test.dart';
import 'package:nutriplan/src/domain/models/menu.dart';
import 'package:nutriplan/src/domain/models/refeicao.dart';
import 'package:nutriplan/src/domain/models/perfil_familiar.dart';
import 'package:nutriplan/src/data/services/ai_api_service_mock.dart';

void main() {
  group('Menu numberOfPeople Tests', () {
    late AiApiServiceMock aiService;
    
    setUp(() {
      aiService = AiApiServiceMock();
    });
    
    test('Menu deve ser criado com numberOfPeople correto quando especificado', () async {
      // Arrange
      final perfil = PerfilFamiliar(
        id: 'test',
        numeroAdultos: 2,
        numeroCriancas: 0,
        restricoesAlimentares: <RestricaoAlimentar>{},
      );
      
      const numberOfPeople = 2;
      final tiposRefeicao = {TipoRefeicao.cafeManha, TipoRefeicao.almoco};
      
      // Act
      final result = await aiService.gerarCardapio(
        perfil: perfil,
        tiposRefeicao: tiposRefeicao,
        numberOfPeople: numberOfPeople,
      );
      
      // Assert
      expect(result.isSuccess(), true);
      final menu = result.getOrThrow();
      expect(menu.numberOfPeople, equals(2));
    });
    
    test('Menu deve usar totalPessoas do perfil quando numberOfPeople não especificado', () async {
      // Arrange
      final perfil = PerfilFamiliar(
        id: 'test',
        numeroAdultos: 3,
        numeroCriancas: 1,
        restricoesAlimentares: <RestricaoAlimentar>{},
      );
      
      final tiposRefeicao = {TipoRefeicao.cafeManha, TipoRefeicao.almoco};
      
      // Act
      final result = await aiService.gerarCardapio(
        perfil: perfil,
        tiposRefeicao: tiposRefeicao,
        // numberOfPeople não especificado
      );
      
      // Assert
      expect(result.isSuccess(), true);
      final menu = result.getOrThrow();
      expect(menu.numberOfPeople, equals(4)); // 3 adultos + 1 criança
    });
    
    test('Menu criado diretamente deve ter numberOfPeople correto', () {
      // Arrange & Act
      final menu = Menu(
        id: 'test',
        nome: 'Teste',
        dataCriacao: DateTime.now(),
        refeicoesPorDia: {},
        numberOfPeople: 2,
      );
      
      // Assert
      expect(menu.numberOfPeople, equals(2));
    });
    
    test('Menu sem numberOfPeople especificado deve usar valor padrão 4', () {
      // Arrange & Act
      final menu = Menu(
        id: 'test',
        nome: 'Teste',
        dataCriacao: DateTime.now(),
        refeicoesPorDia: {},
        // numberOfPeople não especificado, deve usar @Default(4)
      );
      
      // Assert
      expect(menu.numberOfPeople, equals(4));
    });
  });
}