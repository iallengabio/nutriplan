import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/menu.dart';
import '../../../../domain/models/perfil_familiar.dart';
import '../../../../domain/models/refeicao.dart';
import '../../../../domain/models/shopping_list.dart';
import '../../../../domain/repositories/menu_repository.dart';
import '../../../../domain/repositories/shopping_list_repository.dart';

// Estado do Menu
class MenuState {
  final List<Menu> menus;
  final bool isLoading;
  final String? errorMessage;
  final Menu? menuSelecionado;
  final bool isGeneratingMenu;
  final bool isSaving;
  final Refeicao? refeicaoAlternativaGerada;
  // Mapa para controlar carregamento individual de refeições
  // Chave: "dia_indice" (ex: "segunda_0", "terca_1")
  final Map<String, bool> refeicaoCarregando;

  const MenuState({
    this.menus = const [],
    this.isLoading = false,
    this.errorMessage,
    this.menuSelecionado,
    this.isGeneratingMenu = false,
    this.isSaving = false,
    this.refeicaoAlternativaGerada,
    this.refeicaoCarregando = const {},
  });

  MenuState copyWith({
    List<Menu>? menus,
    bool? isLoading,
    String? errorMessage,
    Menu? menuSelecionado,
    bool? isGeneratingMenu,
    bool? isSaving,
    Refeicao? refeicaoAlternativaGerada,
    Map<String, bool>? refeicaoCarregando,
    bool clearError = false,
    bool clearMenuSelecionado = false,
    bool clearRefeicaoAlternativa = false,
  }) {
    return MenuState(
      menus: menus ?? this.menus,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      menuSelecionado: clearMenuSelecionado ? null : (menuSelecionado ?? this.menuSelecionado),
      isGeneratingMenu: isGeneratingMenu ?? this.isGeneratingMenu,
      isSaving: isSaving ?? this.isSaving,
      refeicaoAlternativaGerada: clearRefeicaoAlternativa ? null : (refeicaoAlternativaGerada ?? this.refeicaoAlternativaGerada),
      refeicaoCarregando: refeicaoCarregando ?? this.refeicaoCarregando,
    );
  }
}

// ViewModel do Menu
class MenuViewModel extends StateNotifier<MenuState> {
  final MenuRepository _menuRepository;
  final ShoppingListRepository _shoppingListRepository;

  MenuViewModel(
    this._menuRepository,
    this._shoppingListRepository,
  ) : super(const MenuState());

  /// Carrega todos os cardápios salvos
  Future<void> carregarMenus() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _menuRepository.listarMenus();
    
