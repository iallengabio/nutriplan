// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'perfil_familiar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PerfilFamiliarImpl _$$PerfilFamiliarImplFromJson(Map<String, dynamic> json) =>
    _$PerfilFamiliarImpl(
      id: json['id'] as String,
      numeroAdultos: (json['numeroAdultos'] as num?)?.toInt() ?? 2,
      numeroCriancas: (json['numeroCriancas'] as num?)?.toInt() ?? 0,
      restricoesAlimentares:
          (json['restricoesAlimentares'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$RestricaoAlimentarEnumMap, e))
              .toSet() ??
          const {},
      observacoesAdicionais: json['observacoesAdicionais'] as String?,
      dataUltimaAtualizacao: json['dataUltimaAtualizacao'] == null
          ? null
          : DateTime.parse(json['dataUltimaAtualizacao'] as String),
    );

Map<String, dynamic> _$$PerfilFamiliarImplToJson(
  _$PerfilFamiliarImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'numeroAdultos': instance.numeroAdultos,
  'numeroCriancas': instance.numeroCriancas,
  'restricoesAlimentares': instance.restricoesAlimentares
      .map((e) => _$RestricaoAlimentarEnumMap[e]!)
      .toList(),
  'observacoesAdicionais': instance.observacoesAdicionais,
  'dataUltimaAtualizacao': instance.dataUltimaAtualizacao?.toIso8601String(),
};

const _$RestricaoAlimentarEnumMap = {
  RestricaoAlimentar.gluten: 'gluten',
  RestricaoAlimentar.lactose: 'lactose',
  RestricaoAlimentar.acucar: 'acucar',
  RestricaoAlimentar.carneVermelha: 'carne_vermelha',
  RestricaoAlimentar.frango: 'frango',
  RestricaoAlimentar.peixe: 'peixe',
  RestricaoAlimentar.ovos: 'ovos',
  RestricaoAlimentar.ferro: 'ferro',
  RestricaoAlimentar.salSodio: 'sal_sodio',
};
