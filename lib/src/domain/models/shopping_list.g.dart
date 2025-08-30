// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShoppingListImpl _$$ShoppingListImplFromJson(Map<String, dynamic> json) =>
    _$ShoppingListImpl(
      id: json['id'] as String,
      nome: json['nome'] as String,
      dataCriacao: DateTime.parse(json['dataCriacao'] as String),
      menuId: json['menuId'] as String,
      menuNome: json['menuNome'] as String,
      numeroSemanas: (json['numeroSemanas'] as num).toInt(),
      itens: _itensFromJson(json['itens'] as List),
      observacoes: json['observacoes'] as String?,
      dataUltimaEdicao: json['dataUltimaEdicao'] == null
          ? null
          : DateTime.parse(json['dataUltimaEdicao'] as String),
    );

Map<String, dynamic> _$$ShoppingListImplToJson(_$ShoppingListImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'dataCriacao': instance.dataCriacao.toIso8601String(),
      'menuId': instance.menuId,
      'menuNome': instance.menuNome,
      'numeroSemanas': instance.numeroSemanas,
      'itens': _itensToJson(instance.itens),
      'observacoes': instance.observacoes,
      'dataUltimaEdicao': instance.dataUltimaEdicao?.toIso8601String(),
    };

_$ShoppingItemImpl _$$ShoppingItemImplFromJson(Map<String, dynamic> json) =>
    _$ShoppingItemImpl(
      id: json['id'] as String,
      nome: json['nome'] as String,
      quantidade: json['quantidade'] as String,
      categoria: json['categoria'] as String?,
      comprado: json['comprado'] as bool? ?? false,
      observacoes: json['observacoes'] as String?,
    );

Map<String, dynamic> _$$ShoppingItemImplToJson(_$ShoppingItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'quantidade': instance.quantidade,
      'categoria': instance.categoria,
      'comprado': instance.comprado,
      'observacoes': instance.observacoes,
    };
