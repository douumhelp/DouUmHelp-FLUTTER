class Endereco {
  final String? id;
  final String cep;
  final String addressLine;
  final String addressNumber;
  final String? neighborhood;
  final String? label;
  final String city;
  final String state;
  final double latitude;
  final double longitude;
  final String? userId;

  Endereco({
    this.id,
    required this.cep,
    required this.addressLine,
    required this.addressNumber,
    this.neighborhood,
    this.label,
    required this.city,
    required this.state,
    this.latitude = 1.0,
    this.longitude = 1.0,
    this.userId,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      id: json['id']?.toString(),
      cep: json['cep']?.toString() ?? '',
      addressLine: json['addressLine']?.toString() ?? '',
      addressNumber: json['addressNumber']?.toString() ?? '',
      neighborhood: json['neighborhood']?.toString(),
      label: json['label']?.toString(),
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      latitude: (json['latitude'] ?? 1.0).toDouble(),
      longitude: (json['longitude'] ?? 1.0).toDouble(),
      userId: json['userId'] is String ? json['userId'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'cep': cep,
      'addressLine': addressLine,
      'addressNumber': addressNumber,
      'city': city,
      'state': state,
      'latitude': latitude,
      'longitude': longitude,
      'userId': userId,
    };

    if (neighborhood != null && neighborhood!.isNotEmpty) {
      data['neighborhood'] = neighborhood;
    }

    if (label != null && label!.isNotEmpty) {
      data['label'] = label;
    }

    if (id != null) {
      data['id'] = id;
    }

    return data;
  }

  @override
  String toString() {
    return 'Endereco(id: $id, cep: $cep, addressLine: $addressLine, addressNumber: $addressNumber, neighborhood: $neighborhood, label: $label, city: $city, state: $state, latitude: $latitude, longitude: $longitude, userId: $userId)';
  }
} 