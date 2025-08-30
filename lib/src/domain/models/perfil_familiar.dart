import 'package:freezed_annotation/freezed_annotation.dart';

part 'perfil_familiar.freezed.dart';
part 'perfil_familiar.g.dart';

@freezed
class PerfilFamiliar with _$PerfilFamiliar {
  const factory PerfilFamiliar({
    required String id,
    @Default(2) int numeroAdultos,
    @Default(0) int numeroCriancas,
    @Default({}) Set<RestricaoAlimentar> restricoesAlimentares,
    String? observacoesAdicionais,
    DateTime? dataUltimaAtualizacao,
  }) = _PerfilFamiliar;

  factory PerfilFamiliar.fromJson(Map<String, dynamic> json) => _$PerfilFamiliarFromJson(json);
}

@JsonEnum()
enum RestricaoAlimentar {
  @JsonValue('gluten')
  gluten('Glúten'),
  @JsonValue('lactose')
  lactose('Lactose'),
  @JsonValue('acucar')
  acucar('Açúcar'),
  @JsonValue('carne_vermelha')
  carneVermelha('Carne vermelha'),
  @JsonValue('frango')
  frango('Frango'),
  @JsonValue('peixe')
  peixe('Peixe'),
  @JsonValue('ovos')
  ovos('Ovos'),
  @JsonValue('ferro')
  ferro('Ferro'),
  @JsonValue('sal_sodio')
  salSodio('Sal/Sódio');

  const RestricaoAlimentar(this.displayName);
  final String displayName;

  static List<RestricaoAlimentar> get all => RestricaoAlimentar.values;
}

// Extensões úteis para o PerfilFamiliar
extension PerfilFamiliarExtensions on PerfilFamiliar {
  /// Retorna o total de pessoas na família
  int get totalPessoas => numeroAdultos + numeroCriancas;

  /// Verifica se tem alguma restrição alimentar
  bool get temRestricoes => restricoesAlimentares.isNotEmpty;

  /// Retorna as restrições como lista de strings
  List<String> get restricoesComoTexto {
    return restricoesAlimentares.map((r) => r.displayName).toList();
  }

  /// Atualiza o perfil com nova data de modificação
  PerfilFamiliar atualizar() {
    return copyWith(dataUltimaAtualizacao: DateTime.now());
  }

  /// Adiciona uma restrição alimentar
  PerfilFamiliar adicionarRestricao(RestricaoAlimentar restricao) {
    final novasRestricoes = Set<RestricaoAlimentar>.from(restricoesAlimentares);
    novasRestricoes.add(restricao);
    return copyWith(
      restricoesAlimentares: novasRestricoes,
      dataUltimaAtualizacao: DateTime.now(),
    );
  }

  /// Remove uma restrição alimentar
  PerfilFamiliar removerRestricao(RestricaoAlimentar restricao) {
    final novasRestricoes = Set<RestricaoAlimentar>.from(restricoesAlimentares);
    novasRestricoes.remove(restricao);
    return copyWith(
      restricoesAlimentares: novasRestricoes,
      dataUltimaAtualizacao: DateTime.now(),
    );
  }
}