import 'package:result_dart/result_dart.dart';
import '../models/menu.dart';
import '../models/perfil_familiar.dart';
import '../models/refeicao.dart';

/// Interface para o serviço de API de IA
abstract class AiApiService {
  /// Gera um cardápio completo baseado no perfil familiar
  Future<Result<Menu>> gerarCardapio({
    required PerfilFamiliar perfil,
    required Set<TipoRefeicao> tiposRefeicao,
    String? nome,
    String? observacoesAdicionais,
  });

  /// Gera uma refeição alternativa
  Future<Result<Refeicao>> gerarRefeicaoAlternativa({
    required PerfilFamiliar perfil,
    required TipoRefeicao tipo,
    String? observacoesAdicionais,
  });
}

/// Erros específicos do serviço de IA
sealed class AiServiceError implements Exception {
  const AiServiceError();
}

/// Erro de rede/conectividade
class AiNetworkError extends AiServiceError {
  final String message;
  const AiNetworkError(this.message);

  @override
  String toString() => 'AiNetworkError: $message';
}

/// Erro da API de IA
class AiApiServiceError extends AiServiceError {
  final String message;
  final int? statusCode;
  const AiApiServiceError(this.message, [this.statusCode]);

  @override
  String toString() => 'AiApiServiceError: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Limite de uso da API atingido
class AiRateLimitError extends AiServiceError {
  final String message;
  const AiRateLimitError(this.message);

  @override
  String toString() => 'AiRateLimitError: $message';
}

/// Erro de validação dos dados de entrada
class AiValidationError extends AiServiceError {
  final String message;
  const AiValidationError(this.message);

  @override
  String toString() => 'AiValidationError: $message';
}