import 'package:result_dart/result_dart.dart';
import '../models/shopping_list.dart';
import '../models/menu.dart';

/// Interface para o repositório de listas de compras
abstract class ShoppingListRepository {
  /// Gera uma nova lista de compras baseada em um cardápio
  Future<Result<ShoppingList>> gerarListaCompras({
    required Menu menu,
    required int numeroSemanas,
    String? nome,
    String? observacoes,
  });

  /// Salva uma lista de compras localmente
  Future<Result<void>> salvarListaCompras(ShoppingList lista);

  /// Salva uma nova lista permitindo que o Firebase gere o ID automaticamente
  Future<Result<ShoppingList>> salvarNovaListaCompras(ShoppingList lista);

  /// Lista todas as listas de compras salvas
  Future<Result<List<ShoppingList>>> listarListasCompras();

  /// Busca uma lista de compras por ID
  Future<Result<ShoppingList>> buscarListaCompraPorId(String id);

  /// Atualiza uma lista de compras existente
  Future<Result<void>> atualizarListaCompras(ShoppingList lista);

  /// Remove uma lista de compras
  Future<Result<void>> removerListaCompras(String id);

  /// Duplica uma lista de compras existente
  Future<Result<ShoppingList>> duplicarListaCompras(String listaId);

  /// Adiciona um item à lista de compras
  Future<Result<void>> adicionarItem(String listaId, ShoppingItem item);

  /// Remove um item da lista de compras
  Future<Result<void>> removerItem(String listaId, String itemId);

  /// Atualiza um item da lista de compras
  Future<Result<void>> atualizarItem(String listaId, ShoppingItem item);

  /// Marca/desmarca um item como comprado
  Future<Result<void>> marcarItemComprado(String listaId, String itemId, bool comprado);
}

/// Erros possíveis do repositório de listas de compras
sealed class ShoppingListRepositoryError {
  const ShoppingListRepositoryError();
}

/// Erro de rede/conectividade
class ShoppingListNetworkError extends ShoppingListRepositoryError {
  final String message;
  const ShoppingListNetworkError(this.message);
}

/// Erro de autenticação
class ShoppingListAuthError extends ShoppingListRepositoryError {
  final String message;
  const ShoppingListAuthError(this.message);
}

/// Erro de validação
class ShoppingListValidationError extends ShoppingListRepositoryError {
  final String message;
  const ShoppingListValidationError(this.message);
}

/// Lista não encontrada
class ShoppingListNotFoundError extends ShoppingListRepositoryError {
  final String listaId;
  const ShoppingListNotFoundError(this.listaId);
}

/// Erro da API de IA
class ShoppingListAIError extends ShoppingListRepositoryError {
  final String message;
  const ShoppingListAIError(this.message);
}

/// Erro de limite de uso da API
class ShoppingListRateLimitError extends ShoppingListRepositoryError {
  final String message;
  const ShoppingListRateLimitError(this.message);
}

/// Erro genérico
class ShoppingListGenericError extends ShoppingListRepositoryError {
  final String message;
  const ShoppingListGenericError(this.message);
}