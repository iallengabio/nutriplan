import 'package:result_dart/result_dart.dart';
import '../../core/extensions/date_extensions.dart';
import '../../domain/models/menu.dart';
import '../../domain/models/perfil_familiar.dart';
import '../../domain/models/refeicao.dart';
import '../../domain/models/shopping_list.dart';
import '../../domain/services/ai_api_service.dart';

/// Implementação mock do AiApiService para desenvolvimento
class AiApiServiceMock implements AiApiService {
  @override
  Future<Result<Menu>> gerarCardapio({
    required PerfilFamiliar perfil,
    required Set<TipoRefeicao> tiposRefeicao,
    String? nome,
    String? observacoesAdicionais,
    int? numberOfPeople,
  }) async {
    // Simula delay da API
    await Future.delayed(const Duration(seconds: 2));

    try {
      final menu = _criarMenuMock(
        perfil: perfil,
        tiposRefeicao: tiposRefeicao,
        nome: nome,
        observacoesAdicionais: observacoesAdicionais,
        numberOfPeople: numberOfPeople,
      );
      return Success(menu);
    } catch (e) {
      return Failure(AiApiServiceError('Erro ao gerar cardápio: $e'));
    }
  }

  @override
  Future<Result<Refeicao>> gerarRefeicaoAlternativa({
    required PerfilFamiliar perfil,
    required TipoRefeicao tipo,
    String? observacoesAdicionais,
  }) async {
    // Simula delay da API
    await Future.delayed(const Duration(seconds: 1));

    try {
      final refeicao = _criarRefeicaoMock(tipo, perfil);
      return Success(refeicao);
    } catch (e) {
      return Failure(AiApiServiceError('Erro ao gerar refeição alternativa: $e'));
    }
  }

  @override
  Future<Result<ShoppingList>> gerarListaCompras({
    required Menu menu,
    required int numeroSemanas,
    String? nome,
    String? observacoes,
    int? numberOfPeople,
  }) async {
    // Simula delay da API
    await Future.delayed(const Duration(seconds: 2));

    try {
      final shoppingList = _criarListaComprasMock(
        menu: menu,
        numeroSemanas: numeroSemanas,
        nome: nome,
        observacoes: observacoes,
        numberOfPeople: numberOfPeople,
      );
      return Success(shoppingList);
    } catch (e) {
      return Failure(AiApiServiceError('Erro ao gerar lista de compras: $e'));
    }
  }

  /// Cria um menu mock baseado no perfil
  Menu _criarMenuMock({
    required PerfilFamiliar perfil,
    required Set<TipoRefeicao> tiposRefeicao,
    String? nome,
    String? observacoesAdicionais,
    int? numberOfPeople,
  }) {
    final refeicoesPorDia = <DiaSemana, List<Refeicao>>{};
    
    // Gera refeições para cada dia da semana
    for (final dia in DiaSemana.values) {
      final refeicoesDoDia = <Refeicao>[];
      
      for (final tipo in tiposRefeicao) {
        refeicoesDoDia.add(_criarRefeicaoMock(tipo, perfil));
      }
      
      refeicoesPorDia[dia] = refeicoesDoDia;
    }

    return Menu(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: nome?.trim().isNotEmpty == true 
          ? nome! 
          : 'Cardápio Gerado - ${DateTime.now().formatarDataBrasileira()}',
      dataCriacao: DateTime.now(),
      refeicoesPorDia: refeicoesPorDia,
      observacoes: _adicionarObservacoesPerfil(perfil, observacoesAdicionais),
      isFavorito: false,
      numberOfPeople: numberOfPeople ?? (perfil.numeroAdultos + perfil.numeroCriancas),
    );
  }

