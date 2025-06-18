# DouUmHelp Flutter

Um aplicativo Flutter para conectar pessoas que precisam de ajuda com aquelas que podem oferecer serviços.

## 📱 Sobre o Projeto

O DouUmHelp é uma plataforma que facilita a conexão entre pessoas que precisam de ajuda com tarefas do dia a dia e aquelas que podem oferecer esses serviços. O aplicativo é desenvolvido exclusivamente para Android.

## 🚀 Funcionalidades

- **Autenticação**: Login e registro de usuários
- **Categorias de Serviços**: Navegação por diferentes tipos de serviços disponíveis
- **Gerenciamento de Endereços**: Cadastro e listagem de endereços do usuário
- **Solicitações de Serviço**: Criação e acompanhamento de solicitações
- **Termos de Uso**: Aceitação de termos e condições

## 🛠️ Tecnologias Utilizadas

- **Flutter**: Framework de desenvolvimento
- **Dart**: Linguagem de programação
- **HTTP**: Para comunicação com APIs
- **Shared Preferences**: Para armazenamento local
- **Provider**: Para gerenciamento de estado

## 📋 Pré-requisitos

- Flutter SDK (versão 3.0 ou superior)
- Android Studio ou VS Code
- Android SDK
- Dispositivo Android ou emulador

## ⚙️ Instalação e Configuração

1. **Clone o repositório**
   ```bash
   git clone [URL_DO_REPOSITORIO]
   cd DouUmHelp-FLUTTER
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Execute o aplicativo**
   ```bash
   flutter run
   ```

## 📁 Estrutura do Projeto

```
lib/
├── main.dart                 # Ponto de entrada da aplicação
├── models/                   # Modelos de dados
│   ├── categoria.dart
│   ├── endereco.dart
│   └── solicitacao_servico.dart
├── services/                 # Serviços e APIs
│   ├── auth_service.dart
│   ├── category_service.dart
│   ├── address_service.dart
│   ├── cep_service.dart
│   ├── solicitacao_service.dart
│   └── validation_service.dart
├── viewmodels/              # ViewModels para gerenciamento de estado
│   ├── auth_viewmodel.dart
│   ├── category_viewmodel.dart
│   ├── address_viewmodel.dart
│   ├── home_viewmodel.dart
│   └── base_viewmodel.dart
├── views/                   # Telas da aplicação
│   ├── Auth/
│   ├── Pages/
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── address_screen.dart
│   └── solicitacao_servico_screen.dart
└── utils/                   # Utilitários
    ├── config.dart
    └── format_utils.dart
```

## 🧪 Testes

### Executar todos os testes
```bash
flutter test --coverage
```

### Executar testes de uma pasta específica
```bash
flutter test test/models/
flutter test test/services/
```

### Gerar relatório de cobertura
```bash
dart coverage_report.dart
```

### Requisitos para rodar os testes
- Flutter instalado
- Dependências do projeto instaladas:
  ```bash
  flutter pub get
  ```

## 📱 Plataforma Suportada

Este aplicativo é desenvolvido exclusivamente para **Android**. Não há suporte para iOS, web ou desktop.

## 🤝 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 📞 Contato

Para dúvidas ou sugestões, entre em contato através dos canais disponíveis no projeto.

---

**Desenvolvido com ❤️ para a comunidade Android**
