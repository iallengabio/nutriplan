import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configurações de chaves de API
/// 
/// IMPORTANTE: Este arquivo contém apenas as configurações.
/// As chaves reais devem ser definidas no arquivo .env
/// que não deve ser commitado.
class ApiKeys {
  /// Chave da API do Google Gemini
  /// 
  /// Para configurar:
  /// 1. Obtenha sua chave em: https://makersuite.google.com/app/apikey
  /// 2. Adicione GEMINI_API_KEY=sua_chave_aqui no arquivo .env
  static String get geminiApiKey => 
      dotenv.env['GEMINI_API_KEY'] ?? 'YOUR_GEMINI_API_KEY_HERE';
  
  /// Verifica se a chave do Gemini está configurada
  static bool get isGeminiConfigured => 
      geminiApiKey != 'YOUR_GEMINI_API_KEY_HERE' && geminiApiKey.isNotEmpty;
}