import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_list.freezed.dart';
part 'shopping_list.g.dart';

// Funções auxiliares para serialização
List<Map<String, dynamic>> _itensToJson(List<ShoppingItem> itens) {
  return itens.map((item) => item.toJson()).toList();
}

List<ShoppingItem> _itensFromJson(List<dynamic> json) {
  return json.map((item) => ShoppingItem.fromJson(item as Map<String, dynamic>)).toList();
}

@freezed
class ShoppingList with _$ShoppingList {
  const factory ShoppingList({
    required String id,
    required String nome,
    required DateTime dataCriacao,
    required String menuId,
    required String menuNome,
    required int numeroSemanas,
    @JsonKey(name: 'itens', toJson: _itensToJson, fromJson: _itensFromJson) required List<ShoppingItem> itens,
    String? observacoes,
    DateTime? dataUltimaEdicao,
  }) = _ShoppingList;

  factory ShoppingList.fromJson(Map<String, dynamic> json) => _$ShoppingListFromJson(json);
}

@freezed
class ShoppingItem with _$ShoppingItem {
  const factory ShoppingItem({
    required String id,
    required String nome,
    required String quantidade,
    String? categoria,
    @Default(false) bool comprado,
    String? observacoes,
  }) = _ShoppingItem;

  factory ShoppingItem.fromJson(Map<String, dynamic> json) => _$ShoppingItemFromJson(json);
}