import 'package:result_dart/result_dart.dart';
import '../models/menu.dart';
import '../models/perfil_familiar.dart';
import '../models/refeicao.dart';

/// Interface para o repositório de cardápios
abstract class MenuRepository {
  /// Gera um novo cardápio baseado no perfil familiar e configurações
  Future<Result<Menu>> gerarMenu({
    required PerfilFamiliar perfil,
    required Set<TipoRefeicao> tiposRefeicao,
    String? nome,
    String? observacoesAdicionais,
    int? numberOfPeople,
  });

  /// Salva um cardápio localmente
  Future<Result<void>> salvarMenu(Menu menu);

  /// Salva um novo cardápio permitindo que o Firebase gere o ID automaticamente
  Future<Result<Menu>> salvarNovoMenu(Menu menu);

  /// Lista todos os cardápios salvos
  Future<Result<List<Menu>>> listarMenus();

  /// Busca um cardápio por ID
  Future<Result<Menu>> buscarMenuPorId(String id);

  /// Atualiza um cardápio existente
  Future<Result<void>> atualizarMenu(Menu menu);

  /// Remove um cardápio
  Future<Result<void>> removerMenu(String id);

  /// Gera uma refeição alternativa para substituir uma existente
  Future<Result<Refeicao>> gerarRefeicaoAlternativa({
    required PerfilFamiliar perfil,
    required TipoRefeicao tipo,
    String? observacoesAdicionais,
  });

  /// Duplica um cardápio existente
  Future<Result<Menu>> duplicarMenu(String menuId);
}

/// Erros possíveis do repositório de cardápios
sealed class MenuRepositoryError {
  const MenuRepositoryError();
}

/// Erro de rede/conectividade
class NetworkError extends MenuRepositoryError {
  final String message;
  const NetworkError(this.message);

  @override
  String toString() => 'NetworkError: $message';
}

/// Erro da API de IA
class AiApiError extends MenuRepositoryError {
  final String message;
  final int? statusCode;
  const AiApiError(this.message, [this.statusCode]);

  @override
  String toString() => 'AiApiError: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Erro de armazenamento local
class StorageError extends MenuRepositoryError {
  final String message;
  const StorageError(this.message);

  @override
  String toString() => 'StorageError: $message';
}

/// Erro de validação
class ValidationError extends MenuRepositoryError {
  final String message;
  const ValidationError(this.message);

  @override
  String toString() => 'ValidationError: $message';
}

/// Cardápio não encontrado
class MenuNotFoundError extends MenuRepositoryError {
  final String menuId;
  const MenuNotFoundError(this.menuId);

  @override
  String toString() => 'MenuNotFoundError: Menu with ID $menuId not found';
}

/// Limite de uso da API atingido
class RateLimitError extends MenuRepositoryError {
  final String message;
  const RateLimitError(this.message);

  @override
  String toString() => 'RateLimitError: $message';
}

/// Erro genérico
class UnknownError extends MenuRepositoryError {
  final String message;
  const UnknownError(this.message);

  @override
  String toString() => 'UnknownError: $message';
}