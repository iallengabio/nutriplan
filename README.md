# NutriPlan 🍽️

Um aplicativo Flutter para planejamento de refeições familiares e geração automática de listas de compras com IA.

## 📱 Sobre o Projeto

O NutriPlan é uma solução completa para famílias que desejam organizar suas refeições de forma inteligente e prática. O aplicativo utiliza inteligência artificial (Google Gemini) para gerar cardápios personalizados baseados no perfil familiar, criar listas de compras automaticamente e permitir compartilhamento entre usuários.

## 📋 Documentação Adicional

- [🔧 Configuração da API Gemini](GEMINI_SETUP.md) - Como configurar a integração com IA
- [🐛 Template de Issues](ISSUE_TEMPLATE.md) - Exemplo de documentação de problemas

## ✨ Funcionalidades Principais

### 👨‍👩‍👧‍👦 Perfil Familiar ✅
- ✅ Configuração persistente do perfil familiar (adultos, crianças, restrições alimentares)
- ✅ Perfil padrão automático para novos usuários
- ✅ Edição do perfil a qualquer momento
- ✅ Sincronização automática com Firebase Firestore
- ✅ Uso automático do perfil em todas as gerações de cardápio

### 🍽️ Gestão de Cardápios ✅
- ✅ Criação automática de cardápios semanais com IA (Google Gemini)
- ✅ Geração baseada no perfil familiar salvo (sem reconfiguração a cada cardápio)
- ✅ Organização por refeições (café da manhã, almoço, jantar, lanches)
- ✅ Edição manual de refeições (trocar/excluir refeições específicas)
- ✅ Persistência no Firebase Firestore
- ✅ Rate limiting (máximo 5 gerações por dia)

### 🛒 Listas de Compras Inteligentes ✅
- ✅ Geração automática baseada nos cardápios selecionados
- ✅ Configuração de número de semanas
- ✅ Edição manual (adicionar/remover itens)
- ✅ Marcação de itens como comprados
- ✅ Compartilhamento via export/import de arquivos `.nutriplan`
- ✅ Múltiplas listas salvas

### 🔐 Autenticação ✅
- ✅ Login obrigatório para funcionalidades de IA
- ✅ Suporte a email/senha e Google Sign-In
- ✅ Recuperação de senha por email
- ✅ Monitoramento de limites de uso da API

### ⚙️ Configurações ✅
- ✅ Configuração do perfil familiar
- ✅ Seleção de tema (claro, escuro, automático)
- ✅ Visualização de limites de uso da IA
- ✅ Logout

### 🤖 Integração com IA ✅
- ✅ Google Gemini para geração de cardápios
- ✅ Prompts otimizados e centralizados
- ✅ Tratamento de erros com retry automático
- ✅ Fallback para serviço mock
- ✅ Timeout de 10 segundos por chamada

## 🏗️ Arquitetura e Padrões

O projeto segue os princípios da **Clean Architecture** com **MVVM (Model-View-ViewModel)** e os seguintes padrões:

### 📐 Padrões Utilizados
- **MVVM** - Separação clara entre View, ViewModel e Model
- **Repository Pattern** - Abstração de acesso a dados
- **Result Pattern** - Tratamento consistente de erros
- **Dependency Injection** - Riverpod para injeção de dependências
- **Princípios SOLID** - Código limpo e manutenível

### 📁 Estrutura de Pastas
```
lib/
├── main.dart                    # Ponto de entrada
├── src/
│   ├── app.dart                # Widget principal do aplicativo
│   ├── di.dart                 # Configuração de injeção de dependências
│   ├── core/
│   │   ├── constants/          # Constantes (API keys, prompts, etc.)
│   │   ├── errors/             # Classes de erro e exceções
│   │   ├── extensions/         # Extensões de tipos
│   │   ├── services/           # Serviços core (rate limiting, file sharing)
│   │   ├── theme/              # Configuração de tema
│   │   └── utils/              # Utilitários gerais
│   ├── data/
│   │   ├── datasources/
│   │   │   ├── local/          # Cache local, SharedPreferences
│   │   │   └── remote/         # APIs externas (Gemini, Firebase)
│   │   ├── repositories/       # Implementações concretas
│   │   └── services/           # Serviços de dados (Gemini AI, etc.)
│   ├── domain/
│   │   ├── models/             # Entidades (freezed + json_serializable)
│   │   ├── repositories/       # Interfaces dos repositórios
│   │   └── services/           # Interfaces de serviços
│   └── presentation/
│       ├── common/
│       │   ├── widgets/        # Widgets reutilizáveis
│       │   └── components/     # Componentes de UI maiores
│       └── features/
│           ├── auth/           # Autenticação (login, registro)
│           ├── profile/        # Perfil familiar (configurar, editar)
│           ├── menus/          # Cardápios (criar, editar, listar)
│           ├── shopping/       # Listas de compras
│           └── settings/       # Configurações do app
```

## 🚀 Tecnologias Utilizadas

### 🎯 Core
- **Flutter** - Framework de desenvolvimento multiplataforma
- **Dart** - Linguagem de programação

