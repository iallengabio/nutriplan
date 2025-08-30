/// Prompts específicos para geração de cardápios com IA
class MenuPrompts {
  /// Prompt principal para geração de cardápio completo
  static String gerarCardapioPrompt({
    required int numeroPessoas,
    required List<String> restricoesAlimentares,
    required List<String> tiposRefeicao,
    String? observacoesAdicionais,
  }) {
    final restricoes = restricoesAlimentares.isEmpty 
        ? 'Nenhuma restrição alimentar específica'
        : restricoesAlimentares.join(', ');
    
    final observacoes = observacoesAdicionais?.isNotEmpty == true
        ? '\n\nObservações adicionais: $observacoesAdicionais'
        : '';
    
    return '''
Você é um nutricionista especializado em planejamento de cardápios familiares. Crie um cardápio semanal (7 dias) para uma família com as seguintes características:

**Perfil da Família:**
- Número de pessoas: $numeroPessoas
- Restrições alimentares: $restricoes
- Tipos de refeição desejados: ${tiposRefeicao.join(', ')}
$observacoes

**Instruções importantes:**
1. Crie exatamente 7 dias de cardápio (Segunda a Domingo)
2. Para cada dia, inclua apenas os tipos de refeição solicitados
3. Respeite rigorosamente as restrições alimentares informadas
4. Varie os pratos para evitar repetições
5. Considere praticidade no preparo e ingredientes acessíveis no Brasil
6. Inclua informações nutricionais básicas quando relevante

**Formato de resposta (JSON):**
```json
{
  "nome": "Cardápio Semanal - [Data atual]",
  "observacoes": "Observações gerais sobre o cardápio",
  "diasSemana": [
    {
      "diaSemana": "Segunda-feira",
      "refeicoes": [
        {
          "tipo": "Café da Manhã", // ou "Almoço", "Jantar", "Lanche"
          "nome": "Nome do prato",
          "descricao": "Descrição detalhada dos ingredientes e preparo",
          "observacoes": "Observações específicas (opcional)"
        }
      ]
    }
  ]
}
```

**IMPORTANTE:** Responda APENAS com o JSON válido, sem texto adicional antes ou depois.
''';
  }
  
  /// Prompt para geração de refeição alternativa
  static String gerarRefeicaoAlternativaPrompt({
    required String tipoRefeicao,
    required int numeroPessoas,
    required List<String> restricoesAlimentares,
    String? observacoesAdicionais,
  }) {
    final restricoes = restricoesAlimentares.isEmpty 
        ? 'Nenhuma restrição alimentar específica'
        : restricoesAlimentares.join(', ');
    
    final observacoes = observacoesAdicionais?.isNotEmpty == true
        ? '\n\nObservações adicionais: $observacoesAdicionais'
        : '';
    
    return '''
Você é um nutricionista especializado. Crie uma opção de $tipoRefeicao para uma família com as seguintes características:

**Perfil da Família:**
- Número de pessoas: $numeroPessoas
- Restrições alimentares: $restricoes
$observacoes

**Instruções:**
1. Crie uma opção nutritiva e saborosa
2. Respeite rigorosamente as restrições alimentares
3. Considere praticidade no preparo
4. Use ingredientes acessíveis no Brasil

**Formato de resposta (JSON):**
```json
{
  "tipo": "$tipoRefeicao",
  "nome": "Nome do prato",
  "descricao": "Descrição detalhada dos ingredientes e preparo",
  "observacoes": "Observações específicas (opcional)"
}
```

**IMPORTANTE:** Responda APENAS com o JSON válido, sem texto adicional.
''';
  }
}