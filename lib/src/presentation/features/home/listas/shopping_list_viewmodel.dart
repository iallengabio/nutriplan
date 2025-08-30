import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/shopping_list.dart';
import '../../../../domain/models/menu.dart';
import '../../../../domain/repositories/shopping_list_repository.dart';
import '../../../../core/services/file_sharing_service.dart';

// Estado da Lista de Compras
class ShoppingListState {
  final List<ShoppingList> shoppingLists;
  final bool isLoading;
  final String? errorMessage;
  final ShoppingList? shoppingListSelecionada;
  final bool isGeneratingList;
  final bool isSaving;
  final bool isUpdatingItem;

  const ShoppingListState({
    this.shoppingLists = const [],
    this.isLoading = false,
    this.errorMessage,
    this.shoppingListSelecionada,
    this.isGeneratingList = false,
    this.isSaving = false,
    this.isUpdatingItem = false,
  });

  ShoppingListState copyWith({
    List<ShoppingList>? shoppingLists,
    bool? isLoading,
    String? errorMessage,
    ShoppingList? shoppingListSelecionada,
    bool? isGeneratingList,
    bool? isSaving,
    bool? isUpdatingItem,
    bool clearError = false,
    bool clearShoppingListSelecionada = false,
  }) {
    return ShoppingListState(
      shoppingLists: shoppingLists ?? this.shoppingLists,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      shoppingListSelecionada: clearShoppingListSelecionada ? null : (shoppingListSelecionada ?? this.shoppingListSelecionada),
      isGeneratingList: isGeneratingList ?? this.isGeneratingList,
      isSaving: isSaving ?? this.isSaving,
      isUpdatingItem: isUpdatingItem ?? this.isUpdatingItem,
    );
  }
}

// ViewModel da Lista de Compras
class ShoppingListViewModel extends StateNotifier<ShoppingListState> {
  final ShoppingListRepository _shoppingListRepository;

  ShoppingListViewModel(this._shoppingListRepository) : super(const ShoppingListState());

  /// Carrega todas as listas de compras salvas
  Future<void> carregarListasDeCompras() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _shoppingListRepository.listarListasCompras();
    
