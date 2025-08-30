import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../src/core/services/file_sharing_service.dart';
import '../../domain/models/shopping_list.dart';

/// Serviço para lidar com intents do Android
class IntentService {
  static const MethodChannel _channel = MethodChannel('com.nutriplan.app/intent');
  
  /// Stream controller para notificar quando um arquivo é recebido
  static final StreamController<ShoppingList> _fileReceivedController = 
      StreamController<ShoppingList>.broadcast();
  
  /// Stream que emite quando um arquivo .nutriplan é recebido
  static Stream<ShoppingList> get fileReceived => _fileReceivedController.stream;
  
  /// Inicializa o serviço de intents
  static Future<void> initialize() async {
    _channel.setMethodCallHandler(_handleMethodCall);
    
    // Verificar se o app foi aberto com um intent
    await _checkInitialIntent();
  }
  
  /// Manipula chamadas de método do canal nativo
  static Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onFileReceived':
        final String? filePath = call.arguments as String?;
        if (filePath != null) {
          await _processReceivedFile(filePath);
        }
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'Method ${call.method} not implemented',
        );
    }
  }
  
  /// Verifica se o app foi aberto com um intent inicial
  static Future<void> _checkInitialIntent() async {
    try {
      final String? filePath = await _channel.invokeMethod('getInitialIntent');
      if (filePath != null && filePath.isNotEmpty) {
        await _processReceivedFile(filePath);
      }
    } catch (e) {
      // Ignorar erros de intent inicial
    }
  }
  
  /// Processa um arquivo recebido via intent
  static Future<void> _processReceivedFile(String filePath) async {
    try {
      // Verificar se é um arquivo .nutriplan válido
      if (await FileSharingService.isValidNutriPlanFile(filePath)) {
        final shoppingList = await FileSharingService.importShoppingList(filePath);
        _fileReceivedController.add(shoppingList);
      }
    } catch (e) {
      // Erro ao processar arquivo - pode ser ignorado ou logado
    }
  }
  
  /// Limpa recursos do serviço
  static void dispose() {
    _fileReceivedController.close();
  }
}

/// Provider para o serviço de intents
final intentServiceProvider = Provider<IntentService>((ref) {
  return IntentService();
});