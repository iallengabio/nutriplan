# Especificação de Requisitos do Aplicativo **NutriPlan**

## 1. Introdução

### 1.1 Propósito  
Este documento descreve, de forma clara e detalhada, os requisitos funcionais e não funcionais do aplicativo móvel **NutriPlan**, desenvolvido em **Flutter** (Android/iOS).  

O **NutriPlan** auxilia famílias no planejamento nutricional doméstico, oferecendo:  
- Geração de **cardápios semanais personalizados** com suporte de Inteligência Artificial (IA).  
- Criação automática de **listas de compras**, baseadas no cardápio.  
- Recursos de **edição, compartilhamento e armazenamento local**.  

Objetivo principal: **promover refeições saudáveis e simplificar a organização alimentar familiar**.

### 1.2 Escopo  
O aplicativo contempla:  
- Configuração e gerenciamento de perfil familiar persistente (quantidade de pessoas, restrições, preferências).  
- Geração de cardápios semanais via API de IA baseada no perfil familiar salvo.  
- Edição manual do cardápio.  
- Criação e gerenciamento de listas de compras baseadas no cardápio.  
- Autenticação de usuário para controle de uso da API de IA.  
- Armazenamento de perfil familiar, cardápios e listas no Firebase Firestore.  
- Compartilhamento de listas entre usuários.  
- Configurações de tema e informações de uso.  

**Fora do escopo (não implementado na primeira versão):**  
- Compras online integradas a supermercados.  
- Cálculo nutricional avançado (sem apoio da IA externa).  
- Suporte multilíngue (apenas português inicialmente).  
- Versões web ou desktop.

### 1.3 Definições  
- **IA**: Inteligência Artificial externa (ex: OpenAI, Gemini, etc.).  
- **Perfil Familiar**: Configuração persistente do usuário contendo informações sobre a família (adultos, crianças, restrições alimentares, observações).  
- **Cardápio Semanal**: Sugestão de refeições para 7 dias (café da manhã, almoço, lanche, jantar, ceia).  
- **Lista de Compras**: Ingredientes agregados a partir do cardápio.  
- **API de IA**: Serviço externo utilizado para geração de conteúdo.  
- **Flutter**: Framework cross-platform para iOS e Android.  

---

## 2. Requisitos Funcionais

### 2.1 Autenticação e Usuário
- **RF1.1**: O app **deve exigir login obrigatório** para todas as funções que dependem de IA.  
- **RF1.2**: O login pode ser feito via **e-mail e senha** ou **Google/Apple**.  
- **RF1.3**: O usuário pode criar conta ou recuperar senha por e-mail.  
- **RF1.4**: O sistema deve **monitorar e limitar chamadas à API** (ex.: 5 por dia).  
- **RF1.5**: Dados de autenticação devem ser armazenados de forma segura (ex.: Firebase Auth).

### 2.2 Perfil Familiar
- **RF2.1**: O usuário deve **configurar seu perfil familiar** que será usado como base para todas as gerações de cardápio:  
  - Quantidade de adultos.  
  - Quantidade de crianças.  
- **RF2.2**: O usuário pode selecionar **restrições alimentares** no perfil familiar. Lista de opções:  
  - Glúten  
  - Lactose  
  - Açúcar  
  - Carne vermelha  
  - Frango  
  - Peixe  
  - Ovos  
  - Ferro (ex.: restrição para pacientes com hemocromatose)  
  - Sal/sódio  
- **RF2.3**: O usuário pode inserir **observações adicionais** no perfil familiar.  
- **RF2.4**: O perfil familiar deve ser **salvo no Firebase Firestore** e usado automaticamente em todas as gerações de cardápio.  
- **RF2.5**: Novos usuários devem ter um **perfil familiar padrão** criado automaticamente (1 adulto, 0 crianças, sem restrições).  
- **RF2.6**: O usuário pode **editar seu perfil familiar** a qualquer momento através de uma tela específica.

### 2.3 Cardápios
- **RF3.1**: O app deve gerar um **cardápio semanal** usando IA, com base no perfil familiar.  
- **RF3.2**: O cardápio deve incluir:  
  - Ingredientes necessários.  
  - Quantidades aproximadas.  
  - Sugestões nutricionais.  
