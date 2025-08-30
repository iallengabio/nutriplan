import 'package:freezed_annotation/freezed_annotation.dart';
import 'refeicao.dart';

part 'menu.freezed.dart';
part 'menu.g.dart';

@freezed
class Menu with _$Menu {
  const factory Menu({
    required String id,
    required String nome,
    required DateTime dataCriacao,
    @JsonKey(toJson: _refeicoesPorDiaToJson, fromJson: _refeicoesPorDiaFromJson)
    required Map<DiaSemana, List<Refeicao>> refeicoesPorDia,
    String? observacoes,
    @Default(false) bool isFavorito,
    DateTime? dataUltimaEdicao,
    @Default(4) int numberOfPeople,
  }) = _Menu;

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);
}

// Funções auxiliares para serialização do Map<DiaSemana, List<Refeicao>>
Map<String, dynamic> _refeicoesPorDiaToJson(Map<DiaSemana, List<Refeicao>> refeicoesPorDia) {
  return refeicoesPorDia.map(
    (dia, refeicoes) => MapEntry(
      _getDiaSemanaJsonValue(dia),
      refeicoes.map((refeicao) => refeicao.toJson()).toList(),
    ),
  );
}

Map<DiaSemana, List<Refeicao>> _refeicoesPorDiaFromJson(Map<String, dynamic> json) {
  return json.map(
    (key, value) => MapEntry(
      _getDiaSemanaFromJsonValue(key),
      (value as List<dynamic>)
          .map((refeicaoJson) => Refeicao.fromJson(refeicaoJson as Map<String, dynamic>))
          .toList(),
    ),
  );
}

// Funções auxiliares para conversão do enum DiaSemana
String _getDiaSemanaJsonValue(DiaSemana dia) {
  switch (dia) {
    case DiaSemana.segunda:
      return 'segunda';
    case DiaSemana.terca:
      return 'terca';
    case DiaSemana.quarta:
      return 'quarta';
    case DiaSemana.quinta:
      return 'quinta';
    case DiaSemana.sexta:
      return 'sexta';
    case DiaSemana.sabado:
      return 'sabado';
    case DiaSemana.domingo:
      return 'domingo';
  }
}

DiaSemana _getDiaSemanaFromJsonValue(String value) {
  switch (value) {
    case 'segunda':
      return DiaSemana.segunda;
    case 'terca':
      return DiaSemana.terca;
    case 'quarta':
      return DiaSemana.quarta;
    case 'quinta':
      return DiaSemana.quinta;
    case 'sexta':
      return DiaSemana.sexta;
    case 'sabado':
      return DiaSemana.sabado;
    case 'domingo':
      return DiaSemana.domingo;
    default:
      throw ArgumentError('Valor inválido para DiaSemana: $value');
  }
}

@JsonEnum()
enum DiaSemana {
  @JsonValue('segunda')
  segunda('Segunda-feira'),
  @JsonValue('terca')
  terca('Terça-feira'),
  @JsonValue('quarta')
  quarta('Quarta-feira'),
  @JsonValue('quinta')
  quinta('Quinta-feira'),
  @JsonValue('sexta')
  sexta('Sexta-feira'),
  @JsonValue('sabado')
  sabado('Sábado'),
  @JsonValue('domingo')
  domingo('Domingo');

  const DiaSemana(this.displayName);
  final String displayName;

  static List<DiaSemana> get all => DiaSemana.values;
}

// Extensões úteis para o Menu
extension MenuExtensions on Menu {
  /// Retorna o total de refeições no cardápio
  int get totalRefeicoes {
    return refeicoesPorDia.values
        .fold(0, (total, refeicoes) => total + refeicoes.length);
  }

  /// Retorna todos os ingredientes únicos do cardápio
  Set<String> get todosIngredientes {
    final ingredientes = <String>{};
    for (final refeicoes in refeicoesPorDia.values) {
      for (final refeicao in refeicoes) {
        ingredientes.addAll(refeicao.ingredientes);
      }
    }
    return ingredientes;
  }

  /// Retorna as refeições de um dia específico
  List<Refeicao> refeicoesDoDia(DiaSemana dia) {
    return refeicoesPorDia[dia] ?? [];
  }

  /// Adiciona uma refeição a um dia específico
  Menu adicionarRefeicao(DiaSemana dia, Refeicao refeicao) {
    final novasRefeicoes = Map<DiaSemana, List<Refeicao>>.from(refeicoesPorDia);
    final refeicoesDoDia = List<Refeicao>.from(novasRefeicoes[dia] ?? []);
    refeicoesDoDia.add(refeicao);
    novasRefeicoes[dia] = refeicoesDoDia;
    
    return copyWith(
      refeicoesPorDia: novasRefeicoes,
      dataUltimaEdicao: DateTime.now(),
    );
  }

  /// Remove uma refeição de um dia específico
  Menu removerRefeicao(DiaSemana dia, String refeicaoId) {
    final novasRefeicoes = Map<DiaSemana, List<Refeicao>>.from(refeicoesPorDia);
    final refeicoesDoDia = List<Refeicao>.from(novasRefeicoes[dia] ?? []);
    refeicoesDoDia.removeWhere((r) => r.id == refeicaoId);
    novasRefeicoes[dia] = refeicoesDoDia;
    
    return copyWith(
      refeicoesPorDia: novasRefeicoes,
      dataUltimaEdicao: DateTime.now(),
    );
  }

  /// Substitui uma refeição em um dia específico
  Menu substituirRefeicao(DiaSemana dia, String refeicaoId, Refeicao novaRefeicao) {
    final novasRefeicoes = Map<DiaSemana, List<Refeicao>>.from(refeicoesPorDia);
    final refeicoesDoDia = List<Refeicao>.from(novasRefeicoes[dia] ?? []);
    final index = refeicoesDoDia.indexWhere((r) => r.id == refeicaoId);
    
    if (index != -1) {
      refeicoesDoDia[index] = novaRefeicao;
      novasRefeicoes[dia] = refeicoesDoDia;
    }
    
    return copyWith(
      refeicoesPorDia: novasRefeicoes,
      dataUltimaEdicao: DateTime.now(),
    );
  }
}