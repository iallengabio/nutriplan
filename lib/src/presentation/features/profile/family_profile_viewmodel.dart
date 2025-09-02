import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/perfil_familiar.dart';
import '../../../domain/repositories/family_profile_repository.dart';

// Estado do Perfil Familiar
class FamilyProfileState {
  final PerfilFamiliar? perfil;
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final bool hasChanges;

  const FamilyProfileState({
    this.perfil,
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.hasChanges = false,
  });

  FamilyProfileState copyWith({
    PerfilFamiliar? perfil,
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    bool? hasChanges,
    bool clearError = false,
    bool clearPerfil = false,
  }) {
    return FamilyProfileState(
      perfil: clearPerfil ? null : (perfil ?? this.perfil),
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }
}

// ViewModel do Perfil Familiar
class FamilyProfileViewModel extends StateNotifier<FamilyProfileState> {
  final FamilyProfileRepository _repository;

  FamilyProfileViewModel(this._repository) : super(const FamilyProfileState());

  /// Carrega o perfil familiar do usuário
  Future<void> carregarPerfil() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.carregarPerfilFamiliar();
    
    result.fold(
      (perfil) {
        state = state.copyWith(
          perfil: perfil,
          isLoading: false,
          hasChanges: false,
        );
      },
      (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Erro ao carregar perfil: ${error.toString()}',
        );
      },
    );
  }

  /// Salva o perfil familiar
  Future<bool> salvarPerfil() async {
    if (state.perfil == null) return false;

    state = state.copyWith(isSaving: true, clearError: true);

    final result = await _repository.salvarPerfilFamiliar(state.perfil!);
    
    return result.fold(
      (success) {
        state = state.copyWith(
          isSaving: false,
          hasChanges: false,
        );
        return true;
      },
      (error) {
        state = state.copyWith(
          isSaving: false,
          errorMessage: 'Erro ao salvar perfil: ${error.toString()}',
        );
        return false;
      },
    );
  }

  /// Atualiza o número de adultos
  void atualizarNumeroAdultos(int numero) {
    if (state.perfil == null) return;
    
    final perfilAtualizado = state.perfil!.copyWith(numeroAdultos: numero);
    state = state.copyWith(
      perfil: perfilAtualizado,
      hasChanges: true,
    );
  }

  /// Atualiza o número de crianças
  void atualizarNumeroCriancas(int numero) {
    if (state.perfil == null) return;
    
    final perfilAtualizado = state.perfil!.copyWith(numeroCriancas: numero);
    state = state.copyWith(
      perfil: perfilAtualizado,
      hasChanges: true,
    );
  }

  /// Adiciona uma restrição alimentar
  void adicionarRestricao(RestricaoAlimentar restricao) {
    if (state.perfil == null) return;
    
    final perfilAtualizado = state.perfil!.adicionarRestricao(restricao);
    state = state.copyWith(
      perfil: perfilAtualizado,
      hasChanges: true,
    );
  }

  /// Remove uma restrição alimentar
  void removerRestricao(RestricaoAlimentar restricao) {
    if (state.perfil == null) return;
    
    final perfilAtualizado = state.perfil!.removerRestricao(restricao);
    state = state.copyWith(
      perfil: perfilAtualizado,
      hasChanges: true,
    );
  }

  /// Atualiza as observações adicionais
  void atualizarObservacoes(String? observacoes) {
    if (state.perfil == null) return;
    
    final perfilAtualizado = state.perfil!.copyWith(observacoesAdicionais: observacoes);
    state = state.copyWith(
      perfil: perfilAtualizado,
      hasChanges: true,
    );
  }

  /// Reseta as mudanças para o estado original
  void resetarMudancas() {
    // Recarrega o perfil do repositório
    carregarPerfil();
  }

  /// Limpa mensagens de erro
  void limparErro() {
    state = state.copyWith(clearError: true);
  }

  /// Verifica se o usuário possui perfil familiar
  Future<bool> possuiPerfil() async {
    final result = await _repository.possuiPerfilFamiliar();
    return result.fold(
      (possui) => possui,
      (error) => false,
    );
  }

  /// Cria um perfil padrão para o usuário
  Future<bool> criarPerfilPadrao(String userId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.criarPerfilPadrao(userId);
    
    return result.fold(
      (perfil) {
        state = state.copyWith(
          perfil: perfil,
          isLoading: false,
          hasChanges: false,
        );
        return true;
      },
      (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Erro ao criar perfil padrão: ${error.toString()}',
        );
        return false;
      },
    );
  }
}