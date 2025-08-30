// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'refeicao.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Refeicao _$RefeicaoFromJson(Map<String, dynamic> json) {
  return _Refeicao.fromJson(json);
}

/// @nodoc
mixin _$Refeicao {
  String get id => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;
  String get descricao => throw _privateConstructorUsedError;
  List<String> get ingredientes => throw _privateConstructorUsedError;
  Map<String, String> get quantidades =>
      throw _privateConstructorUsedError; // ingrediente -> quantidade
  String? get observacoes => throw _privateConstructorUsedError;
  List<String> get sugestoesNutricionais => throw _privateConstructorUsedError;
  TipoRefeicao get tipo => throw _privateConstructorUsedError;
  int get tempoPreparoMinutos => throw _privateConstructorUsedError;
  int get porcoes => throw _privateConstructorUsedError;

  /// Serializes this Refeicao to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Refeicao
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RefeicaoCopyWith<Refeicao> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefeicaoCopyWith<$Res> {
  factory $RefeicaoCopyWith(Refeicao value, $Res Function(Refeicao) then) =
      _$RefeicaoCopyWithImpl<$Res, Refeicao>;
  @useResult
  $Res call({
    String id,
    String nome,
    String descricao,
    List<String> ingredientes,
    Map<String, String> quantidades,
    String? observacoes,
    List<String> sugestoesNutricionais,
    TipoRefeicao tipo,
    int tempoPreparoMinutos,
    int porcoes,
  });
}

/// @nodoc
class _$RefeicaoCopyWithImpl<$Res, $Val extends Refeicao>
    implements $RefeicaoCopyWith<$Res> {
  _$RefeicaoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Refeicao
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? descricao = null,
    Object? ingredientes = null,
    Object? quantidades = null,
    Object? observacoes = freezed,
    Object? sugestoesNutricionais = null,
    Object? tipo = null,
    Object? tempoPreparoMinutos = null,
    Object? porcoes = null,
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
            descricao: null == descricao
                ? _value.descricao
                : descricao // ignore: cast_nullable_to_non_nullable
                      as String,
            ingredientes: null == ingredientes
                ? _value.ingredientes
                : ingredientes // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            quantidades: null == quantidades
                ? _value.quantidades
                : quantidades // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            observacoes: freezed == observacoes
                ? _value.observacoes
                : observacoes // ignore: cast_nullable_to_non_nullable
                      as String?,
            sugestoesNutricionais: null == sugestoesNutricionais
                ? _value.sugestoesNutricionais
                : sugestoesNutricionais // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            tipo: null == tipo
                ? _value.tipo
                : tipo // ignore: cast_nullable_to_non_nullable
                      as TipoRefeicao,
            tempoPreparoMinutos: null == tempoPreparoMinutos
                ? _value.tempoPreparoMinutos
                : tempoPreparoMinutos // ignore: cast_nullable_to_non_nullable
                      as int,
            porcoes: null == porcoes
                ? _value.porcoes
                : porcoes // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RefeicaoImplCopyWith<$Res>
    implements $RefeicaoCopyWith<$Res> {
  factory _$$RefeicaoImplCopyWith(
    _$RefeicaoImpl value,
    $Res Function(_$RefeicaoImpl) then,
  ) = __$$RefeicaoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String nome,
    String descricao,
    List<String> ingredientes,
    Map<String, String> quantidades,
    String? observacoes,
    List<String> sugestoesNutricionais,
    TipoRefeicao tipo,
    int tempoPreparoMinutos,
    int porcoes,
  });
}

