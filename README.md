# NutriPlan 🍽️

Um aplicativo Flutter para planejamento de refeições familiares e geração automática de listas de compras.

## 📱 Sobre o Projeto

O NutriPlan é uma solução completa para famílias que desejam organizar suas refeições de forma inteligente e prática. O aplicativo permite criar cardápios personalizados, gerar listas de compras automaticamente e gerenciar o perfil familiar com restrições alimentares.

## ✨ Funcionalidades Principais

### 🍽️ Gestão de Cardápios
- Criação e edição de cardápios semanais
- Organização por refeições (café da manhã, almoço, jantar, lanches)
- Sugestões baseadas no perfil familiar
- Histórico de cardápios anteriores

### 🛒 Listas de Compras Inteligentes
- Geração automática baseada nos cardápios
- Organização por categorias de produtos
- Marcação de itens comprados
- Estimativa de custos

### 👨‍👩‍👧‍👦 Perfil Familiar
- Configuração do número de adultos e crianças
- Gestão de restrições alimentares:
  - Vegetariano
  - Vegano
  - Sem glúten
  - Sem lactose
  - Sem açúcar
  - Diabético
  - Hipertenso
  - E outras restrições personalizadas

## 🏗️ Arquitetura

O projeto segue os princípios da **Clean Architecture** com as seguintes camadas:

```
lib/
├── src/
│   ├── data/           # Camada de dados (repositories, datasources)
│   ├── domain/         # Camada de domínio (entities, usecases)
│   └── presentation/   # Camada de apresentação (pages, widgets, viewmodels)
│       └── features/
│           ├── auth/   # Autenticação
│           └── home/   # Tela principal
│               ├── cardapios/  # Gestão de cardápios
│               ├── listas/     # Listas de compras
│               └── perfil/     # Perfil familiar
├── app.dart           # Configuração do app
├── di.dart            # Injeção de dependências
└── main.dart          # Ponto de entrada
```

## 🚀 Tecnologias Utilizadas

- **Flutter** - Framework de desenvolvimento
- **Riverpod** - Gerenciamento de estado
- **Firebase Auth** - Autenticação
- **Firebase Firestore** - Banco de dados
- **Google Sign-In** - Login social
- **Shared Preferences** - Armazenamento local

## 📋 Pré-requisitos

- Flutter SDK (versão 3.0 ou superior)
- Dart SDK
- Android Studio / VS Code
- Conta no Firebase

## 🛠️ Instalação e Configuração

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/iallengabio/nutriplan.git
   cd nutriplan
   ```

2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

3. **Configure o Firebase:**
   - Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
   - Adicione os arquivos de configuração:
     - `android/app/google-services.json` (Android)
     - `ios/Runner/GoogleService-Info.plist` (iOS)
   - Configure Authentication e Firestore

4. **Execute o projeto:**
   ```bash
   flutter run
   ```

## 🧪 Testes

```bash
# Executar todos os testes
flutter test

# Executar testes com coverage
flutter test --coverage
```

## 📱 Plataformas Suportadas

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🤝 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 👨‍💻 Autor

**Iallen Gabio**
- GitHub: [@iallengabio](https://github.com/iallengabio)

## 📞 Suporte

Se você encontrar algum problema ou tiver sugestões, por favor:
- Abra uma [issue](https://github.com/iallengabio/nutriplan/issues)
- Entre em contato através do GitHub

---

⭐ Se este projeto te ajudou, considere dar uma estrela no repositório!
