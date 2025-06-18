# dou_um_help_flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 🧪 Testes e Cobertura

### Executar todos os testes
```sh
flutter test --coverage
```

### Executar testes de uma pasta específica
```sh
flutter test test/models/
flutter test test/services/
```

### Gerar relatório de cobertura (simples, via terminal)
Após rodar os testes com cobertura, execute:
```sh
dart coverage_report.dart
```

O script irá mostrar a cobertura de cada arquivo e o total no terminal.

### (Opcional) Gerar relatório HTML de cobertura
Se você tiver o lcov instalado (Linux/macOS):
```sh
genhtml coverage/lcov.info -o coverage/html
```
Abra o arquivo `coverage/html/index.html` no navegador para visualizar.

### Requisitos para rodar os testes
- Flutter instalado
- Dependências do projeto instaladas:
```sh
flutter pub get
```
- Para rodar o script de cobertura:
```sh
dart coverage_report.dart
```

---

**Resumo dos comandos principais:**

| Ação                        | Comando                                    |
|-----------------------------|--------------------------------------------|
| Rodar todos os testes       | `flutter test --coverage`                  |
| Rodar testes de uma pasta   | `flutter test test/models/`                |
| Ver relatório de cobertura  | `dart coverage_report.dart`                |
| (Opcional) Relatório HTML   | `genhtml coverage/lcov.info -o coverage/html` |
