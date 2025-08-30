// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refeicao.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RefeicaoImpl _$$RefeicaoImplFromJson(Map<String, dynamic> json) =>
    _$RefeicaoImpl(
      id: json['id'] as String,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      ingredientes: (json['ingredientes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      quantidades: Map<String, String>.from(json['quantidades'] as Map),
      observacoes: json['observacoes'] as String?,
      sugestoesNutricionais:
          (json['sugestoesNutricionais'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tipo:
          $enumDecodeNullable(_$TipoRefeicaoEnumMap, json['tipo']) ??
          TipoRefeicao.almoco,
      tempoPreparoMinutos: (json['tempoPreparoMinutos'] as num?)?.toInt() ?? 30,
      porcoes: (json['porcoes'] as num?)?.toInt() ?? 4,
    );

Map<String, dynamic> _$$RefeicaoImplToJson(_$RefeicaoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'descricao': instance.descricao,
      'ingredientes': instance.ingredientes,
      'quantidades': instance.quantidades,
      'observacoes': instance.observacoes,
      'sugestoesNutricionais': instance.sugestoesNutricionais,
      'tipo': _$TipoRefeicaoEnumMap[instance.tipo]!,
      'tempoPreparoMinutos': instance.tempoPreparoMinutos,
      'porcoes': instance.porcoes,
    };

const _$TipoRefeicaoEnumMap = {
  TipoRefeicao.cafeManha: 'cafe_manha',
  TipoRefeicao.almoco: 'almoco',
  TipoRefeicao.lanche: 'lanche',
  TipoRefeicao.jantar: 'jantar',
  TipoRefeicao.ceia: 'ceia',
};
