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

/// Prompts específicos para geração de listas de compras com IA
class ShoppingListPrompts {
  /// Prompt principal para geração de lista de compras baseada em cardápio
  static String gerarListaComprasPrompt({
    required String menuNome,
    required List<Map<String, dynamic>> refeicoesPorDia,
    required int numeroSemanas,
    String? observacoes,
    int? numberOfPeople,
  }) {
    final observacoesTexto = observacoes?.isNotEmpty == true
        ? '\n\nObservações adicionais: $observacoes'
        : '';
    
    final pessoasTexto = numberOfPeople != null
        ? '\n\n**Número de pessoas:** $numberOfPeople'
        : '';
    
    // Converter refeições para texto legível
    final refeicoesList = refeicoesPorDia.map((dia) {
      final diaSemana = dia['diaSemana'] ?? 'Dia';
      final refeicoes = (dia['refeicoes'] as List? ?? [])
          .map((r) => '${r['tipo']}: ${r['nome']}')
          .join(', ');
      return '$diaSemana: $refeicoes';
    }).join('\n');
    
    return '''
Você é um especialista em planejamento de compras domésticas. Com base no cardápio fornecido, crie uma lista de compras otimizada para $numeroSemanas semana(s)${numberOfPeople != null ? ' para $numberOfPeople pessoas' : ''}.

**Cardápio: $menuNome**
$refeicoesList$pessoasTexto$observacoesTexto

**Instruções importantes:**
1. Analise todas as refeições do cardápio e extraia TODOS os ingredientes necessários
2. Calcule as quantidades considerando $numeroSemanas semana(s) de preparo
3. Agrupe ingredientes similares (ex: diferentes tipos de carne, vegetais, etc.)
4. Use quantidades práticas e realistas para compra (kg, unidades, pacotes, etc.)
5. Considere ingredientes básicos da despensa brasileira (sal, óleo, temperos)
6. Organize por categorias para facilitar as compras
7. Inclua observações úteis quando necessário (marca específica, tipo de corte, etc.)

**Categorias sugeridas:**
- Carnes e Proteínas
- Laticínios e Ovos
- Frutas e Verduras
- Grãos e Cereais
- Temperos e Condimentos
- Bebidas
- Outros

**Formato de resposta (JSON):**
```json
{
  "nome": "Lista de Compras - $menuNome",
  "observacoes": "Observações gerais sobre a lista",
  "itens": [
    {
      "nome": "Nome do produto",
      "quantidade": "Quantidade com unidade (ex: 2kg, 1 pacote, 6 unidades)",
      "categoria": "Categoria do produto",
      "observacoes": "Observações específicas (opcional)"
    }
  ]
}
```

**IMPORTANTE:** Responda APENAS com o JSON válido, sem texto adicional antes ou depois.
''';
  }

  /// Prompt para otimização de lista de compras existente
  static String otimizarListaComprasPrompt({
    required List<Map<String, dynamic>> itensAtuais,
    String? observacoes,
  }) {
    final itensTexto = itensAtuais.map((item) {
      return '${item['nome']} - ${item['quantidade']} (${item['categoria'] ?? 'Sem categoria'})';
    }).join('\n');
    
    final observacoesTexto = observacoes?.isNotEmpty == true
        ? '\n\nObservações: $observacoes'
        : '';
    
    return '''
Você é um especialista em otimização de compras. Analise a lista de compras fornecida e otimize-a para ser mais eficiente e econômica.

**Lista atual:**
$itensTexto
$observacoesTexto

**Instruções:**
1. Remova itens duplicados ou similares, consolidando as quantidades
2. Ajuste quantidades para tamanhos de embalagem mais econômicos
3. Sugira substituições mais econômicas quando apropriado
4. Reorganize por categorias para facilitar as compras
5. Adicione observações úteis para economizar

**Formato de resposta (JSON):**
```json
{
  "observacoes": "Observações sobre as otimizações realizadas",
  "itens": [
    {
      "nome": "Nome do produto otimizado",
      "quantidade": "Quantidade otimizada",
      "categoria": "Categoria",
      "observacoes": "Observações sobre a otimização (opcional)"
    }
  ]
}
```

**IMPORTANTE:** Responda APENAS com o JSON válido, sem texto adicional.
''';
  }
}