# DouUmHelp Flutter

<div align="center">
  <img src="assets/logo.png" alt="DouUmHelp Logo" width="200"/>
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
  [![Platform](https://img.shields.io/badge/Platform-Android-green.svg)](https://developer.android.com/)
  [![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
</div>

## 📱 Sobre o Projeto

O **DouUmHelp** é uma plataforma inovadora que conecta pessoas que precisam de ajuda com tarefas do dia a dia com profissionais qualificados que podem oferecer esses serviços. O aplicativo é desenvolvido exclusivamente para Android, proporcionando uma experiência móvel otimizada e intuitiva.

### 🎯 Objetivo
Facilitar a conexão entre usuários que necessitam de serviços domésticos, técnicos, de limpeza, entre outros, com profissionais confiáveis e qualificados, promovendo uma comunidade de ajuda mútua.

### 🌟 Principais Benefícios
- **Conectividade**: Liga quem precisa de ajuda com quem pode ajudar
- **Conveniência**: Interface intuitiva e fácil de usar
- **Confiabilidade**: Sistema de avaliação e verificação de profissionais
- **Flexibilidade**: Diversas categorias de serviços disponíveis
- **Segurança**: Autenticação segura e proteção de dados

## 🚀 Funcionalidades

### 🔐 Autenticação e Conta
- **Registro de Usuário**: Cadastro completo com validação de dados
- **Login Seguro**: Autenticação com email e senha
- **Recuperação de Senha**: Sistema de recuperação de credenciais
- **Perfil do Usuário**: Gerenciamento de informações pessoais
- **Logout**: Encerramento seguro de sessão

### 📍 Gerenciamento de Endereços
- **Cadastro de Endereços**: Múltiplos endereços por usuário
- **Validação de CEP**: Integração com API de CEP para automação
- **Listagem de Endereços**: Visualização organizada dos endereços cadastrados
- **Edição e Exclusão**: Gerenciamento completo dos endereços

### 🛠️ Categorias de Serviços
- **Navegação por Categorias**: Interface intuitiva para explorar serviços
- **Categorias Principais**:
  - Limpeza Doméstica
  - Manutenção Elétrica
  - Hidráulica
  - Informática
  - Jardinagem
  - E muito mais...

### 📋 Solicitações de Serviço
- **Criação de Solicitações**: Formulário completo para solicitar serviços
- **Detalhamento**: Descrição detalhada da necessidade
- **Orçamento**: Definição de valores mínimo e máximo
- **Acompanhamento**: Status das solicitações em tempo real
- **Histórico**: Visualização de solicitações anteriores

### 📄 Termos e Condições
- **Aceitação de Termos**: Processo obrigatório no registro
- **Política de Privacidade**: Informações sobre uso de dados
- **Termos de Uso**: Regras e condições da plataforma

## 🛠️ Tecnologias Utilizadas

### Frontend
- **Flutter 3.0+**: Framework de desenvolvimento multiplataforma
- **Dart 3.0+**: Linguagem de programação moderna e eficiente
- **Material Design**: Interface de usuário consistente e moderna

### Backend e APIs
- **HTTP**: Comunicação com APIs RESTful
- **JSON**: Formato de dados para comunicação
- **JWT**: Autenticação baseada em tokens

### Armazenamento Local
- **Shared Preferences**: Armazenamento de dados locais
- **Cache**: Otimização de performance

### Bibliotecas Principais
- **Provider**: Gerenciamento de estado
- **Google Fonts**: Tipografia personalizada
- **HTTP**: Cliente HTTP para APIs
- **JWT Decoder**: Decodificação de tokens JWT

## 📋 Pré-requisitos

### Sistema Operacional
- **Windows 10/11** (recomendado)
- **macOS** (alternativa)
- **Linux** (alternativa)

### Ferramentas de Desenvolvimento
- **Flutter SDK** (versão 3.0 ou superior)
- **Dart SDK** (incluído com Flutter)
- **Android Studio** (recomendado) ou **VS Code**
- **Git** (controle de versão)

### Android Development
- **Android SDK** (versão 33 ou superior)
- **Android SDK Build-Tools**
- **Android SDK Platform-Tools**
- **Android Emulator** ou dispositivo físico

### Configurações do Sistema
- **RAM**: Mínimo 8GB (recomendado 16GB)
- **Espaço em Disco**: Mínimo 10GB livres
- **Processador**: Intel i5 ou equivalente

## ⚙️ Instalação e Configuração

### 1. Clone do Repositório
```bash
# Clone o repositório
git clone https://github.com/seu-usuario/DouUmHelp-FLUTTER.git

# Navegue para o diretório do projeto
cd DouUmHelp-FLUTTER
```

### 2. Verificação do Flutter
```bash
# Verifique se o Flutter está instalado corretamente
flutter doctor

# Resolva qualquer problema indicado pelo flutter doctor
flutter doctor --android-licenses
```

### 3. Instalação de Dependências
```bash
# Instale todas as dependências do projeto
flutter pub get

# Verifique se não há conflitos
flutter pub deps
```

### 4. Configuração do Android
```bash
# Verifique se o Android está configurado
flutter doctor --android-licenses

# Configure o emulador ou conecte um dispositivo
flutter devices
```

### 5. Execução do Projeto
```bash
# Execute o aplicativo em modo debug
flutter run --debug

# Ou execute em modo release
flutter run --release
```

## 📁 Estrutura do Projeto

```
DouUmHelp-FLUTTER/
├── 📁 android/                    # Configurações específicas do Android
│   ├── app/
│   │   ├── build.gradle.kts      # Configurações de build do app
│   │   └── src/
│   │       └── main/
│   │           ├── AndroidManifest.xml
│   │           └── kotlin/
│   └── build.gradle.kts          # Configurações gerais do Android
├── 📁 assets/                     # Recursos estáticos
│   ├── logo.png                  # Logo da aplicação
│   └── Termos/
│       └── termo_de_uso.txt      # Termos de uso
├── 📁 lib/                        # Código fonte principal
│   ├── 📁 models/                # Modelos de dados
│   │   ├── categoria.dart        # Modelo de categoria
│   │   ├── endereco.dart         # Modelo de endereço
│   │   └── solicitacao_servico.dart # Modelo de solicitação
│   ├── 📁 Services/              # Serviços e APIs
│   │   ├── auth_service.dart     # Serviço de autenticação
│   │   ├── category_service.dart # Serviço de categorias
│   │   ├── address_service.dart  # Serviço de endereços
│   │   ├── cep_service.dart      # Serviço de CEP
│   │   ├── solicitacao_service.dart # Serviço de solicitações
│   │   └── validation_service.dart # Serviço de validação
│   ├── 📁 viewmodels/            # ViewModels (Gerenciamento de Estado)
│   │   ├── auth_viewmodel.dart   # ViewModel de autenticação
│   │   ├── category_viewmodel.dart # ViewModel de categorias
│   │   ├── address_viewmodel.dart # ViewModel de endereços
│   │   ├── home_viewmodel.dart   # ViewModel da home
│   │   └── base_viewmodel.dart   # ViewModel base
│   ├── 📁 views/                 # Telas da aplicação
│   │   ├── 📁 Auth/              # Telas de autenticação
│   │   ├── 📁 Pages/             # Páginas principais
│   │   ├── login_screen.dart     # Tela de login
│   │   ├── register_screen.dart  # Tela de registro
│   │   ├── success_screen.dart   # Tela de sucesso
│   │   ├── home_screen.dart      # Tela principal
│   │   ├── address_screen.dart   # Tela de endereços
│   │   └── solicitacao_servico_screen.dart # Tela de solicitações
│   ├── 📁 utils/                 # Utilitários
│   │   ├── config.dart           # Configurações da aplicação
│   │   └── format_utils.dart     # Utilitários de formatação
│   └── main.dart                 # Ponto de entrada da aplicação
├── 📁 test/                      # Testes automatizados
│   ├── 📁 models/                # Testes dos modelos
│   ├── 📁 services/              # Testes dos serviços
│   └── 📁 utils/                 # Testes dos utilitários
├── 📁 coverage/                  # Relatórios de cobertura de testes
├── pubspec.yaml                  # Dependências do projeto
├── pubspec.lock                  # Versões fixas das dependências
├── analysis_options.yaml         # Configurações do linter
└── README.md                     # Este arquivo
```

## 🧪 Testes

### Execução de Testes
```bash
# Executar todos os testes
flutter test

# Executar testes com cobertura
flutter test --coverage

# Executar testes de uma pasta específica
flutter test test/models/
flutter test test/services/
flutter test test/utils/
```

### Relatórios de Cobertura
```bash
# Gerar relatório de cobertura no terminal
dart coverage_report.dart

# Gerar relatório HTML (requer lcov)
genhtml coverage/lcov.info -o coverage/html
```

### Tipos de Testes
- **Testes Unitários**: Testes de funções e métodos individuais
- **Testes de Widget**: Testes de componentes da interface
- **Testes de Integração**: Testes de fluxos completos
- **Testes de Serviços**: Testes de comunicação com APIs

## 🏗️ Arquitetura

### Padrão MVVM (Model-View-ViewModel)
O projeto segue o padrão MVVM para separação de responsabilidades:

- **Model**: Representa os dados e a lógica de negócio
- **View**: Interface do usuário (telas)
- **ViewModel**: Gerencia o estado e a comunicação entre Model e View

### Gerenciamento de Estado
- **Provider**: Biblioteca utilizada para gerenciamento de estado
- **ChangeNotifier**: Para notificação de mudanças de estado
- **Consumer**: Para escutar mudanças de estado nas views

### Estrutura de Serviços
- **AuthService**: Gerencia autenticação e autorização
- **CategoryService**: Gerencia categorias de serviços
- **AddressService**: Gerencia endereços dos usuários
- **CepService**: Integração com API de CEP
- **SolicitacaoService**: Gerencia solicitações de serviço

## 🔧 Configuração de Desenvolvimento

### Variáveis de Ambiente
```dart
// lib/utils/config.dart
class ApiConfig {
  static const String baseUrl = '';
  static const String loginEndpoint = '$baseUrl/auth/login';
  static const String registerEndpoint = '$baseUrl/auth/register';
  // ... outras configurações
}
```

### Configurações do Android
```kotlin
// android/app/build.gradle.kts
android {
    compileSdk = 34
    defaultConfig {
        minSdk = 21
        targetSdk = 34
        // ... outras configurações
    }
}
```

## 📱 Plataforma Suportada

### Android
- **Versão Mínima**: API Level 21 (Android 5.0)
- **Versão Alvo**: API Level 34 (Android 14)
- **Arquiteturas**: ARM64, ARMv7, x86_64

### Não Suportado
- **iOS**: Não há suporte para dispositivos Apple
- **Web**: Não há suporte para navegadores web
- **Desktop**: Não há suporte para Windows/macOS/Linux desktop

## 🚀 Build e Deploy

### Build de Desenvolvimento
```bash
# Build debug para desenvolvimento
flutter build apk --debug

# Build debug para Android
flutter build apk --debug --target-platform android-arm64
```

### Build de Produção
```bash
# Build release para produção
flutter build apk --release

# Build release otimizado
flutter build apk --release --split-per-abi
```

### Assinatura do APK
```bash
# Gerar keystore para assinatura
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Configurar assinatura no build.gradle
```

### Problemas Comuns

#### Erro de Dependências
```bash
# Limpar cache do Flutter
flutter clean

# Reinstalar dependências
flutter pub get
```

#### Erro de Build Android
```bash
# Limpar build do Android
cd android
./gradlew clean
cd ..

# Rebuild
flutter build apk --debug
```

#### Erro de Emulador
```bash
# Verificar emuladores disponíveis
flutter emulators

# Iniciar emulador
flutter emulators --launch <emulator_id>
```

#### Problemas de Performance
- Verifique se está usando `const` widgets quando possível
- Evite rebuilds desnecessários
- Use `ListView.builder` para listas grandes
- Implemente lazy loading quando necessário

## 📊 Métricas e Qualidade

### Cobertura de Código
- **Meta**: Mínimo 80% de cobertura
- **Atual**: Verificar com `flutter test --coverage`

### Análise Estática
```bash
# Executar análise estática
flutter analyze

# Corrigir problemas automaticamente
dart fix --apply
```

### Performance
- **Tamanho do APK**: Otimizado para distribuição
- **Tempo de Inicialização**: Menos de 3 segundos
- **Uso de Memória**: Otimizado para dispositivos de baixo recurso


Copyright (c) 2024 DouUmHelp

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

