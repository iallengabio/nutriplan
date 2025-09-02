import 'package:result_dart/result_dart.dart';
import '../models/perfil_familiar.dart';

/// Interface para o repositório de perfil familiar
abstract class FamilyProfileRepository {
  /// Carrega o perfil familiar do usuário logado
  Future<Result<PerfilFamiliar>> carregarPerfilFamiliar();

  /// Salva o perfil familiar do usuário logado
  Future<Result<void>> salvarPerfilFamiliar(PerfilFamiliar perfil);

  /// Cria um perfil familiar padrão para um novo usuário
  Future<Result<PerfilFamiliar>> criarPerfilPadrao(String userId);

  /// Atualiza o perfil familiar existente
  Future<Result<void>> atualizarPerfilFamiliar(PerfilFamiliar perfil);

  /// Verifica se o usuário já possui um perfil familiar
  Future<Result<bool>> possuiPerfilFamiliar();
}