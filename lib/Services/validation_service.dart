import '../utils/format_utils.dart';

class ValidationService {
  // Validação de preços
  static bool isValidPriceRange(double minValue, double maxValue) {
    return minValue > 0 && maxValue > minValue;
  }

  static bool isValidPrice(double value) {
    return value > 0;
  }

  // Validação de valores monetários
  static bool isValidCurrencyValue(String value) {
    final numericValue = FormatUtils.extractNumericValue(value);
    return numericValue > 0;
  }

  // Validação de formulário de solicitação
  static String? validateSolicitacaoForm({
    required String? categoryId,
    required String? addressId,
    required String description,
    required bool hasValueRange,
    required double minValue,
    required double maxValue,
  }) {
    if (categoryId == null || categoryId.isEmpty) {
      return 'Selecione uma categoria';
    }

    if (addressId == null || addressId.isEmpty) {
      return 'Selecione um endereço';
    }

    if (description.trim().isEmpty) {
      return 'Descreva o serviço';
    }

    if (hasValueRange) {
      if (!isValidPriceRange(minValue, maxValue)) {
        return 'O valor mínimo deve ser menor que o valor máximo';
      }

      if (!isValidPrice(minValue) || !isValidPrice(maxValue)) {
        return 'Os valores não podem ser zero';
      }
    }

    return null;
  }

  // Validação de formulário de endereço
  static String? validateAddressForm({
    required String cep,
    required String addressLine,
    required String addressNumber,
    required String city,
    required String state,
  }) {
    if (cep.trim().isEmpty) {
      return 'CEP é obrigatório';
    }

    if (!FormatUtils.isValidCep(cep)) {
      return 'CEP inválido';
    }

    if (addressLine.trim().isEmpty) {
      return 'Endereço é obrigatório';
    }

    if (addressNumber.trim().isEmpty) {
      return 'Número é obrigatório';
    }

    if (city.trim().isEmpty) {
      return 'Cidade é obrigatória';
    }

    if (state.trim().isEmpty) {
      return 'Estado é obrigatório';
    }

    return null;
  }

  // Validação de formulário de registro
  static String? validateRegisterForm({
    required String name,
    required String cpf,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    if (name.trim().isEmpty) {
      return 'Nome é obrigatório';
    }

    if (name.trim().split(' ').length < 2) {
      return 'Digite nome completo';
    }

    if (cpf.trim().isEmpty) {
      return 'CPF é obrigatório';
    }

    if (!FormatUtils.isValidCpf(cpf)) {
      return 'CPF inválido';
    }

    if (email.trim().isEmpty) {
      return 'Email é obrigatório';
    }

    if (!FormatUtils.isValidEmail(email)) {
      return 'Email inválido';
    }

    if (password.isEmpty) {
      return 'Senha é obrigatória';
    }

    if (password.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }

    if (password != confirmPassword) {
      return 'Senhas não coincidem';
    }

    return null;
  }

  // Validação de formulário de login
  static String? validateLoginForm({
    required String email,
    required String password,
  }) {
    if (email.trim().isEmpty) {
      return 'Email é obrigatório';
    }

    if (!FormatUtils.isValidEmail(email)) {
      return 'Email inválido';
    }

    if (password.isEmpty) {
      return 'Senha é obrigatória';
    }

    return null;
  }

  // Validação de data e hora
  static bool isValidScheduledDateTime(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.isAfter(now);
  }

  static String? validateScheduledDateTime(DateTime dateTime) {
    if (!isValidScheduledDateTime(dateTime)) {
      return 'Data e hora devem ser futuras';
    }
    return null;
  }

  // Validação de descrição
  static String? validateDescription(String description) {
    if (description.trim().isEmpty) {
      return 'Descrição é obrigatória';
    }

    if (description.trim().length < 10) {
      return 'Descrição deve ter pelo menos 10 caracteres';
    }

    if (description.trim().length > 500) {
      return 'Descrição deve ter no máximo 500 caracteres';
    }

    return null;
  }

  // Validação de telefone (opcional)
  static String? validatePhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return null; // Telefone é opcional
    }

    if (!FormatUtils.isValidPhone(phone)) {
      return 'Telefone inválido';
    }

    return null;
  }

  // Validação de nome de endereço (label)
  static String? validateAddressLabel(String? label) {
    if (label == null || label.trim().isEmpty) {
      return null; // Label é opcional
    }

    if (label.trim().length < 2) {
      return 'Nome do endereço deve ter pelo menos 2 caracteres';
    }

    if (label.trim().length > 50) {
      return 'Nome do endereço deve ter no máximo 50 caracteres';
    }

    return null;
  }
} 