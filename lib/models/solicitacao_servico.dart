class SolicitacaoServico {
  final String id;
  final String categoryId;
  final String description;
  final DateTime scheduledDate;
  final double minValue;
  final double maxValue;
  final String addressId;
  final String userPFId;
  final DateTime createdAt;
  final String status; // 'pendente', 'aceito', 'em_andamento', 'concluido', 'cancelado'

  SolicitacaoServico({
    required this.id,
    required this.categoryId,
    required this.description,
    required this.scheduledDate,
    required this.minValue,
    required this.maxValue,
    required this.addressId,
    required this.userPFId,
    required this.createdAt,
    this.status = 'pendente',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'description': description,
      'scheduledDate': scheduledDate.toIso8601String(),
      'minValue': minValue,
      'maxValue': maxValue,
      'addressId': addressId,
      'userPFId': userPFId,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  factory SolicitacaoServico.fromJson(Map<String, dynamic> json) {
    return SolicitacaoServico(
      id: json['id'],
      categoryId: json['categoryId'],
      description: json['description'],
      scheduledDate: DateTime.parse(json['scheduledDate']),
      minValue: json['minValue']?.toDouble() ?? 0.0,
      maxValue: json['maxValue']?.toDouble() ?? 0.0,
      addressId: json['addressId'],
      userPFId: json['userPFId'],
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'] ?? 'pendente',
    );
  }

  SolicitacaoServico copyWith({
    String? id,
    String? categoryId,
    String? description,
    DateTime? scheduledDate,
    double? minValue,
    double? maxValue,
    String? addressId,
    String? userPFId,
    DateTime? createdAt,
    String? status,
  }) {
    return SolicitacaoServico(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      addressId: addressId ?? this.addressId,
      userPFId: userPFId ?? this.userPFId,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
} 