  /// Cria uma refeição mock
  Refeicao _criarRefeicaoMock(TipoRefeicao tipo, PerfilFamiliar perfil) {
    final refeicoesMock = {
      TipoRefeicao.cafeManha: [
        'Pão integral com queijo branco',
        'Vitamina de banana com aveia',
        'Tapioca com queijo coalho',
        'Iogurte natural com granola',
        'Ovos mexidos com torrada',
      ],
      TipoRefeicao.almoco: [
        'Arroz integral, feijão, frango grelhado e salada',
        'Macarrão integral com molho de tomate e carne moída',
        'Peixe assado com batata doce e brócolis',
        'Risoto de frango com legumes',
        'Carne de panela com mandioca e couve refogada',
      ],
      TipoRefeicao.lanche: [
        'Frutas da estação',
        'Mix de castanhas',
        'Sanduíche natural',
        'Smoothie de frutas vermelhas',
        'Biscoito integral com suco natural',
      ],
      TipoRefeicao.jantar: [
        'Sopa de legumes com torrada',
        'Salada completa com proteína',
        'Omelete com salada verde',
        'Peixe grelhado com legumes no vapor',
        'Sanduíche de frango com salada',
      ],
      TipoRefeicao.ceia: [
        'Chá de camomila com biscoito integral',
        'Iogurte natural',
        'Leite morno com mel',
        'Frutas leves',
        'Água de coco',
      ],
    };

    final opcoes = refeicoesMock[tipo] ?? ['Refeição padrão'];
    final opcaoEscolhida = opcoes[DateTime.now().millisecond % opcoes.length];
    final ingredientesMock = _gerarIngredientesMock(opcaoEscolhida, perfil);

    return Refeicao(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      nome: opcaoEscolhida,
      descricao: 'Descrição detalhada para: $opcaoEscolhida',
      ingredientes: ingredientesMock.keys.toList(),
      quantidades: ingredientesMock,
      tipo: tipo,
      tempoPreparoMinutos: 15 + (DateTime.now().millisecond % 45),
      porcoes: perfil.numeroAdultos + perfil.numeroCriancas,
      observacoes: _aplicarRestricoesPerfil(perfil),
    );
  }

  /// Gera ingredientes mock baseados na refeição
  Map<String, String> _gerarIngredientesMock(String nomeRefeicao, PerfilFamiliar perfil) {
    final totalPessoas = perfil.numeroAdultos + perfil.numeroCriancas;
    final ingredientes = <String, String>{};

    // Ingredientes base
    ingredientes['Ingrediente principal'] = '$totalPessoas porções';
    ingredientes['Tempero'] = 'A gosto';
    ingredientes['Sal'] = 'A gosto';

    // Adiciona ingredientes específicos baseados no tipo de refeição
    if (nomeRefeicao.toLowerCase().contains('arroz')) {
      ingredientes['Arroz integral'] = '${totalPessoas * 100}g';
    }
    
    if (nomeRefeicao.toLowerCase().contains('frango')) {
      ingredientes['Peito de frango'] = '${totalPessoas * 150}g';
    }
    
    if (nomeRefeicao.toLowerCase().contains('pão')) {
      ingredientes['Pão integral'] = '$totalPessoas fatias';
    }
    
    if (nomeRefeicao.toLowerCase().contains('ovo')) {
      ingredientes['Ovos'] = '$totalPessoas unidades';
    }

    return ingredientes;
  }

  /// Aplica restrições do perfil às observações
  String? _aplicarRestricoesPerfil(PerfilFamiliar perfil) {
    if (perfil.restricoesAlimentares.isEmpty) return null;
    
    return 'Adaptado para: ${perfil.restricoesAlimentares.map((r) => r.displayName).join(', ')}';
  }

  /// Adiciona observações baseadas no perfil familiar
  String? _adicionarObservacoesPerfil(PerfilFamiliar perfil, String? observacoesAdicionais) {
    final observacoes = <String>[];
    
    if (perfil.numeroCriancas > 0) {
      observacoes.add('Adaptado para ${perfil.numeroCriancas} criança(s)');
    }
    
    if (perfil.restricoesAlimentares.isNotEmpty) {
      observacoes.add('Considerando restrições: ${perfil.restricoesAlimentares.map((r) => r.displayName).join(', ')}');
    }

    if (observacoesAdicionais != null && observacoesAdicionais.isNotEmpty) {
      observacoes.add(observacoesAdicionais);
    }
    
    return observacoes.isNotEmpty ? observacoes.join('. ') : null;
  }



