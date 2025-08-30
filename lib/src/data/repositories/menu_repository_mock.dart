import 'package:result_dart/result_dart.dart';
import '../../domain/models/menu.dart';
import '../../domain/models/perfil_familiar.dart';
import '../../domain/models/refeicao.dart';
import '../../domain/repositories/menu_repository.dart';

/// Implementação mock do MenuRepository para desenvolvimento
class MenuRepositoryMock implements MenuRepository {
  final List<Menu> _menus = [];
  int _nextId = 1;

  @override
  Future<Result<Menu>> gerarMenu({
    required PerfilFamiliar perfil,
    required Set<TipoRefeicao> tiposRefeicao,
    String? nome,
    String? observacoesAdicionais,
  }) async {
    // Simula delay da API
    await Future.delayed(const Duration(seconds: 1));

    try {
      final menu = _criarMenuMock(
        perfil: perfil,
        tiposRefeicao: tiposRefeicao,
        nome: nome,
        observacoesAdicionais: observacoesAdicionais,
      );
      return Success(menu);
    } catch (e) {
      return Failure(Exception('Erro ao gerar cardápio: $e'));
    }
  }

  @override
  Future<Result<void>> salvarMenu(Menu menu) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final index = _menus.indexWhere((m) => m.id == menu.id);
      if (index >= 0) {
        _menus[index] = menu;
      } else {
        _menus.add(menu);
      }
      return const Success(());
    } catch (e) {
      return Failure(Exception('Erro ao salvar cardápio: $e'));
    }
  }

  @override
  Future<Result<Menu>> salvarNovoMenu(Menu menu) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      // Gera um novo ID simulando o comportamento do Firebase
      final novoId = 'menu_${_nextId++}_${DateTime.now().millisecondsSinceEpoch}';
      final menuComNovoId = menu.copyWith(id: novoId);
      
      _menus.add(menuComNovoId);
      return Success(menuComNovoId);
    } catch (e) {
      return Failure(Exception('Erro ao salvar novo cardápio: $e'));
    }
  }

  @override
  Future<Result<List<Menu>>> listarMenus() async {
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      // Retorna cópia da lista ordenada por data de criação (mais recente primeiro)
      final menusCopy = List<Menu>.from(_menus)
        ..sort((a, b) => b.dataCriacao.compareTo(a.dataCriacao));
      return Success(menusCopy);
    } catch (e) {
      return Failure(Exception('Erro ao listar cardápios: $e'));
    }
  }

  @override
  Future<Result<Menu>> buscarMenuPorId(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      final menu = _menus.firstWhere((m) => m.id == id);
      return Success(menu);
    } catch (e) {
      return Failure(Exception('Cardápio não encontrado'));
    }
  }

  @override
  Future<Result<void>> atualizarMenu(Menu menu) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final index = _menus.indexWhere((m) => m.id == menu.id);
      if (index >= 0) {
        _menus[index] = menu.copyWith(dataUltimaEdicao: DateTime.now());
        return const Success(());
      } else {
        return Failure(Exception('Cardápio não encontrado para atualização'));
      }
    } catch (e) {
      return Failure(Exception('Erro ao atualizar cardápio: $e'));
    }
  }

  @override
  Future<Result<void>> removerMenu(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      final initialLength = _menus.length;
      _menus.removeWhere((m) => m.id == id);
      if (_menus.length < initialLength) {
        return const Success(());
      } else {
        return Failure(Exception('Cardápio não encontrado para remoção'));
      }
    } catch (e) {
      return Failure(Exception('Erro ao remover cardápio: $e'));
    }
  }

  @override
  Future<Result<Refeicao>> gerarRefeicaoAlternativa({
    required PerfilFamiliar perfil,
    required TipoRefeicao tipo,
    String? observacoesAdicionais,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final refeicao = _criarRefeicaoMock(tipo, perfil);
      return Success(refeicao);
    } catch (e) {
      return Failure(Exception('Erro ao gerar refeição alternativa: $e'));
    }
  }

  @override
  Future<Result<Menu>> duplicarMenu(String menuId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    try {
      final menuOriginal = _menus.firstWhere((m) => m.id == menuId);
      final menuDuplicado = menuOriginal.copyWith(
        id: 'menu_${_nextId++}',
        nome: '${menuOriginal.nome} (Cópia)',
        dataCriacao: DateTime.now(),
        dataUltimaEdicao: DateTime.now(),
        isFavorito: false,
      );
      _menus.add(menuDuplicado);
      return Success(menuDuplicado);
    } catch (e) {
      return Failure(Exception('Erro ao duplicar cardápio: $e'));
    }
  }

  /// Cria um menu mock baseado no perfil familiar
  Menu _criarMenuMock({
    required PerfilFamiliar perfil,
    required Set<TipoRefeicao> tiposRefeicao,
    String? nome,
    String? observacoesAdicionais,
  }) {
    final agora = DateTime.now();
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
      id: 'menu_${_nextId++}',
      nome: nome ?? 'Cardápio ${_formatarData(agora)}',
      dataCriacao: agora,
      refeicoesPorDia: refeicoesPorDia,
      observacoes: observacoesAdicionais,
      isFavorito: false,
      dataUltimaEdicao: agora,
    );
  }

  /// Cria uma refeição mock baseada no tipo e perfil
  Refeicao _criarRefeicaoMock(TipoRefeicao tipo, PerfilFamiliar perfil) {
    final refeicoesMock = _obterRefeicoesMockPorTipo(tipo);
    final refeicaoEscolhida = refeicoesMock[DateTime.now().millisecond % refeicoesMock.length];
    
    // Ajusta quantidades baseado no número de pessoas
    final totalPessoas = perfil.numeroAdultos + perfil.numeroCriancas;
    final quantidadesAjustadas = <String, String>{};
    refeicaoEscolhida.quantidades.forEach((ingrediente, quantidade) {
      quantidadesAjustadas[ingrediente] = _ajustarQuantidade(quantidade, totalPessoas);
    });

    return refeicaoEscolhida.copyWith(
      id: 'refeicao_${DateTime.now().millisecondsSinceEpoch}',
      quantidades: quantidadesAjustadas,
      observacoes: _adicionarObservacoesPerfil(perfil),
    );
  }

  /// Retorna lista de refeições mock por tipo
  List<Refeicao> _obterRefeicoesMockPorTipo(TipoRefeicao tipo) {
    switch (tipo) {
      case TipoRefeicao.cafeManha:
        return [
          Refeicao(
            id: 'cafe1',
            nome: 'Café da Manhã Nutritivo',
            descricao: 'Café completo com frutas e cereais',
            ingredientes: ['Aveia', 'Banana', 'Leite', 'Mel', 'Castanhas'],
            quantidades: {
              'Aveia': '1 xícara',
              'Banana': '1 unidade',
              'Leite': '200ml',
              'Mel': '1 colher de sopa',
              'Castanhas': '30g'
            },
            tipo: TipoRefeicao.cafeManha,
            tempoPreparoMinutos: 10,
          ),
          Refeicao(
            id: 'cafe2',
            nome: 'Pão Integral com Ovo',
            descricao: 'Sanduíche nutritivo para começar o dia',
            ingredientes: ['Pão integral', 'Ovo', 'Tomate', 'Alface', 'Azeite'],
            quantidades: {
              'Pão integral': '2 fatias',
              'Ovo': '1 unidade',
              'Tomate': '2 fatias',
              'Alface': '2 folhas',
              'Azeite': '1 fio'
            },
            tipo: TipoRefeicao.cafeManha,
            tempoPreparoMinutos: 15,
          ),
        ];
      case TipoRefeicao.almoco:
        return [
          Refeicao(
            id: 'almoco1',
            nome: 'Arroz com Frango Grelhado',
            descricao: 'Refeição balanceada com proteína e carboidrato',
            ingredientes: ['Arroz', 'Peito de frango', 'Brócolis', 'Cenoura', 'Azeite'],
            quantidades: {
              'Arroz': '1 xícara',
              'Peito de frango': '150g',
              'Brócolis': '100g',
              'Cenoura': '1 unidade',
              'Azeite': '1 colher de sopa'
            },
            tipo: TipoRefeicao.almoco,
            tempoPreparoMinutos: 30,
          ),
          Refeicao(
            id: 'almoco2',
            nome: 'Macarrão com Molho de Tomate',
            descricao: 'Massa italiana com vegetais',
            ingredientes: ['Macarrão', 'Tomate', 'Cebola', 'Alho', 'Manjericão'],
            quantidades: {
              'Macarrão': '100g',
              'Tomate': '3 unidades',
              'Cebola': '1/2 unidade',
              'Alho': '2 dentes',
              'Manjericão': 'a gosto'
            },
            tipo: TipoRefeicao.almoco,
            tempoPreparoMinutos: 25,
          ),
        ];
      case TipoRefeicao.jantar:
        return [
          Refeicao(
            id: 'jantar1',
            nome: 'Sopa de Legumes',
            descricao: 'Sopa nutritiva e leve para o jantar',
            ingredientes: ['Abóbora', 'Batata', 'Cenoura', 'Cebola', 'Caldo de legumes'],
            quantidades: {
              'Abóbora': '200g',
              'Batata': '1 unidade',
              'Cenoura': '1 unidade',
              'Cebola': '1/2 unidade',
              'Caldo de legumes': '500ml'
            },
            tipo: TipoRefeicao.jantar,
            tempoPreparoMinutos: 40,
          ),
          Refeicao(
            id: 'jantar2',
            nome: 'Peixe Assado com Salada',
            descricao: 'Refeição leve e saudável',
            ingredientes: ['Filé de peixe', 'Alface', 'Tomate', 'Pepino', 'Limão'],
            quantidades: {
              'Filé de peixe': '150g',
              'Alface': '4 folhas',
              'Tomate': '1 unidade',
              'Pepino': '1/2 unidade',
              'Limão': '1/2 unidade'
            },
            tipo: TipoRefeicao.jantar,
            tempoPreparoMinutos: 35,
          ),
        ];
      case TipoRefeicao.lanche:
        return [
          Refeicao(
            id: 'lanche1',
            nome: 'Vitamina de Frutas',
            descricao: 'Lanche saudável e refrescante',
            ingredientes: ['Banana', 'Morango', 'Leite', 'Mel'],
            quantidades: {
              'Banana': '1 unidade',
              'Morango': '5 unidades',
              'Leite': '200ml',
              'Mel': '1 colher de chá'
            },
            tipo: TipoRefeicao.lanche,
            tempoPreparoMinutos: 5,
          ),
          Refeicao(
            id: 'lanche2',
            nome: 'Iogurte com Granola',
            descricao: 'Lanche prático e nutritivo',
            ingredientes: ['Iogurte natural', 'Granola', 'Mel', 'Frutas vermelhas'],
            quantidades: {
              'Iogurte natural': '1 pote',
              'Granola': '2 colheres de sopa',
              'Mel': '1 colher de chá',
              'Frutas vermelhas': '50g'
            },
            tipo: TipoRefeicao.lanche,
            tempoPreparoMinutos: 3,
          ),
        ];
      case TipoRefeicao.ceia:
        return [
          Refeicao(
            id: 'ceia1',
            nome: 'Chá com Biscoitos',
            descricao: 'Ceia leve para antes de dormir',
            ingredientes: ['Chá de camomila', 'Biscoitos integrais'],
            quantidades: {
              'Chá de camomila': '1 xícara',
              'Biscoitos integrais': '2 unidades'
            },
            tipo: TipoRefeicao.ceia,
            tempoPreparoMinutos: 5,
          ),
        ];
    }
  }

  /// Ajusta quantidade baseada no número de pessoas
  String _ajustarQuantidade(String quantidade, int totalPessoas) {
    // Lógica simples para ajustar quantidades
    if (totalPessoas <= 2) return quantidade;
    if (totalPessoas <= 4) return quantidade.replaceAll('1 ', '2 ');
    return quantidade.replaceAll('1 ', '3 ');
  }

  /// Adiciona observações baseadas no perfil familiar
  String? _adicionarObservacoesPerfil(PerfilFamiliar perfil) {
    final observacoes = <String>[];
    
    if (perfil.numeroCriancas > 0) {
      observacoes.add('Adaptado para crianças');
    }
    
    if (perfil.restricoesAlimentares.isNotEmpty) {
      observacoes.add('Considerando restrições: ${perfil.restricoesAlimentares.map((r) => r.name).join(', ')}');
    }
    
    return observacoes.isNotEmpty ? observacoes.join('. ') : null;
  }

  /// Formata data para nome do menu
  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}';
  }
}