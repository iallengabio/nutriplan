// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'perfil_familiar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PerfilFamiliar _$PerfilFamiliarFromJson(Map<String, dynamic> json) {
  return _PerfilFamiliar.fromJson(json);
}

/// @nodoc
mixin _$PerfilFamiliar {
  String get id => throw _privateConstructorUsedError;
  int get numeroAdultos => throw _privateConstructorUsedError;
  int get numeroCriancas => throw _privateConstructorUsedError;
  Set<RestricaoAlimentar> get restricoesAlimentares =>
      throw _privateConstructorUsedError;
  String? get observacoesAdicionais => throw _privateConstructorUsedError;
  DateTime? get dataUltimaAtualizacao => throw _privateConstructorUsedError;

  /// Serializes this PerfilFamiliar to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PerfilFamiliar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PerfilFamiliarCopyWith<PerfilFamiliar> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PerfilFamiliarCopyWith<$Res> {
  factory $PerfilFamiliarCopyWith(
    PerfilFamiliar value,
    $Res Function(PerfilFamiliar) then,
  ) = _$PerfilFamiliarCopyWithImpl<$Res, PerfilFamiliar>;
  @useResult
  $Res call({
    String id,
    int numeroAdultos,
    int numeroCriancas,
    Set<RestricaoAlimentar> restricoesAlimentares,
    String? observacoesAdicionais,
    DateTime? dataUltimaAtualizacao,
  });
}

/// @nodoc
class _$PerfilFamiliarCopyWithImpl<$Res, $Val extends PerfilFamiliar>
    implements $PerfilFamiliarCopyWith<$Res> {
  _$PerfilFamiliarCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PerfilFamiliar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? numeroAdultos = null,
    Object? numeroCriancas = null,
    Object? restricoesAlimentares = null,
    Object? observacoesAdicionais = freezed,
    Object? dataUltimaAtualizacao = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            numeroAdultos: null == numeroAdultos
                ? _value.numeroAdultos
                : numeroAdultos // ignore: cast_nullable_to_non_nullable
                      as int,
            numeroCriancas: null == numeroCriancas
                ? _value.numeroCriancas
                : numeroCriancas // ignore: cast_nullable_to_non_nullable
                      as int,
            restricoesAlimentares: null == restricoesAlimentares
                ? _value.restricoesAlimentares
                : restricoesAlimentares // ignore: cast_nullable_to_non_nullable
                      as Set<RestricaoAlimentar>,
            observacoesAdicionais: freezed == observacoesAdicionais
                ? _value.observacoesAdicionais
                : observacoesAdicionais // ignore: cast_nullable_to_non_nullable
                      as String?,
            dataUltimaAtualizacao: freezed == dataUltimaAtualizacao
                ? _value.dataUltimaAtualizacao
                : dataUltimaAtualizacao // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PerfilFamiliarImplCopyWith<$Res>
    implements $PerfilFamiliarCopyWith<$Res> {
  factory _$$PerfilFamiliarImplCopyWith(
    _$PerfilFamiliarImpl value,
    $Res Function(_$PerfilFamiliarImpl) then,
  ) = __$$PerfilFamiliarImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    int numeroAdultos,
    int numeroCriancas,
    Set<RestricaoAlimentar> restricoesAlimentares,
    String? observacoesAdicionais,
    DateTime? dataUltimaAtualizacao,
  });
}

