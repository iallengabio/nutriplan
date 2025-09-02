import 'package:result_dart/result_dart.dart';
import '../models/user.dart';
import '../models/perfil_familiar.dart';
import '../repositories/family_profile_repository.dart';

/// Serviço responsável pela inicialização de novos usuários
abstract class UserInitializationService {
  /// Inicializa um novo usuário criando seu perfil padrão
  Future<Result<void>> initializeNewUser(User user);
}

class UserInitializationServiceImpl implements UserInitializationService {
  final FamilyProfileRepository _familyProfileRepository;

  UserInitializationServiceImpl(this._familyProfileRepository);

  @override
  Future<Result<void>> initializeNewUser(User user) async {
    try {
      // Verifica se o usuário já possui um perfil
      final hasProfileResult = await _familyProfileRepository.possuiPerfilFamiliar();
      
      return hasProfileResult.fold(
        (hasProfile) async {
          if (!hasProfile) {
            // Cria perfil padrão para o novo usuário
            final createResult = await _familyProfileRepository.criarPerfilPadrao(user.id);
            
            return createResult.fold(
              (perfil) => const Success(()),
              (error) => Failure(Exception('Erro ao criar perfil padrão: ${error.toString()}')),
            );
          }
          
          // Usuário já possui perfil, não precisa fazer nada
          return const Success(());
        },
        (error) => Failure(Exception('Erro ao verificar perfil existente: ${error.toString()}')),
      );
    } catch (e) {
      return Failure(Exception('Erro inesperado na inicialização do usuário: $e'));
    }
  }
}