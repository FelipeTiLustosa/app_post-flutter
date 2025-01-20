# FLUTTER POSTS APP <img src="https://skillicons.dev/icons?i=flutter,dart" alt="Flutter & Dart Icons" style="vertical-align: middle; height: 35px;"/>

## 1. Visão Geral

O projeto Flutter Posts App é uma aplicação completa que demonstra a integração entre uma API REST local desenvolvida em Dart e um aplicativo móvel em Flutter. O sistema permite aos usuários compartilhar e interagir com posts contendo imagens e textos, oferecendo uma experiência moderna e fluida desde a tela de splash até o gerenciamento completo de conteúdo.

## 2. Funcionalidades

Abaixo estão listadas as funcionalidades do sistema, organizadas em uma tabela para melhor visualização:

| Funcionalidade | Descrição |
|----------------|-----------|
| **Splash Screen** | Tela inicial animada com transições suaves de fade e scale |
| **Onboarding** | Tutorial inicial interativo com navegação por gestos |
| **Listagem de Posts** | Exibição dos posts em lista com suporte a imagens e textos |
| **Criação de Posts** | Interface intuitiva para adicionar novos posts com mídia |
| **Sistema de Likes** | Funcionalidade para interagir com posts através de curtidas |
| **Upload de Imagens** | Integração com galeria para seleção de imagens |
| **Estados de Loading** | Feedback visual com shimmer effect durante carregamentos |
| **Design Responsivo** | Interface adaptável a diferentes tamanhos de tela |

## 3. Tecnologias Utilizadas

- **API Backend**: [Dart](https://dart.dev/), [Shelf](https://pub.dev/packages/shelf)
- **App Frontend**: [Flutter](https://flutter.dev/), [Device Preview](https://pub.dev/packages/device_preview)
- **Bibliotecas**: Google Fonts, HTTP, Image Picker, Shimmer
- **Gerenciamento de Versão**: [Git](https://git-scm.com/)
- **Desenvolvimento**: [VS Code](https://code.visualstudio.com/), [Android Studio](https://developer.android.com/studio)

## 4. Links para Recursos Adicionais

- **Flutter**: [Documentação Oficial](https://flutter.dev/docs)
- **Dart**: [Dart Dev](https://dart.dev/guides)
- **Shelf Package**: [Pub.dev Shelf](https://pub.dev/packages/shelf)
- **Material Design**: [Material.io](https://material.io)
- **Flutter Packages**: [Pub.dev](https://pub.dev)

## 5. Configuração e Execução

Para configurar e executar o projeto localmente, siga as etapas abaixo:

### 5.1. Pré-requisitos

- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0
- Editor de código (VS Code ou Android Studio)
- Git instalado

### 5.2. Clonar o Repositório

```bash
git clone https://github.com/seu-usuario/flutter-posts-app.git
cd flutter-posts-app
```

### 5.3. Configurar e Executar

Na API (Dart):
```bash
cd dart_api
dart pub get
dart run bin/server.dart
```

No App Flutter:
```bash
cd posts_app
flutter pub get
flutter run
```

## 6. Contribuição

Contribuições são bem-vindas! Se você deseja contribuir para o projeto, siga estas etapas:

1. Faça um fork do repositório
2. Crie uma branch para sua feature
3. Faça suas alterações e teste
4. Envie um pull request para revisão

## 7. Estrutura de Pastas

```bash
projeto/
├── dart_api/
│   ├── bin/
│   │   └── server.dart                # Servidor principal
│   ├── lib/
│   │   └── models/
│   │       └── post.dart             # Modelo de dados
│   └── pubspec.yaml
│
└── posts_app/
    ├── lib/
    │   ├── screens/
    │   │   ├── splash_screen.dart    # Tela inicial
    │   │   ├── posts_screen.dart     # Lista de posts
    │   │   └── add_post_screen.dart  # Criar posts
    │   └── main.dart
    └── pubspec.yaml
```

## 8. Link do vídeo explicativo sobre o projeto

[Link do vídeo demonstrativo](https://youtube.com/seu-video)