/// @nodoc
class __$$PerfilFamiliarImplCopyWithImpl<$Res>
    extends _$PerfilFamiliarCopyWithImpl<$Res, _$PerfilFamiliarImpl>
    implements _$$PerfilFamiliarImplCopyWith<$Res> {
  __$$PerfilFamiliarImplCopyWithImpl(
    _$PerfilFamiliarImpl _value,
    $Res Function(_$PerfilFamiliarImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PerfilFamiliar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? numeroAdultos = null,
    Object? numeroCriancas = null,
    Object? restricoesAlimentares = null,
    Object? observacoesAdicionais = freezed,
    Object? dataUltimaAtualizacao = freezed,
  }) {
    return _then(
      _$PerfilFamiliarImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        numeroAdultos: null == numeroAdultos
            ? _value.numeroAdultos
            : numeroAdultos // ignore: cast_nullable_to_non_nullable
                  as int,
        numeroCriancas: null == numeroCriancas
            ? _value.numeroCriancas
            : numeroCriancas // ignore: cast_nullable_to_non_nullable
                  as int,
        restricoesAlimentares: null == restricoesAlimentares
            ? _value._restricoesAlimentares
            : restricoesAlimentares // ignore: cast_nullable_to_non_nullable
                  as Set<RestricaoAlimentar>,
        observacoesAdicionais: freezed == observacoesAdicionais
            ? _value.observacoesAdicionais
            : observacoesAdicionais // ignore: cast_nullable_to_non_nullable
                  as String?,
        dataUltimaAtualizacao: freezed == dataUltimaAtualizacao
            ? _value.dataUltimaAtualizacao
            : dataUltimaAtualizacao // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PerfilFamiliarImpl implements _PerfilFamiliar {
  const _$PerfilFamiliarImpl({
    required this.id,
    this.numeroAdultos = 2,
    this.numeroCriancas = 0,
    final Set<RestricaoAlimentar> restricoesAlimentares = const {},
    this.observacoesAdicionais,
    this.dataUltimaAtualizacao,
  }) : _restricoesAlimentares = restricoesAlimentares;

  factory _$PerfilFamiliarImpl.fromJson(Map<String, dynamic> json) =>
      _$$PerfilFamiliarImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final int numeroAdultos;
  @override
  @JsonKey()
  final int numeroCriancas;
  final Set<RestricaoAlimentar> _restricoesAlimentares;
  @override
  @JsonKey()
  Set<RestricaoAlimentar> get restricoesAlimentares {
    if (_restricoesAlimentares is EqualUnmodifiableSetView)
      return _restricoesAlimentares;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_restricoesAlimentares);
  }

  @override
  final String? observacoesAdicionais;
  @override
  final DateTime? dataUltimaAtualizacao;

  @override
  String toString() {
    return 'PerfilFamiliar(id: $id, numeroAdultos: $numeroAdultos, numeroCriancas: $numeroCriancas, restricoesAlimentares: $restricoesAlimentares, observacoesAdicionais: $observacoesAdicionais, dataUltimaAtualizacao: $dataUltimaAtualizacao)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PerfilFamiliarImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.numeroAdultos, numeroAdultos) ||
                other.numeroAdultos == numeroAdultos) &&
            (identical(other.numeroCriancas, numeroCriancas) ||
                other.numeroCriancas == numeroCriancas) &&
            const DeepCollectionEquality().equals(
              other._restricoesAlimentares,
              _restricoesAlimentares,
            ) &&
            (identical(other.observacoesAdicionais, observacoesAdicionais) ||
                other.observacoesAdicionais == observacoesAdicionais) &&
            (identical(other.dataUltimaAtualizacao, dataUltimaAtualizacao) ||
                other.dataUltimaAtualizacao == dataUltimaAtualizacao));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    numeroAdultos,
    numeroCriancas,
    const DeepCollectionEquality().hash(_restricoesAlimentares),
    observacoesAdicionais,
    dataUltimaAtualizacao,
  );

  /// Create a copy of PerfilFamiliar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PerfilFamiliarImplCopyWith<_$PerfilFamiliarImpl> get copyWith =>
      __$$PerfilFamiliarImplCopyWithImpl<_$PerfilFamiliarImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PerfilFamiliarImplToJson(this);
  }
}

abstract class _PerfilFamiliar implements PerfilFamiliar {
  const factory _PerfilFamiliar({
    required final String id,
    final int numeroAdultos,
    final int numeroCriancas,
    final Set<RestricaoAlimentar> restricoesAlimentares,
    final String? observacoesAdicionais,
    final DateTime? dataUltimaAtualizacao,
  }) = _$PerfilFamiliarImpl;

  factory _PerfilFamiliar.fromJson(Map<String, dynamic> json) =
      _$PerfilFamiliarImpl.fromJson;

  @override
  String get id;
  @override
  int get numeroAdultos;
  @override
  int get numeroCriancas;
  @override
  Set<RestricaoAlimentar> get restricoesAlimentares;
  @override
  String? get observacoesAdicionais;
  @override
  DateTime? get dataUltimaAtualizacao;

  /// Create a copy of PerfilFamiliar
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PerfilFamiliarImplCopyWith<_$PerfilFamiliarImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
