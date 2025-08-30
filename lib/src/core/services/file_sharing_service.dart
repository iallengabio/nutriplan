import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import '../../domain/models/shopping_list.dart';

/// Serviço para compartilhamento de listas de compras
class FileSharingService {
  static const String _fileExtension = '.nutriplan';
  static const String _mimeType = 'application/x-nutriplan';
  
  /// Compartilha uma lista de compras como arquivo .nutriplan
  static Future<void> shareShoppingList(ShoppingList shoppingList) async {
    try {
      // Criar o conteúdo do arquivo
      final fileContent = _createFileContent(shoppingList);
      
      // Obter diretório temporário
      final tempDir = await getTemporaryDirectory();
      final fileName = '${_sanitizeFileName(shoppingList.nome)}$_fileExtension';
      final filePath = '${tempDir.path}/$fileName';
      
      // Criar o arquivo
      final file = File(filePath);
      await file.writeAsString(fileContent);
      
      // Compartilhar o arquivo com MIME type específico
      await Share.shareXFiles(
        [XFile(filePath, mimeType: _mimeType)],
        text: 'Lista de compras: ${shoppingList.nome}',
        subject: 'Lista de compras do NutriPlan',
      );
    } catch (e) {
      throw Exception('Erro ao compartilhar lista: $e');
    }
  }
  
  /// Permite ao usuário selecionar e importar um arquivo .nutriplan
  static Future<ShoppingList?> pickAndImportShoppingList() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['nutriplan'],
        allowMultiple: false,
      );
      
      if (result != null && result.files.single.path != null) {
        return await importShoppingList(result.files.single.path!);
      }
      
      return null;
    } catch (e) {
      throw Exception('Erro ao selecionar arquivo: $e');
    }
  }
  
  /// Importa uma lista de compras de um arquivo .nutriplan
  static Future<ShoppingList> importShoppingList(String filePath) async {
    try {
      final file = File(filePath);
      final content = await file.readAsString();
      
      final data = json.decode(content) as Map<String, dynamic>;
      
      // Validar se é um arquivo NutriPlan válido
      if (data['app'] != 'NutriPlan' || data['version'] != '1.0') {
        throw Exception('Arquivo inválido ou versão não suportada');
      }
      
      // Extrair dados da lista
      final listData = data['data'] as Map<String, dynamic>;
      
      // Gerar novo ID para evitar conflitos
      listData['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Atualizar data de criação
      listData['dataCriacao'] = DateTime.now().toIso8601String();
      
      // Limpar data de última edição
      listData['dataUltimaEdicao'] = null;
      
      // Resetar status de comprado dos itens
      if (listData['itens'] is List) {
        for (var item in listData['itens']) {
          if (item is Map<String, dynamic>) {
            item['comprado'] = false;
          }
        }
      }
      
      return ShoppingList.fromJson(listData);
    } catch (e) {
      throw Exception('Erro ao importar lista: $e');
    }
  }
  
  /// Cria o conteúdo do arquivo .nutriplan
  static String _createFileContent(ShoppingList shoppingList) {
    final data = {
      'app': 'NutriPlan',
      'version': '1.0',
      'exportDate': DateTime.now().toIso8601String(),
      'data': shoppingList.toJson(),
    };
    
    return json.encode(data);
  }
  
  /// Remove caracteres inválidos do nome do arquivo
  static String _sanitizeFileName(String fileName) {
    return fileName
        .replaceAll(RegExp(r'[<>:"/\|?*]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
  }
  
  /// Verifica se um arquivo é um arquivo NutriPlan válido
  static Future<bool> isValidNutriPlanFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return false;
      
      final content = await file.readAsString();
      final data = json.decode(content) as Map<String, dynamic>;
      
      return data['app'] == 'NutriPlan' && data['version'] == '1.0';
    } catch (e) {
      return false;
    }
  }
}