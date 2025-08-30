// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MenuImpl _$$MenuImplFromJson(Map<String, dynamic> json) => _$MenuImpl(
  id: json['id'] as String,
  nome: json['nome'] as String,
  dataCriacao: DateTime.parse(json['dataCriacao'] as String),
  refeicoesPorDia: _refeicoesPorDiaFromJson(
    json['refeicoesPorDia'] as Map<String, dynamic>,
  ),
  observacoes: json['observacoes'] as String?,
  isFavorito: json['isFavorito'] as bool? ?? false,
  dataUltimaEdicao: json['dataUltimaEdicao'] == null
      ? null
      : DateTime.parse(json['dataUltimaEdicao'] as String),
  numberOfPeople: (json['numberOfPeople'] as num?)?.toInt() ?? 4,
);

Map<String, dynamic> _$$MenuImplToJson(_$MenuImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nome': instance.nome,
      'dataCriacao': instance.dataCriacao.toIso8601String(),
      'refeicoesPorDia': _refeicoesPorDiaToJson(instance.refeicoesPorDia),
      'observacoes': instance.observacoes,
      'isFavorito': instance.isFavorito,
      'dataUltimaEdicao': instance.dataUltimaEdicao?.toIso8601String(),
      'numberOfPeople': instance.numberOfPeople,
    };
