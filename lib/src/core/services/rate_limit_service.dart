import 'package:shared_preferences/shared_preferences.dart';

/// Serviço para controle de rate limiting das chamadas de IA
class RateLimitService {
  static const String _keyPrefix = 'ai_calls_';
  static const int maxCallsPerDay = 5000;
  
  /// Verifica se o usuário pode fazer uma nova chamada de IA
  static Future<bool> canMakeCall(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final today = _getTodayKey();
    final key = '$_keyPrefix${userId}_$today';
    
    final currentCalls = prefs.getInt(key) ?? 0;
    return currentCalls < maxCallsPerDay;
  }
  
  /// Registra uma nova chamada de IA para o usuário
  static Future<void> recordCall(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final today = _getTodayKey();
    final key = '$_keyPrefix${userId}_$today';
    
    final currentCalls = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, currentCalls + 1);
  }
  
  /// Retorna o número de chamadas restantes para o usuário hoje
  static Future<int> getRemainingCalls(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final today = _getTodayKey();
    final key = '$_keyPrefix${userId}_$today';
    
    final currentCalls = prefs.getInt(key) ?? 0;
    return (maxCallsPerDay - currentCalls).clamp(0, maxCallsPerDay);
  }
  
  /// Obtém o número de chamadas feitas hoje
  static Future<int> getTodaysCalls(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final today = _getTodayKey();
    final key = '$_keyPrefix${userId}_$today';
    
    return prefs.getInt(key) ?? 0;
  }
  
  /// Limpa dados antigos de rate limiting (chamadas de mais de 7 dias)
  static Future<void> cleanupOldData() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final cutoffDate = DateTime.now().subtract(const Duration(days: 7));
    
    for (final key in keys) {
      if (key.startsWith(_keyPrefix)) {
        final parts = key.split('_');
        if (parts.length >= 3) {
          final dateStr = parts.last;
          try {
            final date = DateTime.parse(dateStr);
            if (date.isBefore(cutoffDate)) {
              await prefs.remove(key);
            }
          } catch (e) {
            // Se não conseguir parsear a data, remove a chave
            await prefs.remove(key);
          }
        }
      }
    }
  }
  
  /// Gera a chave do dia atual no formato YYYY-MM-DD
  static String _getTodayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
  
  /// Reseta o contador de chamadas para um usuário (apenas para testes)
  static Future<void> resetCallsForUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final today = _getTodayKey();
    final key = '$_keyPrefix${userId}_$today';
    
    await prefs.remove(key);
  }
}

/// Exceção lançada quando o limite de chamadas é atingido
class RateLimitExceededException implements Exception {
  final String message;
  final int remainingCalls;
  final int maxCalls;
  
  const RateLimitExceededException({
    required this.message,
    required this.remainingCalls,
    required this.maxCalls,
  });
  
  @override
  String toString() => 'RateLimitExceededException: $message';
}