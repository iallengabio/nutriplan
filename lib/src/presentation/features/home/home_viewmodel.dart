import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider para o HomeViewModel
final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>(
  (ref) => HomeViewModel(),
);

// Estado do Home
class HomeState {
  final int numeroAdultos;
  final int numeroCriancas;
  final Set<String> restricoesAlimentares;
  final List<String> cardapios;
  final List<String> listas;

  const HomeState({
    this.numeroAdultos = 2,
    this.numeroCriancas = 1,
    this.restricoesAlimentares = const {},
    this.cardapios = const [],
    this.listas = const [],
  });

  HomeState copyWith({
    int? numeroAdultos,
    int? numeroCriancas,
    Set<String>? restricoesAlimentares,
    List<String>? cardapios,
    List<String>? listas,
  }) {
    return HomeState(
      numeroAdultos: numeroAdultos ?? this.numeroAdultos,
      numeroCriancas: numeroCriancas ?? this.numeroCriancas,
      restricoesAlimentares: restricoesAlimentares ?? this.restricoesAlimentares,
      cardapios: cardapios ?? this.cardapios,
      listas: listas ?? this.listas,
    );
  }
}

// ViewModel do Home
class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel() : super(const HomeState());

  // Métodos para gerenciar o perfil familiar
  void updateNumeroAdultos(int numero) {
    state = state.copyWith(numeroAdultos: numero);
  }

  void updateNumeroCriancas(int numero) {
    state = state.copyWith(numeroCriancas: numero);
  }

  void toggleRestricaoAlimentar(String restricao) {
    final novasRestricoes = Set<String>.from(state.restricoesAlimentares);
    if (novasRestricoes.contains(restricao)) {
      novasRestricoes.remove(restricao);
    } else {
      novasRestricoes.add(restricao);
    }
    state = state.copyWith(restricoesAlimentares: novasRestricoes);
  }

  void salvarPerfil() {
    // TODO: Implementar salvamento do perfil
    // Aqui seria feita a persistência dos dados
  }

  // Métodos para gerenciar cardápios
  void adicionarCardapio(String cardapio) {
    final novosCardapios = List<String>.from(state.cardapios);
    novosCardapios.add(cardapio);
    state = state.copyWith(cardapios: novosCardapios);
  }

  void removerCardapio(String cardapio) {
    final novosCardapios = List<String>.from(state.cardapios);
    novosCardapios.remove(cardapio);
    state = state.copyWith(cardapios: novosCardapios);
  }

  // Métodos para gerenciar listas de compras
  void adicionarLista(String lista) {
    final novasListas = List<String>.from(state.listas);
    novasListas.add(lista);
    state = state.copyWith(listas: novasListas);
  }

  void removerLista(String lista) {
    final novasListas = List<String>.from(state.listas);
    novasListas.remove(lista);
    state = state.copyWith(listas: novasListas);
  }

  void duplicarLista(String lista) {
    final novasListas = List<String>.from(state.listas);
    novasListas.add('$lista (Cópia)');
    state = state.copyWith(listas: novasListas);
  }
}