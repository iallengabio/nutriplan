import 'dart:convert';
import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:result_dart/result_dart.dart';

import '../../core/constants/api_keys.dart';
import '../../core/constants/prompts.dart';
import '../../domain/models/menu.dart';
import '../../domain/models/perfil_familiar.dart';
import '../../domain/models/refeicao.dart';
import '../../domain/models/shopping_list.dart';
import '../../domain/services/ai_api_service.dart';

/// Implementação do AiApiService usando Google Gemini
class GeminiAiService implements AiApiService {
  late final GenerativeModel _model;
  
  GeminiAiService() {
    if (!ApiKeys.isGeminiConfigured) {
      throw AiValidationError(
        'Chave da API do Gemini não configurada. '
        'Defina a variável GEMINI_API_KEY ou configure em ApiKeys.',
      );
    }
    
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: ApiKeys.geminiApiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
      ),
    );
  }
  
  @override
  Future<Result<Menu>> gerarCardapio({
    required PerfilFamiliar perfil,
    required Set<TipoRefeicao> tiposRefeicao,
    String? nome,
    String? observacoesAdicionais,
    int? numberOfPeople,
  }) async {
    try {
      final prompt = MenuPrompts.gerarCardapioPrompt(
        numeroPessoas: numberOfPeople ?? perfil.totalPessoas,
        restricoesAlimentares: perfil.restricoesAlimentares.map((r) => r.displayName).toList(),
        tiposRefeicao: tiposRefeicao.map((t) => t.displayName).toList(),
        observacoesAdicionais: observacoesAdicionais,
        observacoesPerfil: perfil.observacoesAdicionais,
      );
      
      final response = await _model.generateContent([
        Content.text(prompt),
      ]);
      
      if (response.text == null || response.text!.isEmpty) {
        return Failure(AiApiServiceError('Resposta vazia da API do Gemini'));
      }
      
      final menu = _parseMenuFromJson(
        response.text!, 
        nome, 
        numberOfPeople: numberOfPeople ?? perfil.totalPessoas,
      );
      return Success(menu);
      
    } on SocketException catch (e) {
      return Failure(AiNetworkError('Erro de conexão: ${e.message}'));
    } on GenerativeAIException catch (e) {
      if (e.message.contains('quota') || e.message.contains('limit')) {
        return Failure(AiRateLimitError('Limite de uso da API atingido: ${e.message}'));
      }
      return Failure(AiApiServiceError('Erro da API Gemini: ${e.message}'));
    } catch (e) {
      return Failure(AiApiServiceError('Erro inesperado: $e'));
    }
  }
  
  @override
  Future<Result<Refeicao>> gerarRefeicaoAlternativa({
    required PerfilFamiliar perfil,
    required TipoRefeicao tipo,
    String? observacoesAdicionais,
  }) async {
    try {
      final prompt = MenuPrompts.gerarRefeicaoAlternativaPrompt(
        tipoRefeicao: tipo.displayName,
        numeroPessoas: perfil.totalPessoas,
        restricoesAlimentares: perfil.restricoesAlimentares.map((r) => r.displayName).toList(),
        observacoesAdicionais: observacoesAdicionais,
        observacoesPerfil: perfil.observacoesAdicionais,
      );
      
      final response = await _model.generateContent([
        Content.text(prompt),
      ]);
      
      if (response.text == null || response.text!.isEmpty) {
        return Failure(AiApiServiceError('Resposta vazia da API do Gemini'));
      }
      
      final refeicao = _parseRefeicaoFromJson(response.text!);
      return Success(refeicao);
      
    } on SocketException catch (e) {
      return Failure(AiNetworkError('Erro de conexão: ${e.message}'));
    } on GenerativeAIException catch (e) {
      if (e.message.contains('quota') || e.message.contains('limit')) {
        return Failure(AiRateLimitError('Limite de uso da API atingido: ${e.message}'));
      }
      return Failure(AiApiServiceError('Erro da API Gemini: ${e.message}'));
    } catch (e) {
      return Failure(AiApiServiceError('Erro inesperado: $e'));
    }
  }
  
  @override
  Future<Result<Refeicao>> gerarRefeicaoAlternativaComContexto({
    required PerfilFamiliar perfil,
    required TipoRefeicao tipo,
    required Menu menu,
    required DiaSemana dia,
    required int indiceRefeicao,
    String? observacoesAdicionais,
  }) async {
    try {
      // Coleta informações contextuais do cardápio
      final refeicoesDoDia = menu.refeicoesDoDia(dia);
      final refeicaoOriginal = indiceRefeicao < refeicoesDoDia.length 
          ? refeicoesDoDia[indiceRefeicao].nome 
          : null;
      
      final outrasRefeicoesDoDia = refeicoesDoDia
          .asMap()
          .entries
          .where((entry) => entry.key != indiceRefeicao)
          .map((entry) => '${entry.value.tipo.displayName}: ${entry.value.nome}')
          .toList();
      
      // Coleta refeições similares da semana para evitar repetição
      final refeicoesSemanaAnterior = <String>[];
      for (final entry in menu.refeicoesPorDia.entries) {
        if (entry.key != dia) {
          for (final refeicao in entry.value) {
            if (refeicao.tipo == tipo) {
              refeicoesSemanaAnterior.add('${entry.key.displayName}: ${refeicao.nome}');
            }
          }
        }
      }
      
      final prompt = MenuPrompts.gerarRefeicaoAlternativaComContextoPrompt(
        tipoRefeicao: tipo.displayName,
        numeroPessoas: perfil.totalPessoas,
        restricoesAlimentares: perfil.restricoesAlimentares.map((r) => r.displayName).toList(),
        nomeCardapio: menu.nome,
        diaSemanaSelecionado: dia.displayName,
        outrasRefeicoesDoDia: outrasRefeicoesDoDia,
        refeicoesSemanaAnterior: refeicoesSemanaAnterior,
        refeicaoOriginal: refeicaoOriginal,
        observacoesAdicionais: observacoesAdicionais,
        observacoesPerfil: perfil.observacoesAdicionais,
      );
      
      final response = await _model.generateContent([
        Content.text(prompt),
      ]);
      
      if (response.text == null || response.text!.isEmpty) {
        return Failure(AiApiServiceError('Resposta vazia da API do Gemini'));
      }
      
      final refeicao = _parseRefeicaoFromJson(response.text!);
      return Success(refeicao);
      
    } on SocketException catch (e) {
      return Failure(AiNetworkError('Erro de conexão: ${e.message}'));
    } on GenerativeAIException catch (e) {
      if (e.message.contains('quota') || e.message.contains('limit')) {
        return Failure(AiRateLimitError('Limite de uso da API atingido: ${e.message}'));
      }
      return Failure(AiApiServiceError('Erro da API Gemini: ${e.message}'));
    } catch (e) {
      return Failure(AiApiServiceError('Erro inesperado: $e'));
    }
  }
  
  @override
  Future<Result<ShoppingList>> gerarListaCompras({
    required Menu menu,
    required int numeroSemanas,
    String? nome,
    String? observacoes,
    int? numberOfPeople,
  }) async {
    try {
      // Converte o menu para o formato esperado pelo prompt
      final refeicoesPorDia = menu.refeicoesPorDia.entries.map((entry) {
        return {
          'diaSemana': entry.key.displayName,
          'refeicoes': entry.value.map((refeicao) => {
            'tipo': refeicao.tipo.displayName,
            'nome': refeicao.nome,
          }).toList(),
        };
      }).toList();
      
      final prompt = ShoppingListPrompts.gerarListaComprasPrompt(
        menuNome: menu.nome,
        refeicoesPorDia: refeicoesPorDia,
        numeroSemanas: numeroSemanas,
        observacoes: observacoes,
        numberOfPeople: numberOfPeople ?? menu.numberOfPeople,
      );
      
      final response = await _model.generateContent([
        Content.text(prompt),
      ]);
      
      if (response.text == null || response.text!.isEmpty) {
        return Failure(AiApiServiceError('Resposta vazia da API do Gemini'));
      }
      
      final shoppingList = _parseShoppingListFromJson(
        response.text!,
        menu,
        numeroSemanas,
        nome,
      );
      return Success(shoppingList);
      
    } on SocketException catch (e) {
      return Failure(AiNetworkError('Erro de conexão: ${e.message}'));
    } on GenerativeAIException catch (e) {
      if (e.message.contains('quota') || e.message.contains('limit')) {
        return Failure(AiRateLimitError('Limite de uso da API atingido: ${e.message}'));
      }
      return Failure(AiApiServiceError('Erro da API Gemini: ${e.message}'));
    } catch (e) {
      return Failure(AiApiServiceError('Erro inesperado: $e'));
    }
  }
  
  /// Converte a resposta JSON do Gemini em um objeto Menu
  Menu _parseMenuFromJson(String jsonResponse, String? nomePersonalizado, {int? numberOfPeople}) {
    try {
      // Remove possíveis marcadores de código do JSON
      String cleanJson = jsonResponse
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      
      final Map<String, dynamic> data = jsonDecode(cleanJson);
      
      final nome = nomePersonalizado ?? data['nome'] ?? 'Cardápio Gerado por IA';
      final observacoes = data['observacoes'] ?? '';
      
      final List<dynamic> diasData = data['diasSemana'] ?? [];
      final Map<DiaSemana, List<Refeicao>> refeicoesPorDia = {};
      
      for (final diaData in diasData) {
        final diaSemanaStr = diaData['diaSemana'] as String;
        final diaSemana = _parseDiaSemana(diaSemanaStr);
        
        final List<dynamic> refeicoesData = diaData['refeicoes'] ?? [];
        final refeicoes = refeicoesData.map((refeicaoData) {
          return Refeicao(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            tipo: _parseTipoRefeicao(refeicaoData['tipo']),
            nome: refeicaoData['nome'] ?? '',
            descricao: refeicaoData['descricao'] ?? '',
            ingredientes: _parseIngredientes(refeicaoData['descricao'] ?? ''),
            quantidades: {},
            observacoes: refeicaoData['observacoes'],
          );
        }).toList();
        
        refeicoesPorDia[diaSemana] = refeicoes;
      }
      
      return Menu(
        id: '', // Será definido pelo repository
        nome: nome,
        dataCriacao: DateTime.now(),
        observacoes: observacoes,
        refeicoesPorDia: refeicoesPorDia,
        numberOfPeople: numberOfPeople ?? 4,
      );
      
    } catch (e) {
      throw AiApiServiceError('Erro ao processar resposta da IA: $e');
    }
  }
  
  /// Converte a resposta JSON do Gemini em um objeto Refeicao
  Refeicao _parseRefeicaoFromJson(String jsonResponse) {
    try {
      // Remove possíveis marcadores de código do JSON
      String cleanJson = jsonResponse
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      
      final Map<String, dynamic> data = jsonDecode(cleanJson);
      
      return Refeicao(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        tipo: _parseTipoRefeicao(data['tipo']),
        nome: data['nome'] ?? '',
        descricao: data['descricao'] ?? '',
        ingredientes: _parseIngredientes(data['descricao'] ?? ''),
        quantidades: {},
        observacoes: data['observacoes'],
      );
      
    } catch (e) {
      throw AiApiServiceError('Erro ao processar resposta da IA: $e');
    }
  }
  
  /// Converte string para DiaSemana
  DiaSemana _parseDiaSemana(String dia) {
    final diaLower = dia.toLowerCase();
    if (diaLower.contains('segunda')) return DiaSemana.segunda;
    if (diaLower.contains('terça') || diaLower.contains('terca')) return DiaSemana.terca;
    if (diaLower.contains('quarta')) return DiaSemana.quarta;
    if (diaLower.contains('quinta')) return DiaSemana.quinta;
    if (diaLower.contains('sexta')) return DiaSemana.sexta;
    if (diaLower.contains('sábado') || diaLower.contains('sabado')) return DiaSemana.sabado;
    if (diaLower.contains('domingo')) return DiaSemana.domingo;
    
    // Fallback para segunda-feira
    return DiaSemana.segunda;
  }
  
  /// Converte string para TipoRefeicao
  TipoRefeicao _parseTipoRefeicao(String tipo) {
    final tipoLower = tipo.toLowerCase();
    if (tipoLower.contains('café') || tipoLower.contains('cafe')) return TipoRefeicao.cafeManha;
    if (tipoLower.contains('almoço') || tipoLower.contains('almoco')) return TipoRefeicao.almoco;
    if (tipoLower.contains('jantar')) return TipoRefeicao.jantar;
    if (tipoLower.contains('lanche')) return TipoRefeicao.lanche;
    
    // Fallback para almoço
    return TipoRefeicao.almoco;
  }
  
  /// Extrai ingredientes básicos da descrição
  /// Esta é uma implementação simples que pode ser melhorada no futuro
  List<String> _parseIngredientes(String descricao) {
    // Por enquanto, retorna uma lista vazia
    // A IA já fornece a descrição completa, então os ingredientes
    // específicos podem ser extraídos posteriormente se necessário
    return [];
  }
  
  /// Converte a resposta JSON do Gemini em um objeto ShoppingList
  ShoppingList _parseShoppingListFromJson(
    String jsonResponse,
    Menu menu,
    int numeroSemanas,
    String? nomePersonalizado,
  ) {
    try {
      // Remove possíveis marcadores de código do JSON
      String cleanJson = jsonResponse
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      
      final Map<String, dynamic> data = jsonDecode(cleanJson);
      
      // Converte os itens da resposta da IA
      final List<ShoppingItem> itens = [];
      final itensData = data['itens'] as List? ?? [];
      
      for (int i = 0; i < itensData.length; i++) {
        final itemData = itensData[i] as Map<String, dynamic>;
        itens.add(ShoppingItem(
          id: '${DateTime.now().millisecondsSinceEpoch}_$i',
          nome: itemData['nome'] ?? '',
          quantidade: itemData['quantidade'] ?? '',
          categoria: itemData['categoria'],
          comprado: false,
          observacoes: itemData['observacoes'],
        ));
      }
      
      return ShoppingList(
        id: '', // Será definido pelo repository
        nome: nomePersonalizado ?? data['nome'] ?? 'Lista de Compras - ${menu.nome}',
        dataCriacao: DateTime.now(),
        menuId: menu.id,
        menuNome: menu.nome,
        numeroSemanas: numeroSemanas,
        itens: itens,
        observacoes: data['observacoes'],
        dataUltimaEdicao: DateTime.now(),
      );
      
    } catch (e) {
      throw AiApiServiceError('Erro ao processar resposta da IA: $e');
    }
  }
}