// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menu.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Menu _$MenuFromJson(Map<String, dynamic> json) {
  return _Menu.fromJson(json);
}

/// @nodoc
mixin _$Menu {
  String get id => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;
  DateTime get dataCriacao => throw _privateConstructorUsedError;
  @JsonKey(toJson: _refeicoesPorDiaToJson, fromJson: _refeicoesPorDiaFromJson)
  Map<DiaSemana, List<Refeicao>> get refeicoesPorDia =>
      throw _privateConstructorUsedError;
  String? get observacoes => throw _privateConstructorUsedError;
  bool get isFavorito => throw _privateConstructorUsedError;
  DateTime? get dataUltimaEdicao => throw _privateConstructorUsedError;

  /// Serializes this Menu to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Menu
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MenuCopyWith<Menu> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MenuCopyWith<$Res> {
  factory $MenuCopyWith(Menu value, $Res Function(Menu) then) =
      _$MenuCopyWithImpl<$Res, Menu>;
  @useResult
  $Res call({
    String id,
    String nome,
    DateTime dataCriacao,
    @JsonKey(toJson: _refeicoesPorDiaToJson, fromJson: _refeicoesPorDiaFromJson)
    Map<DiaSemana, List<Refeicao>> refeicoesPorDia,
    String? observacoes,
    bool isFavorito,
    DateTime? dataUltimaEdicao,
  });
}

/// @nodoc
class _$MenuCopyWithImpl<$Res, $Val extends Menu>
    implements $MenuCopyWith<$Res> {
  _$MenuCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Menu
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? dataCriacao = null,
    Object? refeicoesPorDia = null,
    Object? observacoes = freezed,
    Object? isFavorito = null,
    Object? dataUltimaEdicao = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            nome: null == nome
                ? _value.nome
                : nome // ignore: cast_nullable_to_non_nullable
                      as String,
            dataCriacao: null == dataCriacao
                ? _value.dataCriacao
                : dataCriacao // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            refeicoesPorDia: null == refeicoesPorDia
                ? _value.refeicoesPorDia
                : refeicoesPorDia // ignore: cast_nullable_to_non_nullable
                      as Map<DiaSemana, List<Refeicao>>,
            observacoes: freezed == observacoes
                ? _value.observacoes
                : observacoes // ignore: cast_nullable_to_non_nullable
                      as String?,
            isFavorito: null == isFavorito
                ? _value.isFavorito
                : isFavorito // ignore: cast_nullable_to_non_nullable
                      as bool,
            dataUltimaEdicao: freezed == dataUltimaEdicao
                ? _value.dataUltimaEdicao
                : dataUltimaEdicao // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MenuImplCopyWith<$Res> implements $MenuCopyWith<$Res> {
  factory _$$MenuImplCopyWith(
    _$MenuImpl value,
    $Res Function(_$MenuImpl) then,
  ) = __$$MenuImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String nome,
    DateTime dataCriacao,
    @JsonKey(toJson: _refeicoesPorDiaToJson, fromJson: _refeicoesPorDiaFromJson)
    Map<DiaSemana, List<Refeicao>> refeicoesPorDia,
    String? observacoes,
    bool isFavorito,
    DateTime? dataUltimaEdicao,
  });
}