- **RF3.3**: O usuário pode **trocar refeições específicas** (gerando alternativas com IA).  
- **RF3.4**: O usuário pode **excluir refeições** individualmente.  
- **RF3.5**: O cardápio aprovado deve ser **salvo no Firebase Firestore** com separação por usuário.  
- **RF3.6**: O app deve tratar **erros da IA** (ex.: retry automático ou fallback manual).

### 2.4 Lista de Compras
- **RF4.1**: O usuário pode gerar uma **lista de compras** baseada em um cardápio selecionado.  
- **RF4.2**: A lista deve considerar:  
  - Número de semanas especificado pelo usuário.  
- **RF4.3**: A lista deve ser **armazenada no Firebase Firestore** com data de criação e separação por usuário.  
- **RF4.4**: O usuário pode **marcar itens como comprados** (checkbox).  
- **RF4.5**: O usuário pode **editar manualmente a lista** (adicionar/remover itens).  
- **RF4.6**: Deve haver suporte para **múltiplas listas salvas**.  
- **RF4.7**: O usuário pode **duplicar listas existentes** para reutilização.  

### 2.5 Compartilhamento
- **RF5.1**: O usuário pode **exportar listas** em formato padrão (JSON ou similar).  
- **RF5.2**: Outro usuário pode **importar listas** no NutriPlan.  
- **RF5.3**: O app deve **validar o formato** da lista antes de importar.  

### 2.6 Integração com IA
- **RF6.1**: Todas as gerações (cardápio/lista) devem usar chamadas à **API de IA**.  
- **RF6.2**: O app deve ter **rate limiting local** (máx. 5 gerações/dia).  
- **RF6.3**: O app deve usar **prompts padronizados**, baseados no perfil do usuário.  

### 2.7 Configurações
- **RF7.1**: O usuário pode **fazer logout**.  
- **RF7.2**: O usuário pode visualizar informações de uso e limites.  
- **RF7.3**: O usuário pode selecionar o tema do app entre: **Claro, Escuro ou Automático (de acordo com SO)**.  

---

## 3. Requisitos Não Funcionais

### 3.1 Desempenho
- **RNF1.1**: Tempo máximo de resposta da IA: **10 segundos**.  
- **RNF1.2**: O app deve sincronizar dados com o **Firebase Firestore** em tempo real.  
- **RNF1.3**: O app deve ter **cache local** para melhor performance e funcionalidade offline básica.  

### 3.2 Usabilidade
- **RNF2.1**: Interface intuitiva, responsiva (iOS/Android).  
- **RNF2.2**: Suporte a **tema claro/escuro/automático**.  
- **RNF2.3**: Acessibilidade (texto legível, voice-over).  
- **RNF2.4**: Mensagens de erro claras e tutoriais iniciais.  

### 3.3 Segurança
- **RNF3.1**: Dados devem ser **protegidos por regras de segurança do Firestore** garantindo acesso apenas ao usuário proprietário.  
- **RNF3.2**: Chamadas à IA não devem enviar dados pessoais desnecessários.  
- **RNF3.3**: Conformidade com **LGPD/GDPR**.  
- **RNF3.4**: Autenticação obrigatória para acesso aos dados no Firestore.  

### 3.4 Confiabilidade
- **RNF4.1**: O app deve lidar com falhas de rede, mantendo **sincronização automática** quando a conexão for restabelecida.  
- **RNF4.2**: O **Firebase Firestore** garante backup automático e redundância dos dados.  
- **RNF4.3**: Implementar **retry automático** para operações que falharam por problemas de conectividade.  

### 3.5 Manutenibilidade
- **RNF5.1**: Código modular em Flutter (separação UI, lógica e IA).  
- **RNF5.2**: Suporte a atualizações **over-the-air** de prompts.  

---

## 4. Casos de Uso

### 4.1 Configurar Perfil Familiar
- **Ator**: Usuário logado.  
- **Pré-condição**: Usuário autenticado.  
- **Fluxo**: Acessar configurações → Editar perfil familiar → Definir adultos/crianças → Selecionar restrições → Adicionar observações → Salvar.  
- **Pós-condição**: Perfil familiar armazenado no Firebase Firestore.  

