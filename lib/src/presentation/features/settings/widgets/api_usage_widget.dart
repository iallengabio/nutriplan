import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/services/rate_limit_service.dart';
import '../../../../core/constants/api_keys.dart';

/// Widget que exibe informações sobre o uso da API de IA
class ApiUsageWidget extends ConsumerStatefulWidget {
  const ApiUsageWidget({super.key});

  @override
  ConsumerState<ApiUsageWidget> createState() => _ApiUsageWidgetState();
}

class _ApiUsageWidgetState extends ConsumerState<ApiUsageWidget> {
  int _todaysCalls = 0;
  int _remainingCalls = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsageData();
  }

  Future<void> _loadUsageData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final todaysCalls = await RateLimitService.getTodaysCalls(userId);
      final remainingCalls = await RateLimitService.getRemainingCalls(userId);
      
      if (mounted) {
        setState(() {
          _todaysCalls = todaysCalls;
          _remainingCalls = remainingCalls;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    if (_isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Text('Carregando informações de uso...'),
            ],
          ),
        ),
      );
    }

    final progress = _todaysCalls / RateLimitService.maxCallsPerDay;
    final progressColor = _getProgressColor(progress, colorScheme);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.api,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Uso da IA Hoje',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Status da API
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: ApiKeys.isGeminiConfigured 
                    ? colorScheme.primaryContainer
                    : colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    ApiKeys.isGeminiConfigured 
                        ? Icons.check_circle_outline
                        : Icons.warning_amber_rounded,
                    size: 16,
                    color: ApiKeys.isGeminiConfigured 
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    ApiKeys.isGeminiConfigured 
                        ? 'API Google Gemini Ativa'
                        : 'Usando API Mock',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: ApiKeys.isGeminiConfigured 
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onErrorContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Barra de progresso
            LinearProgressIndicator(
              value: progress,
              backgroundColor: colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
            const SizedBox(height: 8),
            
            // Informações numéricas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$_todaysCalls de ${RateLimitService.maxCallsPerDay} gerações',
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  '$_remainingCalls restantes',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _remainingCalls > 0 
                        ? colorScheme.primary 
                        : colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            
            if (_remainingCalls == 0) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Limite diário atingido',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 12),
            Text(
              'O limite é resetado diariamente às 00:00',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            
            // Botão para atualizar
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _loadUsageData,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Atualizar'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getProgressColor(double progress, ColorScheme colorScheme) {
    if (progress >= 1.0) {
      return colorScheme.error;
    } else if (progress >= 0.8) {
      return Colors.orange;
    } else {
      return colorScheme.primary;
    }
  }
}