  /// Cria uma lista de compras mock baseada no menu
  ShoppingList _criarListaComprasMock({
    required Menu menu,
    required int numeroSemanas,
    String? nome,
    String? observacoes,
    int? numberOfPeople,
  }) {
    final itens = <ShoppingItem>[];
    
    // Usa numberOfPeople do cardápio ou como fallback
    final totalPessoas = numberOfPeople ?? menu.numberOfPeople ?? 4;
    
    // Ingredientes básicos que sempre aparecem (ajustados para o número de pessoas)
    final ingredientesBasicos = {
      'Arroz integral': '${(numeroSemanas * totalPessoas * 0.5).toStringAsFixed(1)}kg',
      'Feijão': '${(numeroSemanas * totalPessoas * 250).toInt()}g',
      'Óleo de cozinha': '${totalPessoas > 4 ? 2 : 1} litro${totalPessoas > 4 ? 's' : ''}',
      'Sal': '1 pacote',
      'Açúcar': '${totalPessoas > 4 ? 2 : 1}kg',
      'Leite': '${(numeroSemanas * totalPessoas * 0.5).toInt()} litros',
      'Ovos': '${(numeroSemanas * totalPessoas * 0.5).toInt()} dúzias',
      'Pão integral': '${(numeroSemanas * totalPessoas * 0.5).toInt()} unidades',
      'Frango': '${(numeroSemanas * totalPessoas * 0.5).toStringAsFixed(1)}kg',
      'Carne bovina': '${(numeroSemanas * totalPessoas * 250).toInt()}g',
      'Peixe': '${(numeroSemanas * totalPessoas * 250).toInt()}g',
      'Batata': '${(numeroSemanas * totalPessoas * 0.5).toStringAsFixed(1)}kg',
      'Cebola': '${(numeroSemanas * totalPessoas * 250).toInt()}g',
      'Alho': '${totalPessoas > 4 ? 2 : 1} cabeça${totalPessoas > 4 ? 's' : ''}',
      'Tomate': '${(numeroSemanas * totalPessoas * 250).toInt()}g',
      'Alface': '${(numeroSemanas * totalPessoas * 0.5).toInt()} pés',
      'Cenoura': '${(numeroSemanas * totalPessoas * 250).toInt()}g',
      'Brócolis': '${(numeroSemanas * totalPessoas * 0.5).toInt()} unidades',
      'Banana': '${(numeroSemanas * totalPessoas * 0.5).toInt()} dúzias',
      'Maçã': '${(numeroSemanas * totalPessoas * 0.5).toStringAsFixed(1)}kg',
      'Iogurte natural': '${(numeroSemanas * totalPessoas).toInt()} unidades',
    };

    // Categorias para organizar os itens
    final categorias = {
      'Grãos e Cereais': ['Arroz integral', 'Feijão', 'Pão integral'],
      'Proteínas': ['Frango', 'Carne bovina', 'Peixe', 'Ovos'],
      'Laticínios': ['Leite', 'Iogurte natural'],
      'Vegetais': ['Batata', 'Cebola', 'Alho', 'Tomate', 'Alface', 'Cenoura', 'Brócolis'],
      'Frutas': ['Banana', 'Maçã'],
      'Condimentos': ['Óleo de cozinha', 'Sal', 'Açúcar'],
    };

    // Cria os itens da lista
    int itemIndex = 0;
    for (final categoria in categorias.entries) {
      for (final ingrediente in categoria.value) {
        if (ingredientesBasicos.containsKey(ingrediente)) {
          itens.add(ShoppingItem(
            id: 'mock_item_${itemIndex++}',
            nome: ingrediente,
            quantidade: ingredientesBasicos[ingrediente]!,
            categoria: categoria.key,
            comprado: false,
            observacoes: null,
          ));
        }
      }
    }

    return ShoppingList(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: nome?.trim().isNotEmpty == true 
          ? nome! 
          : 'Lista de Compras - ${menu.nome}',
      dataCriacao: DateTime.now(),
      menuId: menu.id,
      menuNome: menu.nome,
      numeroSemanas: numeroSemanas,
      itens: itens,
      observacoes: observacoes,
      dataUltimaEdicao: DateTime.now(),
    );
  }
}