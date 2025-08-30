# Issue: Informação de número de pessoas não é propagada do cardápio para lista de compras

## Descrição do Problema

Atualmente, quando um usuário cria um cardápio, é solicitada a informação sobre quantas pessoas fazem parte do perfil familiar. No entanto, essa informação não está sendo armazenada no modelo de dados do cardápio e, consequentemente, não é propagada para a lista de compras gerada a partir desse cardápio.

## Comportamento Atual

1. Usuário cria um cardápio e informa o número de pessoas
2. A informação é usada apenas durante a geração do cardápio pela IA
3. A informação não é salva no modelo `Menu`
4. Ao gerar uma lista de compras a partir do cardápio, a informação de número de pessoas não está disponível
5. A lista de compras é gerada sem considerar adequadamente a quantidade de pessoas

## Comportamento Esperado

1. A informação de número de pessoas deve ser armazenada no modelo `Menu`
2. Essa informação deve ser propagada para a lista de compras
3. A geração da lista de compras deve considerar o número de pessoas para calcular quantidades adequadas

## Impacto

- **Severidade**: Média
- **Prioridade**: Alta
- **Área afetada**: Geração de listas de compras
- **Experiência do usuário**: Listas de compras podem ter quantidades inadequadas

## Arquivos Envolvidos

- `lib/src/domain/models/menu.dart` - Adicionar campo `numberOfPeople`
- `lib/src/presentation/features/menus/create_menu_page.dart` - Salvar a informação
- `lib/src/presentation/features/shopping/create_shopping_list_from_menu_page.dart` - Usar a informação
- Possíveis migrações de dados existentes

## Tarefas

- [ ] Adicionar campo `numberOfPeople` ao modelo `Menu`
- [ ] Atualizar formulário de criação de cardápio para salvar a informação
- [ ] Modificar geração de lista de compras para usar a informação
- [ ] Atualizar testes unitários
- [ ] Considerar migração de dados existentes

## Labels Sugeridas

- `bug`
- `enhancement`
- `data-model`
- `shopping-lists`
- `menus`

---

**Criado automaticamente durante refatoração da tela de edição de lista de compras**