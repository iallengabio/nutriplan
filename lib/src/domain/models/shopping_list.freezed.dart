// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shopping_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ShoppingList _$ShoppingListFromJson(Map<String, dynamic> json) {
  return _ShoppingList.fromJson(json);
}

/// @nodoc
mixin _$ShoppingList {
  String get id => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;
  DateTime get dataCriacao => throw _privateConstructorUsedError;
  String get menuId => throw _privateConstructorUsedError;
  String get menuNome => throw _privateConstructorUsedError;
  int get numeroSemanas => throw _privateConstructorUsedError;
  @JsonKey(name: 'itens', toJson: _itensToJson, fromJson: _itensFromJson)
  List<ShoppingItem> get itens => throw _privateConstructorUsedError;
  String? get observacoes => throw _privateConstructorUsedError;
  DateTime? get dataUltimaEdicao => throw _privateConstructorUsedError;

  /// Serializes this ShoppingList to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShoppingList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShoppingListCopyWith<ShoppingList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShoppingListCopyWith<$Res> {
  factory $ShoppingListCopyWith(
    ShoppingList value,
    $Res Function(ShoppingList) then,
  ) = _$ShoppingListCopyWithImpl<$Res, ShoppingList>;
  @useResult
  $Res call({
    String id,
    String nome,
    DateTime dataCriacao,
    String menuId,
    String menuNome,
    int numeroSemanas,
    @JsonKey(name: 'itens', toJson: _itensToJson, fromJson: _itensFromJson)
    List<ShoppingItem> itens,
    String? observacoes,
    DateTime? dataUltimaEdicao,
  });
}

/// @nodoc
class _$ShoppingListCopyWithImpl<$Res, $Val extends ShoppingList>
    implements $ShoppingListCopyWith<$Res> {
  _$ShoppingListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShoppingList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? dataCriacao = null,
    Object? menuId = null,
    Object? menuNome = null,
    Object? numeroSemanas = null,
    Object? itens = null,
    Object? observacoes = freezed,
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
            menuId: null == menuId
                ? _value.menuId
                : menuId // ignore: cast_nullable_to_non_nullable
                      as String,
            menuNome: null == menuNome
                ? _value.menuNome
                : menuNome // ignore: cast_nullable_to_non_nullable
                      as String,
            numeroSemanas: null == numeroSemanas
                ? _value.numeroSemanas
                : numeroSemanas // ignore: cast_nullable_to_non_nullable
                      as int,
            itens: null == itens
                ? _value.itens
                : itens // ignore: cast_nullable_to_non_nullable
                      as List<ShoppingItem>,
            observacoes: freezed == observacoes
                ? _value.observacoes
                : observacoes // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$ShoppingListImplCopyWith<$Res>
    implements $ShoppingListCopyWith<$Res> {
  factory _$$ShoppingListImplCopyWith(
    _$ShoppingListImpl value,
    $Res Function(_$ShoppingListImpl) then,
  ) = __$$ShoppingListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String nome,
    DateTime dataCriacao,
    String menuId,
    String menuNome,
    int numeroSemanas,
    @JsonKey(name: 'itens', toJson: _itensToJson, fromJson: _itensFromJson)
    List<ShoppingItem> itens,
    String? observacoes,
    DateTime? dataUltimaEdicao,
  });
}

