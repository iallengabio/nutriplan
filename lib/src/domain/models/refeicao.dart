import 'package:freezed_annotation/freezed_annotation.dart';

part 'refeicao.freezed.dart';
part 'refeicao.g.dart';

@freezed
class Refeicao with _$Refeicao {
  const factory Refeicao({
    required String id,
    required String nome,
    required String descricao,
    required List<String> ingredientes,
    required Map<String, String> quantidades, // ingrediente -> quantidade
    String? observacoes,
    @Default([]) List<String> sugestoesNutricionais,
    @Default(TipoRefeicao.almoco) TipoRefeicao tipo,
    @Default(30) int tempoPreparoMinutos,
    @Default(4) int porcoes,
  }) = _Refeicao;

  factory Refeicao.fromJson(Map<String, dynamic> json) => _$RefeicaoFromJson(json);
}

@JsonEnum()
enum TipoRefeicao {
  @JsonValue('cafe_manha')
  cafeManha('Café da Manhã'),
  @JsonValue('almoco')
  almoco('Almoço'),
  @JsonValue('lanche')
  lanche('Lanche'),
  @JsonValue('jantar')
  jantar('Jantar'),
  @JsonValue('ceia')
  ceia('Ceia');

  const TipoRefeicao(this.displayName);
  final String displayName;
}