/// @nodoc
class __$$RefeicaoImplCopyWithImpl<$Res>
    extends _$RefeicaoCopyWithImpl<$Res, _$RefeicaoImpl>
    implements _$$RefeicaoImplCopyWith<$Res> {
  __$$RefeicaoImplCopyWithImpl(
    _$RefeicaoImpl _value,
    $Res Function(_$RefeicaoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Refeicao
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? descricao = null,
    Object? ingredientes = null,
    Object? quantidades = null,
    Object? observacoes = freezed,
    Object? sugestoesNutricionais = null,
    Object? tipo = null,
    Object? tempoPreparoMinutos = null,
    Object? porcoes = null,
  }) {
    return _then(
      _$RefeicaoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        nome: null == nome
            ? _value.nome
            : nome // ignore: cast_nullable_to_non_nullable
                  as String,
        descricao: null == descricao
            ? _value.descricao
            : descricao // ignore: cast_nullable_to_non_nullable
                  as String,
        ingredientes: null == ingredientes
            ? _value._ingredientes
            : ingredientes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        quantidades: null == quantidades
            ? _value._quantidades
            : quantidades // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        observacoes: freezed == observacoes
            ? _value.observacoes
            : observacoes // ignore: cast_nullable_to_non_nullable
                  as String?,
        sugestoesNutricionais: null == sugestoesNutricionais
            ? _value._sugestoesNutricionais
            : sugestoesNutricionais // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        tipo: null == tipo
            ? _value.tipo
            : tipo // ignore: cast_nullable_to_non_nullable
                  as TipoRefeicao,
        tempoPreparoMinutos: null == tempoPreparoMinutos
            ? _value.tempoPreparoMinutos
            : tempoPreparoMinutos // ignore: cast_nullable_to_non_nullable
                  as int,
        porcoes: null == porcoes
            ? _value.porcoes
            : porcoes // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RefeicaoImpl implements _Refeicao {
  const _$RefeicaoImpl({
    required this.id,
    required this.nome,
    required this.descricao,
    required final List<String> ingredientes,
    required final Map<String, String> quantidades,
    this.observacoes,
    final List<String> sugestoesNutricionais = const [],
    this.tipo = TipoRefeicao.almoco,
    this.tempoPreparoMinutos = 30,
    this.porcoes = 4,
  }) : _ingredientes = ingredientes,
       _quantidades = quantidades,
       _sugestoesNutricionais = sugestoesNutricionais;

  factory _$RefeicaoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RefeicaoImplFromJson(json);

  @override
  final String id;
  @override
  final String nome;
  @override
  final String descricao;
  final List<String> _ingredientes;
  @override
  List<String> get ingredientes {
    if (_ingredientes is EqualUnmodifiableListView) return _ingredientes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredientes);
  }

  final Map<String, String> _quantidades;
  @override
  Map<String, String> get quantidades {
    if (_quantidades is EqualUnmodifiableMapView) return _quantidades;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_quantidades);
  }

  // ingrediente -> quantidade
  @override
  final String? observacoes;
  final List<String> _sugestoesNutricionais;
  @override
  @JsonKey()
  List<String> get sugestoesNutricionais {
    if (_sugestoesNutricionais is EqualUnmodifiableListView)
      return _sugestoesNutricionais;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sugestoesNutricionais);
  }

  @override
  @JsonKey()
  final TipoRefeicao tipo;
  @override
  @JsonKey()
  final int tempoPreparoMinutos;
  @override
  @JsonKey()
  final int porcoes;

  @override
  String toString() {
    return 'Refeicao(id: $id, nome: $nome, descricao: $descricao, ingredientes: $ingredientes, quantidades: $quantidades, observacoes: $observacoes, sugestoesNutricionais: $sugestoesNutricionais, tipo: $tipo, tempoPreparoMinutos: $tempoPreparoMinutos, porcoes: $porcoes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefeicaoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.descricao, descricao) ||
                other.descricao == descricao) &&
            const DeepCollectionEquality().equals(
              other._ingredientes,
              _ingredientes,
            ) &&
            const DeepCollectionEquality().equals(
              other._quantidades,
              _quantidades,
            ) &&
            (identical(other.observacoes, observacoes) ||
                other.observacoes == observacoes) &&
            const DeepCollectionEquality().equals(
              other._sugestoesNutricionais,
              _sugestoesNutricionais,
            ) &&
            (identical(other.tipo, tipo) || other.tipo == tipo) &&
            (identical(other.tempoPreparoMinutos, tempoPreparoMinutos) ||
                other.tempoPreparoMinutos == tempoPreparoMinutos) &&
            (identical(other.porcoes, porcoes) || other.porcoes == porcoes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    nome,
    descricao,
    const DeepCollectionEquality().hash(_ingredientes),
    const DeepCollectionEquality().hash(_quantidades),
    observacoes,
    const DeepCollectionEquality().hash(_sugestoesNutricionais),
    tipo,
    tempoPreparoMinutos,
    porcoes,
  );

  /// Create a copy of Refeicao
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefeicaoImplCopyWith<_$RefeicaoImpl> get copyWith =>
      __$$RefeicaoImplCopyWithImpl<_$RefeicaoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RefeicaoImplToJson(this);
  }
}

abstract class _Refeicao implements Refeicao {
  const factory _Refeicao({
    required final String id,
    required final String nome,
    required final String descricao,
    required final List<String> ingredientes,
    required final Map<String, String> quantidades,
    final String? observacoes,
    final List<String> sugestoesNutricionais,
    final TipoRefeicao tipo,
    final int tempoPreparoMinutos,
    final int porcoes,
  }) = _$RefeicaoImpl;

  factory _Refeicao.fromJson(Map<String, dynamic> json) =
      _$RefeicaoImpl.fromJson;

  @override
  String get id;
  @override
  String get nome;
  @override
  String get descricao;
  @override
  List<String> get ingredientes;
  @override
  Map<String, String> get quantidades; // ingrediente -> quantidade
  @override
  String? get observacoes;
  @override
  List<String> get sugestoesNutricionais;
  @override
  TipoRefeicao get tipo;
  @override
  int get tempoPreparoMinutos;
  @override
  int get porcoes;

  /// Create a copy of Refeicao
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefeicaoImplCopyWith<_$RefeicaoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