    result.fold(
      (menus) {
        state = state.copyWith(
          menus: menus,
          isLoading: false,
        );
      },
      (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Erro ao carregar cardápios: ${error.toString()}',
        );
      },
    );
  }

  /// Gera um novo cardápio baseado no perfil familiar
  Future<void> gerarMenu({
    required PerfilFamiliar perfil,
    required Set<TipoRefeicao> tiposRefeicao,
    String? nome,
    String? observacoesAdicionais,
    int? numberOfPeople,
  }) async {
    state = state.copyWith(isGeneratingMenu: true, clearError: true);

    final result = await _menuRepository.gerarMenu(
      perfil: perfil,
      tiposRefeicao: tiposRefeicao,
      nome: nome,
      observacoesAdicionais: observacoesAdicionais,
      numberOfPeople: numberOfPeople,
    );

    await result.fold(
      (menu) async {
        // Salva automaticamente o cardápio gerado usando ID gerado pelo Firebase
        final saveResult = await _menuRepository.salvarNovoMenu(menu);
        
        await saveResult.fold(
          (menuSalvo) {
            // Atualiza a lista de menus com o novo cardápio salvo (com ID do Firebase)
            final menusAtualizados = List<Menu>.from(state.menus);
            menusAtualizados.insert(0, menuSalvo); // Adiciona no início
            
            state = state.copyWith(
              isGeneratingMenu: false,
              menuSelecionado: menuSalvo,
              menus: menusAtualizados,
            );
          },
          (saveError) {
            // Se falhar ao salvar, ainda mantém o menu selecionado mas mostra erro
            state = state.copyWith(
              isGeneratingMenu: false,
              menuSelecionado: menu,
              errorMessage: 'Cardápio gerado mas não foi possível salvar: ${saveError.toString()}',
            );
          },
        );
      },
      (error) {
        state = state.copyWith(
          isGeneratingMenu: false,
          errorMessage: 'Erro ao gerar cardápio: ${error.toString()}',
        );
      },
    );
  }

  /// Salva um cardápio
  Future<void> salvarMenu(Menu menu) async {
    state = state.copyWith(isSaving: true, clearError: true);

    final result = await _menuRepository.salvarMenu(menu);

    result.fold(
      (_) {
        // Atualiza a lista de menus
        final menusAtualizados = List<Menu>.from(state.menus);
        final index = menusAtualizados.indexWhere((m) => m.id == menu.id);
        
        if (index >= 0) {
          menusAtualizados[index] = menu;
        } else {
          menusAtualizados.insert(0, menu); // Adiciona no início
        }

        state = state.copyWith(
          menus: menusAtualizados,
          isSaving: false,
        );
      },
      (error) {
        state = state.copyWith(
          isSaving: false,
          errorMessage: 'Erro ao salvar cardápio: ${error.toString()}',
        );
      },
    );
  }

  /// Busca um cardápio por ID
  Future<void> buscarMenuPorId(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _menuRepository.buscarMenuPorId(id);

    result.fold(
      (menu) {
        state = state.copyWith(
          isLoading: false,
          menuSelecionado: menu,
        );
      },
      (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Cardápio não encontrado',
        );
      },
    );
  }

  /// Atualiza um cardápio existente
  Future<void> atualizarMenu(Menu menu) async {
    state = state.copyWith(isSaving: true, clearError: true);

    final result = await _menuRepository.atualizarMenu(menu);

    result.fold(
      (_) {
        // Atualiza a lista de menus
        final menusAtualizados = List<Menu>.from(state.menus);
        final index = menusAtualizados.indexWhere((m) => m.id == menu.id);
        
        if (index >= 0) {
          menusAtualizados[index] = menu;
        }

        state = state.copyWith(
          menus: menusAtualizados,
          menuSelecionado: menu,
          isSaving: false,
        );
      },
      (error) {
        state = state.copyWith(
          isSaving: false,
          errorMessage: 'Erro ao atualizar cardápio: ${error.toString()}',
        );
      },
    );
  }

  /// Remove um cardápio
  Future<void> removerMenu(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _menuRepository.removerMenu(id);

    result.fold(
      (_) {
        final menusAtualizados = state.menus.where((m) => m.id != id).toList();
        
        state = state.copyWith(
          menus: menusAtualizados,
          isLoading: false,
        );
      },
      (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Erro ao remover cardápio: ${error.toString()}',
        );
      },
    );
  }

  /// Duplica um cardápio
  Future<void> duplicarMenu(String menuId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _menuRepository.duplicarMenu(menuId);

    result.fold(
      (menuDuplicado) {
        final menusAtualizados = List<Menu>.from(state.menus);
        menusAtualizados.insert(0, menuDuplicado); // Adiciona no início

        state = state.copyWith(
          menus: menusAtualizados,
          isLoading: false,
        );
      },
      (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Erro ao duplicar cardápio: ${error.toString()}',
        );
      },
    );
  }

  /// Gera uma refeição alternativa (método legado)
  Future<void> gerarRefeicaoAlternativa({
    required PerfilFamiliar perfil,
    required TipoRefeicao tipo,
    String? observacoesAdicionais,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, clearRefeicaoAlternativa: true);

    final result = await _menuRepository.gerarRefeicaoAlternativa(
      perfil: perfil,
      tipo: tipo,
      observacoesAdicionais: observacoesAdicionais,
    );

    result.fold(
      (refeicao) {
        state = state.copyWith(
          isLoading: false,
          refeicaoAlternativaGerada: refeicao,
        );
      },
      (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Erro ao gerar refeição alternativa: ${error.toString()}',
        );
      },
    );
  }

  /// Gera uma refeição alternativa com contexto completo
  Future<void> gerarRefeicaoAlternativaComContexto({
    required DiaSemana dia,
    required int indiceRefeicao,
    required TipoRefeicao tipo,
    required PerfilFamiliar perfil,
    String? observacoesAdicionais,
  }) async {
    if (state.menuSelecionado == null) {
      state = state.copyWith(
        errorMessage: 'Nenhum cardápio selecionado para gerar alternativa',
      );
      return;
    }

    final chaveRefeicao = '${dia.name}_$indiceRefeicao';
    
    // Atualiza o estado de carregamento para esta refeição específica
    final novoCarregamento = Map<String, bool>.from(state.refeicaoCarregando);
    novoCarregamento[chaveRefeicao] = true;
    
    state = state.copyWith(
      refeicaoCarregando: novoCarregamento,
      clearError: true,
      clearRefeicaoAlternativa: true,
    );

    try {
      // Chama o novo método do repository com contexto completo
      final result = await _menuRepository.gerarRefeicaoAlternativaComContexto(
        perfil: perfil,
        tipo: tipo,
        menu: state.menuSelecionado!,
        dia: dia,
        indiceRefeicao: indiceRefeicao,
        observacoesAdicionais: observacoesAdicionais,
      );

      result.fold(
        (refeicao) {
          // Atualiza a refeição no menu selecionado
          atualizarRefeicaoNoMenu(
            dia: dia,
            indiceRefeicao: indiceRefeicao,
            novaRefeicao: refeicao,
          );
          
          // Remove o estado de carregamento
          final carregamentoAtualizado = Map<String, bool>.from(state.refeicaoCarregando);
          carregamentoAtualizado.remove(chaveRefeicao);
          
          state = state.copyWith(
            refeicaoCarregando: carregamentoAtualizado,
            refeicaoAlternativaGerada: refeicao,
          );
        },
        (error) {
          // Remove o estado de carregamento em caso de erro
          final carregamentoAtualizado = Map<String, bool>.from(state.refeicaoCarregando);
          carregamentoAtualizado.remove(chaveRefeicao);
          
          state = state.copyWith(
            refeicaoCarregando: carregamentoAtualizado,
            errorMessage: 'Erro ao gerar refeição alternativa: ${error.toString()}',
          );
        },
      );
    } catch (e) {
      // Remove o estado de carregamento em caso de exceção
      final carregamentoAtualizado = Map<String, bool>.from(state.refeicaoCarregando);
      carregamentoAtualizado.remove(chaveRefeicao);
      
      state = state.copyWith(
        refeicaoCarregando: carregamentoAtualizado,
        errorMessage: 'Erro inesperado ao gerar refeição alternativa: $e',
      );
    }
  }

  /// Verifica se uma refeição específica está carregando
  bool isRefeicaoCarregando(DiaSemana dia, int indiceRefeicao) {
    final chave = '${dia.name}_$indiceRefeicao';
    return state.refeicaoCarregando[chave] ?? false;
  }

  /// Limpa todos os estados de carregamento de refeições
  void limparCarregamentoRefeicoes() {
    state = state.copyWith(refeicaoCarregando: {});
  }

  /// Marca/desmarca um cardápio como favorito
  Future<void> toggleFavorito(String menuId) async {
    final menu = state.menus.firstWhere((m) => m.id == menuId);
    final menuAtualizado = menu.copyWith(isFavorito: !menu.isFavorito);
    
    await atualizarMenu(menuAtualizado);
  }

  /// Seleciona um menu para edição
  void selecionarMenu(Menu menu) {
    state = state.copyWith(menuSelecionado: menu);
  }

  /// Limpa o menu selecionado
  void limparMenuSelecionado() {
    state = state.copyWith(clearMenuSelecionado: true);
  }

  /// Limpa mensagens de erro
  void limparErro() {
    state = state.copyWith(clearError: true);
  }

  /// Limpa a refeição alternativa gerada
  void limparRefeicaoAlternativa() {
    state = state.copyWith(clearRefeicaoAlternativa: true);
  }

  /// Atualiza uma refeição específica no menu selecionado
  void atualizarRefeicaoNoMenu({
    required DiaSemana dia,
    required int indiceRefeicao,
    required Refeicao novaRefeicao,
  }) {
    if (state.menuSelecionado == null) return;

    final menu = state.menuSelecionado!;
    final refeicoesDoDia = List<Refeicao>.from(menu.refeicoesPorDia[dia] ?? []);
    
    if (indiceRefeicao < refeicoesDoDia.length) {
      refeicoesDoDia[indiceRefeicao] = novaRefeicao;
      
      final novoRefeicoesPorDia = Map<DiaSemana, List<Refeicao>>.from(menu.refeicoesPorDia);
      novoRefeicoesPorDia[dia] = refeicoesDoDia;
      
      final menuAtualizado = menu.copyWith(
        refeicoesPorDia: novoRefeicoesPorDia,
        dataUltimaEdicao: DateTime.now(),
      );
      
      state = state.copyWith(menuSelecionado: menuAtualizado);
    }
  }

  /// Gera uma lista de compras baseada em um cardápio
  Future<ShoppingList?> gerarListaComprasDoMenu({
    required String menuId,
    required int numeroSemanas,
    String? nomePersonalizado,
    String? observacoes,
  }) async {
    try {
      // Busca o menu pelo ID
      final menuResult = await _menuRepository.buscarMenuPorId(menuId);
      
      return await menuResult.fold(
        (menu) async {
          // Gera a lista de compras baseada no menu
          final listaResult = await _shoppingListRepository.gerarListaCompras(
            menu: menu,
            numeroSemanas: numeroSemanas,
            nome: nomePersonalizado,
            observacoes: observacoes,
          );
          
          return listaResult.fold(
            (lista) => lista,
            (error) {
              state = state.copyWith(
                errorMessage: 'Erro ao gerar lista de compras: ${error.toString()}',
              );
              return null;
            },
          );
        },
        (error) {
          state = state.copyWith(
            errorMessage: 'Erro ao buscar cardápio: ${error.toString()}',
          );
          return null;
        },
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Erro inesperado ao gerar lista de compras: $e',
      );
      return null;
    }
  }

  /// Gera e salva uma lista de compras baseada em um cardápio
  Future<ShoppingList?> gerarESalvarListaCompras({
    required String menuId,
    required int numeroSemanas,
    String? nomePersonalizado,
    String? observacoes,
  }) async {
    final lista = await gerarListaComprasDoMenu(
      menuId: menuId,
      numeroSemanas: numeroSemanas,
      nomePersonalizado: nomePersonalizado,
      observacoes: observacoes,
    );
    
    if (lista != null) {
      // Salva a lista gerada
      final saveResult = await _shoppingListRepository.salvarNovaListaCompras(lista);
      
      return saveResult.fold(
        (listaSalva) => listaSalva,
        (error) {
          state = state.copyWith(
            errorMessage: 'Erro ao salvar lista de compras: ${error.toString()}',
          );
          return null;
        },
      );
    }
    
    return null;
  }
}