    result.fold(
      (listas) {
        state = state.copyWith(
          shoppingLists: listas,
          isLoading: false,
        );
      },
      (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Erro ao carregar listas de compras: ${error.toString()}',
        );
      },
    );
  }

  /// Gera uma nova lista de compras baseada em um cardápio
  Future<void> gerarListaDeCompras({
    required Menu menu,
    required int numeroSemanas,
    String? nome,
  }) async {
    state = state.copyWith(isGeneratingList: true, clearError: true);

    final result = await _shoppingListRepository.gerarListaCompras(
      menu: menu,
      numeroSemanas: numeroSemanas,
      nome: nome,
    );

    await result.fold(
      (shoppingList) async {
        // Salva automaticamente a lista gerada usando ID gerado pelo Firebase
        final saveResult = await _shoppingListRepository.salvarNovaListaCompras(shoppingList);
        
        await saveResult.fold(
          (listaSalva) {
            // Atualiza a lista de listas com a nova lista salva (com ID do Firebase)
            final listasAtualizadas = List<ShoppingList>.from(state.shoppingLists);
            listasAtualizadas.insert(0, listaSalva); // Adiciona no início
            
            state = state.copyWith(
              isGeneratingList: false,
              shoppingListSelecionada: listaSalva,
              shoppingLists: listasAtualizadas,
            );
          },
          (saveError) {
            // Se falhar ao salvar, ainda mantém a lista selecionada mas mostra erro
            state = state.copyWith(
              isGeneratingList: false,
              shoppingListSelecionada: shoppingList,
              errorMessage: 'Lista gerada mas erro ao salvar: ${saveError.toString()}',
            );
          },
        );
      },
      (error) {
        state = state.copyWith(
          isGeneratingList: false,
          errorMessage: 'Erro ao gerar lista de compras: ${error.toString()}',
        );
      },
    );
  }

  /// Busca uma lista de compras por ID
  Future<void> buscarListaDeComprasPorId(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _shoppingListRepository.buscarListaCompraPorId(id);
    
    result.fold(
      (shoppingList) {
        state = state.copyWith(
          isLoading: false,
          shoppingListSelecionada: shoppingList,
        );
      },
      (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Erro ao buscar lista de compras: ${error.toString()}',
        );
      },
    );
  }

  /// Atualiza uma lista de compras existente
  Future<void> atualizarListaDeCompras(ShoppingList shoppingList) async {
    state = state.copyWith(isSaving: true, clearError: true);

    final result = await _shoppingListRepository.atualizarListaCompras(shoppingList);
    
    result.fold(
      (_) {
        // Atualiza a lista na coleção local
        final listasAtualizadas = state.shoppingLists.map((lista) {
          return lista.id == shoppingList.id ? shoppingList : lista;
        }).toList();
        
        state = state.copyWith(
          isSaving: false,
          shoppingLists: listasAtualizadas,
          shoppingListSelecionada: state.shoppingListSelecionada?.id == shoppingList.id 
              ? shoppingList 
              : state.shoppingListSelecionada,
        );
      },
      (error) {
        state = state.copyWith(
          isSaving: false,
          errorMessage: 'Erro ao atualizar lista de compras: ${error.toString()}',
        );
      },
    );
  }

  /// Remove uma lista de compras
  Future<void> removerListaDeCompras(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _shoppingListRepository.removerListaCompras(id);
    
    result.fold(
      (_) {
        // Remove da lista local
        final listasAtualizadas = state.shoppingLists.where((lista) => lista.id != id).toList();
        
        state = state.copyWith(
          isLoading: false,
          shoppingLists: listasAtualizadas,
          // Limpa a seleção se a lista removida estava selecionada
          clearShoppingListSelecionada: state.shoppingListSelecionada?.id == id,
        );
      },
      (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Erro ao remover lista de compras: ${error.toString()}',
        );
      },
    );
  }

  /// Duplica uma lista de compras existente
  Future<void> duplicarListaDeCompras(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _shoppingListRepository.duplicarListaCompras(id);
    
    result.fold(
      (novaLista) {
        // Adiciona a nova lista no início da lista local
        final listasAtualizadas = List<ShoppingList>.from(state.shoppingLists);
        listasAtualizadas.insert(0, novaLista);
        
        state = state.copyWith(
          isLoading: false,
          shoppingLists: listasAtualizadas,
        );
      },
      (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Erro ao duplicar lista de compras: ${error.toString()}',
        );
      },
    );
  }

  /// Adiciona um novo item à lista de compras
  Future<void> adicionarItem(String listaId, ShoppingItem item) async {
    state = state.copyWith(isUpdatingItem: true, clearError: true);

    final result = await _shoppingListRepository.adicionarItem(listaId, item);
    
    result.fold(
      (_) {
        // Recarrega a lista para obter a versão atualizada
        buscarListaDeComprasPorId(listaId);
        state = state.copyWith(isUpdatingItem: false);
      },
      (error) {
        state = state.copyWith(
          isUpdatingItem: false,
          errorMessage: 'Erro ao adicionar item: ${error.toString()}',
        );
      },
    );
  }

  /// Remove um item da lista de compras
  Future<void> removerItem(String listaId, String itemId) async {
    state = state.copyWith(isUpdatingItem: true, clearError: true);

    final result = await _shoppingListRepository.removerItem(listaId, itemId);
    
    result.fold(
      (_) {
        // Recarrega a lista para obter a versão atualizada
        buscarListaDeComprasPorId(listaId);
        state = state.copyWith(isUpdatingItem: false);
      },
      (error) {
        state = state.copyWith(
          isUpdatingItem: false,
          errorMessage: 'Erro ao remover item: ${error.toString()}',
        );
      },
    );
  }

  /// Atualiza um item da lista de compras
  Future<void> atualizarItem(String listaId, ShoppingItem item) async {
    state = state.copyWith(isUpdatingItem: true, clearError: true);

    final result = await _shoppingListRepository.atualizarItem(listaId, item);
    
    result.fold(
      (_) {
        // Recarrega a lista para obter a versão atualizada
        buscarListaDeComprasPorId(listaId);
        state = state.copyWith(isUpdatingItem: false);
      },
      (error) {
        state = state.copyWith(
          isUpdatingItem: false,
          errorMessage: 'Erro ao atualizar item: ${error.toString()}',
        );
      },
    );
  }

  /// Marca/desmarca um item como comprado
  Future<void> marcarItemComoComprado(String listaId, String itemId, bool comprado) async {
    state = state.copyWith(isUpdatingItem: true, clearError: true);

    final result = await _shoppingListRepository.marcarItemComprado(listaId, itemId, comprado);
    
    result.fold(
      (_) {
        // Recarrega a lista para obter a versão atualizada
        buscarListaDeComprasPorId(listaId);
        state = state.copyWith(isUpdatingItem: false);
      },
      (error) {
        state = state.copyWith(
          isUpdatingItem: false,
          errorMessage: 'Erro ao marcar item: ${error.toString()}',
        );
      },
    );
  }

  /// Seleciona uma lista para edição
  void selecionarListaDeCompras(ShoppingList shoppingList) {
    state = state.copyWith(shoppingListSelecionada: shoppingList);
  }

  /// Cria uma nova lista de compras vazia
  Future<void> criarNovaLista(String nome) async {
    state = state.copyWith(isSaving: true, clearError: true);

    // Cria uma nova lista vazia
    final novaLista = ShoppingList(
      id: '', // O ID será gerado pelo Firebase
      nome: nome,
      itens: [],
      dataCriacao: DateTime.now(),
      menuId: '', // Lista criada manualmente, sem menu associado
      menuNome: 'Lista manual',
      numeroSemanas: 1,
      dataUltimaEdicao: DateTime.now(),
    );

    final result = await _shoppingListRepository.salvarNovaListaCompras(novaLista);
    
    result.fold(
      (listaSalva) {
        // Adiciona a nova lista no início da lista local
        final listasAtualizadas = List<ShoppingList>.from(state.shoppingLists ?? []);
        listasAtualizadas.insert(0, listaSalva);
        
        state = state.copyWith(
          isSaving: false,
          shoppingLists: listasAtualizadas,
          shoppingListSelecionada: listaSalva,
        );
      },
      (error) {
        state = state.copyWith(
          isSaving: false,
          errorMessage: 'Erro ao criar nova lista: ${error.toString()}',
        );
      },
    );
  }

  /// Limpa a lista selecionada
  void limparListaSelecionada() {
    state = state.copyWith(clearShoppingListSelecionada: true);
  }

  /// Limpa mensagens de erro
  void limparErro() {
    state = state.copyWith(clearError: true);
  }

  /// Compartilha uma lista de compras como arquivo .nutriplan
  Future<void> compartilharLista(ShoppingList shoppingList) async {
    try {
      await FileSharingService.shareShoppingList(shoppingList);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Erro ao compartilhar lista: ${e.toString()}',
      );
    }
  }

  /// Importa uma lista de compras de um arquivo .nutriplan
  Future<void> importarLista() async {
    state = state.copyWith(isLoading: true, clearError: true);
    
    try {
      final shoppingList = await FileSharingService.pickAndImportShoppingList();
      
      if (shoppingList != null) {
        // Salva a lista importada
        final result = await _shoppingListRepository.salvarNovaListaCompras(shoppingList);
        
        result.fold(
          (listaSalva) {
            // Adiciona a nova lista no início da lista local
            final listasAtualizadas = List<ShoppingList>.from(state.shoppingLists);
            listasAtualizadas.insert(0, listaSalva);
            
            state = state.copyWith(
              isLoading: false,
              shoppingLists: listasAtualizadas,
              shoppingListSelecionada: listaSalva,
            );
          },
          (error) {
            state = state.copyWith(
              isLoading: false,
              errorMessage: 'Erro ao salvar lista importada: ${error.toString()}',
            );
          },
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erro ao importar lista: ${e.toString()}',
      );
    }
  }

}