### 4.2 Gerar Cardápio
- **Ator**: Usuário logado.  
- **Pré-condição**: Perfil familiar configurado.  
- **Fluxo**: Selecionar tipos de refeição → Gerar via IA (usando perfil salvo) → Navegar automaticamente para edição → Editar → Salvar.  
- **Pós-condição**: Cardápio armazenado no Firebase Firestore.  

### 4.3 Gerar Lista de Compras
- **Ator**: Usuário logado.  
- **Pré-condição**: Cardápio aprovado.  
- **Fluxo**: Selecionar cardápio → Definir semanas → Criar lista → Ir para edição → Editar/Compartilhar.  
- **Pós-condição**: Lista armazenada no Firebase Firestore.  

---

## 5. Especificação de Telas

### 5.1 Tela de Login
- Campos: E-mail, senha.  
- Ações: Entrar, Criar conta, Recuperar senha, Login via Google/Apple.  

### 5.2 Tela Principal (com abas)
- Estrutura de navegação simplificada.  
- Abas:  
  - **Gerenciar Cardápios** (5.2.1)  
  - **Gerenciar Listas de Compras** (5.2.2)  
  - **Configurações** (5.2.3)  

#### 5.2.1 Aba: Gerenciar Cardápios
- Lista de cardápios criados (com data).  
- Botão para criar novo cardápio → abre **Tela 5.4**.  
- Ao selecionar um cardápio: abrir **Tela 5.5** (Editar cardápio).  
- Ações: Editar, Excluir.  

#### 5.2.2 Aba: Gerenciar Listas de Compras
- Lista de listas criadas (com nome, data e cardápio associado).  
- Botão para criar nova lista → abre **Tela 5.6**.  
- Ações em cada lista: Editar (Tela 5.7), Duplicar, Excluir.  

### 5.3 Tela Configurar Perfil Familiar
- **Configuração do Perfil Familiar:**
  - Campos: número de adultos, número de crianças.
  - Restrições alimentares (checkboxes: glúten, lactose, açúcar, carne vermelha, frango, peixe, ovos, ferro, sódio).
  - Campo de observações adicionais.
- Botão "Salvar perfil" → salva no Firebase e retorna à tela anterior.
- Indicação visual se o perfil foi salvo com sucesso.

### 5.4 Tela Criar Cardápio
- Checkboxes para tipos de refeição (café da manhã, almoço, lanche, jantar, ceia).  
- Exibição do perfil familiar atual (somente leitura).
- Link para editar perfil familiar (abre **Tela 5.3**).
- Botão "Gerar cardápio" → leva direto à **Tela 5.5** (Editar cardápio) com o cardápio recém-gerado.  

### 5.5 Tela Editar Cardápio
- Exibição de refeições organizadas por dias da semana.  
- Ações: Trocar refeição (IA), Excluir refeição, Salvar cardápio.  

### 5.6 Tela Criar Lista de Compras
- Campos: selecionar cardápio, número de semanas, nome da lista (opcional), observações (opcional).  
- Botão “Gerar lista” → leva direto à **Tela 5.7** (Editar lista).  

### 5.7 Tela Editar Lista de Compras
- Exibição dos itens da lista com checkbox para “comprado”.  
- Ações: Adicionar item, Remover item, Editar nome, Editar observações, Compartilhar lista, Salvar alterações.  

### 5.8 Tela de Configuração
- Opções: 
  - Configurar perfil familiar (abre **Tela 5.3**)
  - Logout
  - Visualizar limites de uso
  - Seleção de tema (Claro, Escuro, Automático)  

---

## 6. Considerações Técnicas
- **Tecnologias**: Flutter, Dart, HTTP, Firebase Firestore, Firebase Auth.  
- **IA**: OpenAI, Gemini ou similar.  
- **Banco de Dados**: Firebase Firestore com estrutura de coleções por usuário:
  - `users/{userId}/profile` - Perfil familiar do usuário
  - `users/{userId}/menus/{menuId}` - Cardápios do usuário
  - `users/{userId}/shopping_lists/{listId}` - Listas de compras do usuário
- **Testes**: Unitários (lógica), integração (API e Firestore), beta com usuários.  
- **Próximos Passos**: Configuração das regras de segurança do Firestore, implementação dos repositórios e testes de sincronização.