/// @nodoc
class __$$ShoppingListImplCopyWithImpl<$Res>
    extends _$ShoppingListCopyWithImpl<$Res, _$ShoppingListImpl>
    implements _$$ShoppingListImplCopyWith<$Res> {
  __$$ShoppingListImplCopyWithImpl(
    _$ShoppingListImpl _value,
    $Res Function(_$ShoppingListImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShoppingList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? dataCriacao = null,
    Object? menuId = null,
    Object? menuNome = null,
    Object? numeroSemanas = null,
    Object? itens = null,
    Object? observacoes = freezed,
    Object? dataUltimaEdicao = freezed,
  }) {
    return _then(
      _$ShoppingListImpl(
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
        menuId: null == menuId
            ? _value.menuId
            : menuId // ignore: cast_nullable_to_non_nullable
                  as String,
        menuNome: null == menuNome
            ? _value.menuNome
            : menuNome // ignore: cast_nullable_to_non_nullable
                  as String,
        numeroSemanas: null == numeroSemanas
            ? _value.numeroSemanas
            : numeroSemanas // ignore: cast_nullable_to_non_nullable
                  as int,
        itens: null == itens
            ? _value._itens
            : itens // ignore: cast_nullable_to_non_nullable
                  as List<ShoppingItem>,
        observacoes: freezed == observacoes
            ? _value.observacoes
            : observacoes // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$ShoppingListImpl implements _ShoppingList {
  const _$ShoppingListImpl({
    required this.id,
    required this.nome,
    required this.dataCriacao,
    required this.menuId,
    required this.menuNome,
    required this.numeroSemanas,
    @JsonKey(name: 'itens', toJson: _itensToJson, fromJson: _itensFromJson)
    required final List<ShoppingItem> itens,
    this.observacoes,
    this.dataUltimaEdicao,
  }) : _itens = itens;

  factory _$ShoppingListImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShoppingListImplFromJson(json);

  @override
  final String id;
  @override
  final String nome;
  @override
  final DateTime dataCriacao;
  @override
  final String menuId;
  @override
  final String menuNome;
  @override
  final int numeroSemanas;
  final List<ShoppingItem> _itens;
  @override
  @JsonKey(name: 'itens', toJson: _itensToJson, fromJson: _itensFromJson)
  List<ShoppingItem> get itens {
    if (_itens is EqualUnmodifiableListView) return _itens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_itens);
  }

  @override
  final String? observacoes;
  @override
  final DateTime? dataUltimaEdicao;

  @override
  String toString() {
    return 'ShoppingList(id: $id, nome: $nome, dataCriacao: $dataCriacao, menuId: $menuId, menuNome: $menuNome, numeroSemanas: $numeroSemanas, itens: $itens, observacoes: $observacoes, dataUltimaEdicao: $dataUltimaEdicao)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShoppingListImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.dataCriacao, dataCriacao) ||
                other.dataCriacao == dataCriacao) &&
            (identical(other.menuId, menuId) || other.menuId == menuId) &&
            (identical(other.menuNome, menuNome) ||
                other.menuNome == menuNome) &&
            (identical(other.numeroSemanas, numeroSemanas) ||
                other.numeroSemanas == numeroSemanas) &&
            const DeepCollectionEquality().equals(other._itens, _itens) &&
            (identical(other.observacoes, observacoes) ||
                other.observacoes == observacoes) &&
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
    menuId,
    menuNome,
    numeroSemanas,
    const DeepCollectionEquality().hash(_itens),
    observacoes,
    dataUltimaEdicao,
  );

  /// Create a copy of ShoppingList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShoppingListImplCopyWith<_$ShoppingListImpl> get copyWith =>
      __$$ShoppingListImplCopyWithImpl<_$ShoppingListImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShoppingListImplToJson(this);
  }
}

abstract class _ShoppingList implements ShoppingList {
  const factory _ShoppingList({
    required final String id,
    required final String nome,
    required final DateTime dataCriacao,
    required final String menuId,
    required final String menuNome,
    required final int numeroSemanas,
    @JsonKey(name: 'itens', toJson: _itensToJson, fromJson: _itensFromJson)
    required final List<ShoppingItem> itens,
    final String? observacoes,
    final DateTime? dataUltimaEdicao,
  }) = _$ShoppingListImpl;

  factory _ShoppingList.fromJson(Map<String, dynamic> json) =
      _$ShoppingListImpl.fromJson;

  @override
  String get id;
  @override
  String get nome;
  @override
  DateTime get dataCriacao;
  @override
  String get menuId;
  @override
  String get menuNome;
  @override
  int get numeroSemanas;
  @override
  @JsonKey(name: 'itens', toJson: _itensToJson, fromJson: _itensFromJson)
  List<ShoppingItem> get itens;
  @override
  String? get observacoes;
  @override
  DateTime? get dataUltimaEdicao;

  /// Create a copy of ShoppingList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShoppingListImplCopyWith<_$ShoppingListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ShoppingItem _$ShoppingItemFromJson(Map<String, dynamic> json) {
  return _ShoppingItem.fromJson(json);
}

/// @nodoc
mixin _$ShoppingItem {
  String get id => throw _privateConstructorUsedError;
  String get nome => throw _privateConstructorUsedError;
  String get quantidade => throw _privateConstructorUsedError;
  String? get categoria => throw _privateConstructorUsedError;
  bool get comprado => throw _privateConstructorUsedError;
  String? get observacoes => throw _privateConstructorUsedError;

  /// Serializes this ShoppingItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShoppingItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShoppingItemCopyWith<ShoppingItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShoppingItemCopyWith<$Res> {
  factory $ShoppingItemCopyWith(
    ShoppingItem value,
    $Res Function(ShoppingItem) then,
  ) = _$ShoppingItemCopyWithImpl<$Res, ShoppingItem>;
  @useResult
  $Res call({
    String id,
    String nome,
    String quantidade,
    String? categoria,
    bool comprado,
    String? observacoes,
  });
}

