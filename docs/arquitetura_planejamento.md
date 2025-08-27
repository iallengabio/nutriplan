# Arquitetura e Planejamento — NutriPlan

**Visão geral**  
Documento com a especificação de arquitetura, padrões de projeto, principais pacotes, estrutura de arquivos e fluxo de exemplo para o aplicativo **NutriPlan**. Baseado em **MVVM** com **separação de estado via Riverpod** e adotando princípios **SOLID**. Neste projeto será utilizada a arquitetura MVVM recomendada pelo flutter. 

---

## 1. Objetivos arquiteturais
- Manter o código **organizável, testável e legível**.  
- Permitir **troca fácil de implementações** (ex.: mock de IA, mudança de DB).  
- Evitar excesso de camadas e verbosidade; **equilíbrio entre simplicidade e boa engenharia**.  
- Seguir **SOLID** para facilitar manutenção e evolução.

---

## 2. Escolha de arquitetura e padrões
### Arquitetura principal
- **MVVM (Model-View-ViewModel)**  
  - **View**: Widgets/Telas (UI).  
  - **ViewModel**: Lógica de apresentação e estado (StateNotifier / StateNotifierProvider / AsyncValue).  
  - **Model**: Repositories e Services.

### Gerenciamento de estado / DI
- **Riverpod (flutter_riverpod)** como gerenciador de estado e mecanismo de injeção de dependências (Providers).

### Padrões de projeto aplicados
- **Repository Pattern** — abstrai acesso a dados (IA, DB, Auth).
- **Service Pattern** — encapsula lógica de negócio.
- **Result Pattern** — encapsula sucesso/erro em um único tipo.
- **Command Pattern** — encapsula uma operação como um objeto. especialmente útil para o gerenciamento de estado no viewmodel.
- **Factory** — para construção de entidades complexas quando necessário. 
- **Singleton (via Provider)** — para serviços que devem ser únicos (ex: Hive box manager, Firebase client).

---

## 3. Principais packages recomendados
- `flutter_riverpod` — estado e DI.
- `result_dart` — encapsula sucesso/erro em um único tipo.
- `shared_preferences` — armazenamento local simples e performático.
- `http` ou `dio` — chamadas HTTP (use `dio` se quiser interceptors/log).  
- `firebase_auth`, `google_sign_in`, `sign_in_with_apple` — autenticação.  
- `intl` — formatação de datas/números.  
- `flutter_local_notifications` (opcional) — lembretes / notificações.  
- `mocktail` / `mockito` — testes unitários/mocks.  
- `flutter_test` / `integration_test` — testes widget e integração.  

---

## 4. Como aplicar SOLID (princípios) no projeto
- **S**ingle Responsibility: cada ViewModel cuida de UMA tela/fluxo; repositórios cuidam de UMA fonte de dados.  
- **O**pen/Closed: abstrações (interfaces) para repositórios; implementar novas estratégias sem alterar código existente.  
- **L**iskov: contratos (interfaces) para repositórios/serviços; fakes devem poder substituir reais nos testes.  
- **I**nterface Segregation: dividir interfaces grandes (ex: `IAService`) em interfaces menores (`PromptService`, `ModelService`) quando necessário.  
- **D**ependency Inversion: ViewModels dependem de abstrações (Providers que retornam interfaces), não de implementações concretas.

---

## 5. Estrutura de pastas sugerida
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
        local/            # Fontes de dados locais
          hive_manager.dart
          secure_storage.dart
        remote/           # Fontes de dados remotos
          http_client.dart
          ai_api_client.dart
      repositories/       # Implementações concretas dos repositórios
        auth_repository_impl.dart
        menu_repository_impl.dart
        shopping_repository_impl.dart
    domain/
      models/             # Entidades e modelos de domínio (freezed/json)
        user.dart
        menu.dart
        shopping_list.dart
      repositories/       # Interfaces dos repositórios
        auth_repository.dart
        menu_repository.dart
        shopping_repository.dart
      services/           # Serviços de domínio
        ai_service.dart
        auth_service.dart
    presentation/
      common/
        widgets/          # Widgets reutilizáveis
        components/       # Componentes de UI maiores
      features/
        auth/
          login/
            login_page.dart
            login_viewmodel.dart
          register/
            register_page.dart
            register_viewmodel.dart
        profile/
          profile_page.dart
          profile_viewmodel.dart
        menus/            # cardápios
          menu_list/
            menu_list_page.dart
            menu_list_viewmodel.dart
          menu_create/
            menu_create_page.dart
            menu_create_viewmodel.dart
          menu_edit/
            menu_edit_page.dart
            menu_edit_viewmodel.dart
        shopping/         # listas de compras
          shopping_list/
            shopping_list_page.dart
            shopping_list_viewmodel.dart
          shopping_create/
            shopping_create_page.dart
            shopping_create_viewmodel.dart
          shopping_edit/
            shopping_edit_page.dart
            shopping_edit_viewmodel.dart
        settings/
          settings_page.dart
          settings_viewmodel.dart