/// @nodoc
class __$$MenuImplCopyWithImpl<$Res>
    extends _$MenuCopyWithImpl<$Res, _$MenuImpl>
    implements _$$MenuImplCopyWith<$Res> {
  __$$MenuImplCopyWithImpl(_$MenuImpl _value, $Res Function(_$MenuImpl) _then)
    : super(_value, _then);

  /// Create a copy of Menu
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? dataCriacao = null,
    Object? refeicoesPorDia = null,
    Object? observacoes = freezed,
    Object? isFavorito = null,
    Object? dataUltimaEdicao = freezed,
  }) {
    return _then(
      _$MenuImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        nome: null == nome
            ? _value.nome
            : nome // ignore: cast_nullable_to_non_nullable
                  as String,
        dataCriacao: null == dataCriacao
            ? _value.dataCriacao
            : dataCriacao // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        refeicoesPorDia: null == refeicoesPorDia
            ? _value._refeicoesPorDia
            : refeicoesPorDia // ignore: cast_nullable_to_non_nullable
                  as Map<DiaSemana, List<Refeicao>>,
        observacoes: freezed == observacoes
            ? _value.observacoes
            : observacoes // ignore: cast_nullable_to_non_nullable
                  as String?,
        isFavorito: null == isFavorito
            ? _value.isFavorito
            : isFavorito // ignore: cast_nullable_to_non_nullable
                  as bool,
        dataUltimaEdicao: freezed == dataUltimaEdicao
            ? _value.dataUltimaEdicao
            : dataUltimaEdicao // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MenuImpl implements _Menu {
  const _$MenuImpl({
    required this.id,
    required this.nome,
    required this.dataCriacao,
    @JsonKey(toJson: _refeicoesPorDiaToJson, fromJson: _refeicoesPorDiaFromJson)
    required final Map<DiaSemana, List<Refeicao>> refeicoesPorDia,
    this.observacoes,
    this.isFavorito = false,
    this.dataUltimaEdicao,
  }) : _refeicoesPorDia = refeicoesPorDia;

  factory _$MenuImpl.fromJson(Map<String, dynamic> json) =>
      _$$MenuImplFromJson(json);

  @override
  final String id;
  @override
  final String nome;
  @override
  final DateTime dataCriacao;
  final Map<DiaSemana, List<Refeicao>> _refeicoesPorDia;
  @override
  @JsonKey(toJson: _refeicoesPorDiaToJson, fromJson: _refeicoesPorDiaFromJson)
  Map<DiaSemana, List<Refeicao>> get refeicoesPorDia {
    if (_refeicoesPorDia is EqualUnmodifiableMapView) return _refeicoesPorDia;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_refeicoesPorDia);
  }

  @override
  final String? observacoes;
  @override
  @JsonKey()
  final bool isFavorito;
  @override
  final DateTime? dataUltimaEdicao;

  @override
  String toString() {
    return 'Menu(id: $id, nome: $nome, dataCriacao: $dataCriacao, refeicoesPorDia: $refeicoesPorDia, observacoes: $observacoes, isFavorito: $isFavorito, dataUltimaEdicao: $dataUltimaEdicao)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MenuImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.dataCriacao, dataCriacao) ||
                other.dataCriacao == dataCriacao) &&
            const DeepCollectionEquality().equals(
              other._refeicoesPorDia,
              _refeicoesPorDia,
            ) &&
            (identical(other.observacoes, observacoes) ||
                other.observacoes == observacoes) &&
            (identical(other.isFavorito, isFavorito) ||
                other.isFavorito == isFavorito) &&
            (identical(other.dataUltimaEdicao, dataUltimaEdicao) ||
                other.dataUltimaEdicao == dataUltimaEdicao));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    nome,
    dataCriacao,
    const DeepCollectionEquality().hash(_refeicoesPorDia),
    observacoes,
    isFavorito,
    dataUltimaEdicao,
  );

  /// Create a copy of Menu
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MenuImplCopyWith<_$MenuImpl> get copyWith =>
      __$$MenuImplCopyWithImpl<_$MenuImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MenuImplToJson(this);
  }
}

abstract class _Menu implements Menu {
  const factory _Menu({
    required final String id,
    required final String nome,
    required final DateTime dataCriacao,
    @JsonKey(toJson: _refeicoesPorDiaToJson, fromJson: _refeicoesPorDiaFromJson)
    required final Map<DiaSemana, List<Refeicao>> refeicoesPorDia,
    final String? observacoes,
    final bool isFavorito,
    final DateTime? dataUltimaEdicao,
  }) = _$MenuImpl;

  factory _Menu.fromJson(Map<String, dynamic> json) = _$MenuImpl.fromJson;

  @override
  String get id;
  @override
  String get nome;
  @override
  DateTime get dataCriacao;
  @override
  @JsonKey(toJson: _refeicoesPorDiaToJson, fromJson: _refeicoesPorDiaFromJson)
  Map<DiaSemana, List<Refeicao>> get refeicoesPorDia;
  @override
  String? get observacoes;
  @override
  bool get isFavorito;
  @override
  DateTime? get dataUltimaEdicao;

  /// Create a copy of Menu
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MenuImplCopyWith<_$MenuImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