### 🔄 Estado e Arquitetura
- **Riverpod** - Gerenciamento de estado e injeção de dependências
- **Result Dart** - Tratamento de erros com Result Pattern
- **Freezed** - Modelos de dados imutáveis
- **Json Serializable** - Serialização JSON automática

### 🔥 Backend e Dados
- **Firebase Auth** - Autenticação de usuários
- **Firebase Firestore** - Banco de dados NoSQL
- **Google Sign-In** - Login social
- **Shared Preferences** - Armazenamento local

### 🤖 Inteligência Artificial
- **Google Gemini API** - Geração de cardápios com IA
- **Dio** - Cliente HTTP para APIs

### 🎨 Interface
- **Material Design 3** - Sistema de design
- **Temas dinâmicos** - Suporte a claro/escuro/automático

### 🧪 Testes e Qualidade
- **Flutter Test** - Testes unitários e de widget
- **Mocktail** - Mocks para testes
- **Build Runner** - Geração de código

## 📋 Pré-requisitos

- Flutter SDK (versão 3.0 ou superior)
- Dart SDK
- Android Studio / VS Code
- Conta no Firebase

## 🛠️ Instalação e Configuração

### 1. Clone o repositório
```bash
git clone https://github.com/iallengabio/nutriplan.git
cd nutriplan
```

### 2. Instale as dependências
```bash
flutter pub get
```

### 3. Configure o Firebase
- Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
- Adicione os arquivos de configuração:
  - `android/app/google-services.json` (Android)
  - `ios/Runner/GoogleService-Info.plist` (iOS)
- Configure Authentication (Email/Password e Google)
- Configure Firestore Database

### 4. Configure a API do Gemini
**⚠️ Obrigatório para funcionalidades de IA**

Siga o guia detalhado: [📖 GEMINI_SETUP.md](GEMINI_SETUP.md)

```bash
# Crie um arquivo .env na raiz do projeto
echo "GEMINI_API_KEY=sua_chave_aqui" > .env
```

### 5. Execute o projeto
```bash
flutter run
```

### 6. Gere código (se necessário)
```bash
flutter packages pub run build_runner build
```

## 🧪 Testes

```bash
# Executar todos os testes
flutter test

# Executar testes com coverage
flutter test --coverage

# Executar testes específicos
flutter test test/menu_number_of_people_test.dart

# Gerar relatório de coverage
genhtml coverage/lcov.info -o coverage/html
```

### 📊 Cobertura de Testes
- **ViewModels**: 80%+ de cobertura obrigatória
- **Repositories**: 80%+ de cobertura obrigatória
- **Widgets**: Testes para telas principais
- **Mocks**: Uso do Mocktail para dependências

## 📱 Plataformas Suportadas

- ✅ **Android** (5.0+) - Totalmente funcional
- ✅ **iOS** (11.0+) - Totalmente funcional
- ⚠️ **Web** - Limitações no compartilhamento de arquivos
- ⚠️ **Windows** - Não testado extensivamente
- ⚠️ **macOS** - Não testado extensivamente
- ⚠️ **Linux** - Não testado extensivamente

> **Nota**: O foco principal é Android e iOS. Outras plataformas podem ter funcionalidades limitadas.

## 🤝 Contribuição

### 📝 Conventional Commits
Use o padrão de commits:
- `feat:` - Nova funcionalidade
- `fix:` - Correção de bug
- `refactor:` - Refatoração de código
- `test:` - Adição/modificação de testes
- `docs:` - Documentação
- `style:` - Formatação de código

### 🔄 Fluxo de Contribuição
1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Siga as regras do arquivo `.trae/rules/project_rules.md`
4. Commit suas mudanças (`git commit -m 'feat: add some amazing feature'`)
5. Push para a branch (`git push origin feature/AmazingFeature`)
6. Abra um Pull Request

### 🐛 Reportando Issues
Use o template: [🐛 ISSUE_TEMPLATE.md](ISSUE_TEMPLATE.md)

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👨‍💻 Autor

**Iallen Gabio**
- GitHub: [@iallengabio](https://github.com/iallengabio)

## 📞 Suporte

Se você encontrar algum problema ou tiver sugestões, por favor:
- Abra uma [issue](https://github.com/iallengabio/nutriplan/issues)
- Entre em contato através do GitHub

## 🚀 Status do Projeto

### ✅ Funcionalidades Implementadas
- [x] Autenticação completa (email/senha, Google)
- [x] Geração de cardápios com IA
- [x] Edição manual de cardápios
- [x] Geração de listas de compras
- [x] Compartilhamento de listas (.nutriplan)
- [x] Configurações de tema
- [x] Rate limiting da IA
- [x] Persistência no Firestore

### 🔄 Em Desenvolvimento
- [ ] Melhorias na UX/UI
- [ ] Otimizações de performance
- [ ] Testes automatizados

### 📋 Backlog
- [ ] Notificações push
- [ ] Modo offline avançado
- [ ] Análise nutricional
- [ ] Integração com supermercados

---

⭐ Se este projeto te ajudou, considere dar uma estrela no repositório!