```

### Relação com as camadas do MVVM

Esta estrutura de pastas foi projetada para refletir claramente as camadas do padrão MVVM (Model-View-ViewModel):

1. **Model (Modelo)**
   - Representado pelas pastas `domain/models`, `domain/repositories` e `domain/services`
   - Contém as entidades de negócio, interfaces de repositórios e serviços de domínio
   - Define os contratos e regras de negócio da aplicação
   - Independente de frameworks e detalhes de implementação

2. **View (Visão)**
   - Representado pelos arquivos `*_page.dart` dentro de `presentation/features/*`
   - Responsável apenas pela interface do usuário (UI)
   - Não contém lógica de negócio, apenas lógica de apresentação
   - Observa mudanças no ViewModel e atualiza a UI de acordo

3. **ViewModel (Modelo de Visão)**
   - Representado pelos arquivos `*_viewmodel.dart` dentro de `presentation/features/*`
   - Atua como intermediário entre o Model e a View
   - Contém a lógica de apresentação e gerencia o estado da UI
   - Expõe dados e comandos que a View pode consumir
   - Utiliza os repositórios para acessar e manipular dados

4. **Camada de Dados**
   - Representado pela pasta `data/`
   - Implementa as interfaces definidas em `domain/repositories`
   - Gerencia fontes de dados (locais e remotas)
   - Não é parte direta do MVVM, mas dá suporte ao Model

Esta organização promove:
- **Separação de responsabilidades**: cada camada tem um propósito claro
- **Testabilidade**: fácil mockar dependências para testes unitários
- **Manutenibilidade**: alterações em uma camada não afetam necessariamente as outras
- **Escalabilidade**: novas features seguem o mesmo padrão estrutural

---

## 6. Injeção de dependências com Riverpod (padrão)
- **Services / infra providers** (singleton):
```dart
final httpClientProvider = Provider<HttpClient>((ref) {
  return HttpClient(); // configurações, interceptors
});

final aiApiServiceProvider = Provider<AiApiService>((ref) {
  final client = ref.read(httpClientProvider);
  final apiKey = ref.watch(configProvider).aiKey;
  return AiApiService(client, apiKey);
});
```
- **Repositories**:
```dart
final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  final ai = ref.read(aiApiServiceProvider);
  final local = ref.read(hiveBoxProvider);
  return MenuRepositoryImpl(ai, local);
});
```
- **ViewModels**:
```dart
final menuViewModelProvider = StateNotifierProvider<MenuViewModel, AsyncValue<Menu?>>((ref) {
  final repo = ref.read(menuRepositoryProvider);
  return MenuViewModel(repo);
});
```
- **Testability**: em testes você sobrescreve providers com `overrideWithValue` ou `overrideWithProvider`.

---

## 7. Contratos/Interfaces importantes (exemplos)
- `AiApiService` (interface)
  - `Future<String> gerarCardapio(PromptData data)`
  - `Future<List<Item>> gerarListaDeCompras(Menu menu, int semanas)`
- `MenuRepository`
  - `Future<Menu> gerarMenu(PerfilUsuario perfil)`
  - `Future<void> salvarMenu(Menu menu)`
  - `Future<List<Menu>> listarMenus()`
- `ShoppingRepository`
  - `Future<ListaCompras> gerarLista(Menu menu, int semanas)`
  - `Future<void> salvarLista(ListaCompras lista)`

---

## 8. Serialização e modelos
- Use `json_serializable` (ou `freezed` + `json_serializable`) para gerar `fromJson/toJson`.  
- Modelos core: `Usuario`, `PerfilFamiliar`, `Menu`, `Refeicao`, `Ingrediente`, `ListaCompras`, `ItemLista`.

---

## 9. Testes
- **Unitários**: ViewModels e Repositories com `mocktail`/`mockito`.  
- **Widget tests**: telas importantes (ex: Tela de criação de cardápio, edição de lista).  
- **Integration tests**: fluxo end-to-end (criar cardápio → gerar lista → marcar item).  
- **CI**: executar `flutter test` + análise estática (dart analyze) em pipeline (GitHub Actions/GitLab CI).

---

## 10. Exemplo de fluxo da aplicação (cenário: criar cardápio e gerar lista)
1. Usuário abre **Tela Criar Cardápio** e marca refeições + escreve observações.  
2. Usuário clica **Gerar Cardápio**. Tela aciona `menuViewModel.gerarNovoCardapio(perfil, opcoes)`.  
3. `MenuViewModel` altera estado para `loading` e chama `MenuRepository.gerarMenu(perfil)`.  
4. `MenuRepositoryImpl` constrói prompt e chama `AiApiService.gerarCardapio(prompt)`.  
5. `AiApiService` faz requisição HTTP ao endpoint da IA e retorna JSON com cardápio.  
6. `MenuRepositoryImpl` converte JSON em `Menu` (Mapper) e persiste em Hive (`hiveBox.put(menu.id, menu)`) e retorna o menu.  
7. `MenuViewModel` atualiza estado para `data(menu)`; a View reage e navega para **Tela Editar Cardápio**.  
8. Usuário revisa e salva; ao confirmar, o menu já está gravado localmente.  
9. Na aba **Gerenciar Listas**, usuário cria nova lista selecionando o menu e informando número de semanas.  
10. `ShoppingViewModel` chama `ShoppingRepository.gerarLista(menu, semanas)` que chama `AiApiService.gerarListaDeCompras(menu, semanas)`.  
11. Lista é recebida, mapeada, salva em Hive e a UI abre **Tela Editar Lista** com os itens.  

---

## 11. Boas práticas e recomendações
- **Evite lógica de negócio nas Views** — tudo via ViewModel.  
- **Prompts** para IA devem ser centralizados (arquivo `core/prompts/`) e versionados.  
- **Rate limiting local** implementado no repositório (ex: contador por usuário armazenado localmente).  
- **Feature flags** simples via config para alternar modelos de IA em produção/teste.  
- **Logging / Telemetria**: logs para chamadas à IA (sem expor chave), erros, latência.  

---

## 12. Próximos passos sugeridos
1. Criar `di/` com providers básicos (http, hive, auth).  
2. Modelar entidades com `freezed` + `json_serializable`.  
3. Implementar `AiApiService` com interface e um `FakeAiApiService` para testes.  
4. Implementar `MenuRepository` e `MenuViewModel` + testes unitários.  
5. UI mínima para fluxo criar → editar menu → gerar lista.

