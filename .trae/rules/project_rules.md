# Project Rules - NutriPlan

## Visão Geral do Projeto

O **NutriPlan** é um aplicativo móvel Flutter que auxilia famílias no planejamento nutricional doméstico, oferecendo geração de cardápios semanais personalizados com IA e criação automática de listas de compras.

## Recomendações para os agentes de IA
- Não precisa rodar a aplicação no final das alterações, apenas solicite que o desenvolvedor rode, pois muitas vezes a aplicação já está em execução e necessita apenas de um restart.

## Arquitetura e Padrões

### Arquitetura Principal
- **MVVM (Model-View-ViewModel)** com separação clara de responsabilidades
- **Riverpod** para gerenciamento de estado e injeção de dependências
- **Princípios SOLID** aplicados em todo o código
- **Repository Pattern** para abstração de acesso a dados
- **Result Pattern** para tratamento de erros

### Estrutura de Pastas Obrigatória
```
lib/
  main.dart
  src/
    app.dart              # Widget principal do aplicativo
    di.dart               # Configuração de injeção de dependências
    core/
      constants/          # Constantes da aplicação
      errors/             # Classes de erro e tratamento de exceções
      extensions/         # Extensões de tipos
      theme/              # Configuração de tema
      utils/              # Utilitários gerais
    data/
      datasources/
        local/            # Fontes de dados locais (cache/offline)
        remote/           # Fontes de dados remotos
      repositories/       # Implementações concretas dos repositórios
    domain/
      models/             # Entidades e modelos de domínio (freezed/json)
      repositories/       # Interfaces dos repositórios
      services/           # Serviços de domínio
    presentation/
      common/
        widgets/          # Widgets reutilizáveis
        components/       # Componentes de UI maiores
      features/
        auth/             # Autenticação
        menus/            # Cardápios
        shopping/         # Listas de compras
        settings/         # Configurações
```

## Regras de Desenvolvimento

### 1. Nomenclatura e Convenções
- **Arquivos**: snake_case (ex: `menu_repository.dart`)
- **Classes**: PascalCase (ex: `MenuRepository`)
- **Variáveis e métodos**: camelCase (ex: `generateMenu`)
- **Constantes**: UPPER_SNAKE_CASE (ex: `MAX_AI_CALLS_PER_DAY`)
- **Providers**: sufixo `Provider` (ex: `menuRepositoryProvider`)
- **ViewModels**: sufixo `ViewModel` (ex: `MenuViewModel`)
- **Pages**: sufixo `Page` (ex: `MenuListPage`)

### 2. Gerenciamento de Estado
- **OBRIGATÓRIO**: Usar Riverpod para todos os estados
- **ViewModels**: Usar `StateNotifier` com `AsyncValue` para operações assíncronas
- **Providers**: Definir em arquivos separados ou no `di.dart`
- **Estado local**: Usar `StatefulWidget` apenas quando necessário

### 3. Modelos de Dados
- **OBRIGATÓRIO**: Usar `freezed` para todos os modelos de domínio
- **OBRIGATÓRIO**: Usar `json_serializable` para serialização
- **Imutabilidade**: Todos os modelos devem ser imutáveis
- **Validação**: Implementar validações no construtor quando necessário

### 4. Repositórios e Serviços
- **Interfaces**: Definir sempre interfaces abstratas em `domain/repositories/`
- **Implementações**: Colocar em `data/repositories/`
- **Injeção**: Registrar via Providers no `di.dart`
- **Tratamento de erro**: Usar `Result<T, Exception>` do package `result_dart`

### 5. Integração com Firebase
- **Firestore**: Usar para persistência de cardápios e listas
- **Auth**: Firebase Auth obrigatório para todas as funcionalidades de IA
- **Segurança**: Implementar regras de segurança no Firestore
- **Estrutura de dados**: `users/{userId}/menus/{menuId}` e `users/{userId}/shopping_lists/{listId}`

### 6. Integração com IA
- **Rate Limiting**: Máximo 5 chamadas por dia por usuário
- **Prompts**: Centralizar em `core/constants/prompts.dart`
- **Tratamento de erro**: Implementar retry automático e fallback manual
- **Timeout**: Máximo 10 segundos por chamada