/// @nodoc
class _$ShoppingItemCopyWithImpl<$Res, $Val extends ShoppingItem>
    implements $ShoppingItemCopyWith<$Res> {
  _$ShoppingItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShoppingItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? quantidade = null,
    Object? categoria = freezed,
    Object? comprado = null,
    Object? observacoes = freezed,
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
            quantidade: null == quantidade
                ? _value.quantidade
                : quantidade // ignore: cast_nullable_to_non_nullable
                      as String,
            categoria: freezed == categoria
                ? _value.categoria
                : categoria // ignore: cast_nullable_to_non_nullable
                      as String?,
            comprado: null == comprado
                ? _value.comprado
                : comprado // ignore: cast_nullable_to_non_nullable
                      as bool,
            observacoes: freezed == observacoes
                ? _value.observacoes
                : observacoes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShoppingItemImplCopyWith<$Res>
    implements $ShoppingItemCopyWith<$Res> {
  factory _$$ShoppingItemImplCopyWith(
    _$ShoppingItemImpl value,
    $Res Function(_$ShoppingItemImpl) then,
  ) = __$$ShoppingItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String nome,
    String quantidade,
    String? categoria,
    bool comprado,
    String? observacoes,
  });
}

/// @nodoc
class __$$ShoppingItemImplCopyWithImpl<$Res>
    extends _$ShoppingItemCopyWithImpl<$Res, _$ShoppingItemImpl>
    implements _$$ShoppingItemImplCopyWith<$Res> {
  __$$ShoppingItemImplCopyWithImpl(
    _$ShoppingItemImpl _value,
    $Res Function(_$ShoppingItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShoppingItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nome = null,
    Object? quantidade = null,
    Object? categoria = freezed,
    Object? comprado = null,
    Object? observacoes = freezed,
  }) {
    return _then(
      _$ShoppingItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        nome: null == nome
            ? _value.nome
            : nome // ignore: cast_nullable_to_non_nullable
                  as String,
        quantidade: null == quantidade
            ? _value.quantidade
            : quantidade // ignore: cast_nullable_to_non_nullable
                  as String,
        categoria: freezed == categoria
            ? _value.categoria
            : categoria // ignore: cast_nullable_to_non_nullable
                  as String?,
        comprado: null == comprado
            ? _value.comprado
            : comprado // ignore: cast_nullable_to_non_nullable
                  as bool,
        observacoes: freezed == observacoes
            ? _value.observacoes
            : observacoes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShoppingItemImpl implements _ShoppingItem {
  const _$ShoppingItemImpl({
    required this.id,
    required this.nome,
    required this.quantidade,
    this.categoria,
    this.comprado = false,
    this.observacoes,
  });

  factory _$ShoppingItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShoppingItemImplFromJson(json);

  @override
  final String id;
  @override
  final String nome;
  @override
  final String quantidade;
  @override
  final String? categoria;
  @override
  @JsonKey()
  final bool comprado;
  @override
  final String? observacoes;

  @override
  String toString() {
    return 'ShoppingItem(id: $id, nome: $nome, quantidade: $quantidade, categoria: $categoria, comprado: $comprado, observacoes: $observacoes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShoppingItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nome, nome) || other.nome == nome) &&
            (identical(other.quantidade, quantidade) ||
                other.quantidade == quantidade) &&
            (identical(other.categoria, categoria) ||
                other.categoria == categoria) &&
            (identical(other.comprado, comprado) ||
                other.comprado == comprado) &&
            (identical(other.observacoes, observacoes) ||
                other.observacoes == observacoes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    nome,
    quantidade,
    categoria,
    comprado,
    observacoes,
  );

  /// Create a copy of ShoppingItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShoppingItemImplCopyWith<_$ShoppingItemImpl> get copyWith =>
      __$$ShoppingItemImplCopyWithImpl<_$ShoppingItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShoppingItemImplToJson(this);
  }
}

abstract class _ShoppingItem implements ShoppingItem {
  const factory _ShoppingItem({
    required final String id,
    required final String nome,
    required final String quantidade,
    final String? categoria,
    final bool comprado,
    final String? observacoes,
  }) = _$ShoppingItemImpl;

  factory _ShoppingItem.fromJson(Map<String, dynamic> json) =
      _$ShoppingItemImpl.fromJson;

  @override
  String get id;
  @override
  String get nome;
  @override
  String get quantidade;
  @override
  String? get categoria;
  @override
  bool get comprado;
  @override
  String? get observacoes;

  /// Create a copy of ShoppingItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShoppingItemImplCopyWith<_$ShoppingItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
