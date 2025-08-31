import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/common/widgets/auth_navigator.dart';
import 'presentation/common/widgets/intent_handler.dart';

/// Widget principal que orquestra a navegação de autenticação e o processamento de intents
/// Segue o princípio da responsabilidade única (SRP) delegando responsabilidades específicas
/// para AuthNavigator e IntentHandler
class AppWrapper extends ConsumerWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Orquestrar os componentes: IntentHandler envolve AuthNavigator
    // IntentHandler gerencia intents de arquivos
    // AuthNavigator gerencia navegação baseada em autenticação
    return const IntentHandler(
      child: AuthNavigator(),
    );
  }
}