### 7. UI/UX
- **Material Design 3**: Usar `useMaterial3: true`
- **Temas**: Suporte a claro, escuro e automático
- **Responsividade**: Testar em diferentes tamanhos de tela
- **Acessibilidade**: Implementar semantics e voice-over
- **Cores**: Usar `ColorScheme.fromSeed` com verde como cor primária

### 8. Testes
- **Unitários**: Obrigatório para ViewModels e Repositories
- **Widget**: Obrigatório para telas principais
- **Mocks**: Usar `mocktail` para dependências
- **Coverage**: Mínimo 80% para lógica de negócio

## Funcionalidades Principais

### 1. Autenticação
- Login obrigatório para funcionalidades de IA
- Suporte a email/senha e Google/Apple Sign-In
- Recuperação de senha por email
- Monitoramento de limites de uso da API

### 2. Cardápios
- Geração via IA baseada no perfil familiar
- Configuração flexível por cardápio (pessoas, restrições, observações)
- Edição manual (trocar/excluir refeições)
- Persistência no Firestore

### 3. Listas de Compras
- Geração baseada em cardápios selecionados
- Configuração de número de semanas
- Edição manual (adicionar/remover itens)
- Marcar itens como comprados
- Compartilhamento via export/import JSON

### 4. Configurações
- Seleção de tema
- Visualização de limites de uso
- Logout

## Restrições e Limitações

### Fora do Escopo (Primeira Versão)
- Compras online integradas
- Cálculo nutricional avançado
- Suporte multilíngue
- Versões web/desktop

### Limitações Técnicas
- Máximo 5 gerações de IA por dia
- Timeout de 10 segundos para chamadas de IA
- Apenas português brasileiro
- Apenas Android e iOS

## Packages Obrigatórios

### Principais
- `flutter_riverpod` - Estado e DI
- `result_dart` - Tratamento de erros
- `freezed` + `json_serializable` - Modelos de dados
- `firebase_core`, `firebase_auth`, `cloud_firestore` - Backend
- `dio` - HTTP client
- `shared_preferences` - Armazenamento local

### Desenvolvimento
- `mocktail` - Mocks para testes
- `flutter_test` - Testes unitários e widget
- `build_runner` - Geração de código

## Regras de Commit e Versionamento

### Conventional Commits
- `feat:` - Nova funcionalidade
- `fix:` - Correção de bug
- `refactor:` - Refatoração de código
- `test:` - Adição ou modificação de testes
- `docs:` - Documentação
- `style:` - Formatação de código

### Branches
- `main` - Produção
- `develop` - Desenvolvimento
- `feature/*` - Novas funcionalidades
- `fix/*` - Correções

## Segurança e Privacidade

### Dados Pessoais
- Conformidade com LGPD/GDPR
- Não enviar dados desnecessários para IA
- Criptografia de dados sensíveis

### Firebase Security Rules
- Acesso restrito por usuário autenticado
- Validação de estrutura de dados
- Rate limiting no backend

## Performance

### Otimizações Obrigatórias
- Cache local para dados frequentes
- Lazy loading de listas
- Otimização de imagens
- Debounce em campos de busca

### Métricas
- Tempo de resposta da IA: máx. 10s
- Sincronização Firestore: tempo real
- Inicialização do app: máx. 3s

## Monitoramento e Logs

### Logs Obrigatórios
- Chamadas à API de IA (sem expor chaves)
- Erros de rede e Firestore
- Tempo de resposta de operações críticas
- Uso de recursos (memória, CPU)

### Analytics
- Eventos de uso das funcionalidades
- Erros e crashes
- Performance de telas

## Documentação

### Obrigatória
- README.md atualizado
- Documentação de APIs
- Guia de setup do ambiente
- Changelog de versões

### Recomendada
- Diagramas de arquitetura
- Fluxos de usuário
- Guia de contribuição

Este documento deve ser seguido rigorosamente para manter a consistência e qualidade do código do projeto NutriPlan.