# Configuração da API do Google Gemini

Este documento explica como configurar a integração com a API do Google Gemini para geração de cardápios com IA no NutriPlan.

## Pré-requisitos

1. Conta no Google Cloud Platform
2. Acesso à API do Google Gemini
3. Chave de API válida

## Passos para Configuração

### 1. Obter Chave da API

1. Acesse o [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Faça login com sua conta Google
3. Clique em "Create API Key"
4. Copie a chave gerada

### 2. Configurar no Projeto

#### Opção 1: Variável de Ambiente (Recomendado)

1. Crie um arquivo `.env` na raiz do projeto:
```bash
GEMINI_API_KEY=sua_chave_aqui
```

2. Adicione o arquivo `.env` ao `.gitignore` (já configurado)

#### Opção 2: Modificar Diretamente o Código

1. Abra o arquivo `lib/src/core/constants/api_keys.dart`
2. Substitua o valor padrão pela sua chave:
```dart
class ApiKeys {
  static const String geminiApiKey = 'SUA_CHAVE_AQUI';
  // ...
}
```

⚠️ **Atenção**: Nunca commite chaves de API no repositório!

### 3. Verificar Configuração

Após configurar a chave, o aplicativo automaticamente:
- Usará o serviço real do Gemini se a chave estiver configurada
- Usará o serviço mock se a chave não estiver configurada

## Funcionalidades Disponíveis

Com a API configurada, você poderá:

### ✅ Geração de Cardápios
- Cardápios semanais personalizados
- Baseados no perfil familiar (número de pessoas, restrições alimentares)
- Configuração de tipos de refeição (café da manhã, almoço, jantar, lanche)
- Observações adicionais personalizadas

### ✅ Geração de Refeições Alternativas
- Substituição de refeições específicas
- Mantém o contexto do perfil familiar
- Respeita as mesmas restrições e preferências

### ✅ Rate Limiting
- Máximo de 5 gerações por dia por usuário
- Contador automático de uso
- Interface para visualizar limite restante
- Reset automático diário

## Estrutura dos Prompts

Os prompts são otimizados para:
- Retornar respostas em formato JSON estruturado
- Incluir ingredientes e quantidades
- Considerar restrições alimentares
- Gerar receitas para o número correto de pessoas
- Manter consistência nutricional

## Tratamento de Erros

O sistema trata automaticamente:
- **Timeout**: Máximo 10 segundos por chamada
- **Rate Limit**: Limite de 5 chamadas por dia
- **Erros de Rede**: Retry automático
- **Respostas Inválidas**: Fallback para serviço mock
- **Chave Inválida**: Fallback para serviço mock

## Monitoramento de Uso

Na tela de Configurações, você pode:
- Ver quantas gerações foram feitas hoje
- Verificar quantas restam
- Acompanhar o progresso do limite diário

## Custos

A API do Gemini tem um tier gratuito generoso:
- 15 requisições por minuto
- 1.500 requisições por dia
- 1 milhão de tokens por mês

Com o rate limiting de 5 gerações por usuário por dia, o uso ficará bem dentro dos limites gratuitos.

## Solução de Problemas

### Erro: "Chave de API inválida"
- Verifique se a chave foi copiada corretamente
- Confirme se a API do Gemini está habilitada no seu projeto
- Teste a chave diretamente no Google AI Studio

### Erro: "Rate limit exceeded"
- Aguarde até o próximo dia (reset às 00:00)
- Verifique o contador na tela de Configurações

### Erro: "Timeout"
- Verifique sua conexão com a internet
- Tente novamente em alguns minutos
- O sistema automaticamente fará fallback para o mock

### Gerações não funcionam
- Confirme que está logado no aplicativo
- Verifique se a chave está configurada corretamente
- Consulte os logs do aplicativo para mais detalhes

## Segurança

- ✅ Chaves de API não são expostas nos logs
- ✅ Dados pessoais não são enviados para a IA
- ✅ Rate limiting previne uso excessivo
- ✅ Fallback automático em caso de problemas
- ✅ Validação de entrada e saída

## Desenvolvimento

Para desenvolvedores:

### Arquivos Principais
- `lib/src/core/constants/api_keys.dart` - Configuração da chave
- `lib/src/core/constants/prompts.dart` - Templates dos prompts
- `lib/src/data/services/gemini_ai_service.dart` - Implementação do serviço
- `lib/src/core/services/rate_limit_service.dart` - Controle de limite
- `lib/src/data/repositories/firestore_menu_repository.dart` - Integração

### Testes
Para testar sem usar a API real:
```dart
// O sistema automaticamente usa o mock se a chave não estiver configurada
// Ou force o uso do mock no di.dart
```

### Logs
Para debug, ative logs detalhados:
```dart
// Em development, os logs da IA são automaticamente habilitados
```

---

**Importante**: Mantenha sua chave de API segura e nunca a compartilhe publicamente!