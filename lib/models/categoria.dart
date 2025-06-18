class Categoria {
  final String id;
  final String categoria;
  final String icon;
  final List<String> subcategorias;
  bool isExpanded;

  Categoria({
    required this.id,
    required this.categoria,
    required this.icon,
    required this.subcategorias,
    this.isExpanded = false,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] ?? '',
      categoria: json['categoria'] ?? '',
      icon: json['icon'] ?? 'category',
      subcategorias: List<String>.from(json['subcategorias'] ?? []),
    );
  }

  static List<Categoria> getCategorias() {
    return [
      Categoria(
        id: '1',
        categoria: 'Serviços Domésticos',
        icon: 'home',
        subcategorias: [
          'Encanador', 'Eletricista', 'Pintor', 'Pedreiro', 'Limpeza Residencial',
          'Jardinagem', 'Instalador de Eletrônicos', 'Reparos Elétricos',
          'Carpinteiro', 'Manutenção de Piscina', 'Manutenção de Ar Condicionado',
          'Soldador', 'Conserto de Eletrodomésticos'
        ],
      ),
      Categoria(
        id: '2',
        categoria: 'Serviços de Software',
        icon: 'code',
        subcategorias: [
          'Programação Front End', 'Programador Backend', 'Gestão de Projeto',
          'Suporte em TI', 'Tester de Software', 'Analista de Software',
          'Consultor de Software'
        ],
      ),
      Categoria(
        id: '3',
        categoria: 'Serviço Online',
        icon: 'language',
        subcategorias: [
          'Editor de Video', 'Editor de Imagem', 'Redator', 'Media Design',
          'ÁudioVisual', 'Audio'
        ],
      ),
      Categoria(
        id: '4',
        categoria: 'Serviço Veicular',
        icon: 'directions_car',
        subcategorias: [
          'Mecanico De Carro', 'Manobrista', 'Lavagem de Carros', 'Mecanico de Moto'
        ],
      ),
      Categoria(
        id: '5',
        categoria: 'Serviço Pet',
        icon: 'pets',
        subcategorias: [
          'Cuidador de Pet', 'Hospedagem de Pet', 'Vacinação de Pet',
          'Passeio com Cães', 'Tosador'
        ],
      ),
      Categoria(
        id: '6',
        categoria: 'Serviço Humano',
        icon: 'person',
        subcategorias: [
          'Cuidador de Idosos', 'Cuidador de criança', 'Professor Particular',
          'Massoterapia', 'Fisioterapia', 'Personal Organizer',
          'Cuidador de pessoa com Deficiencia', 'Personal Training',
          'Acompanhante', 'Manicure'
        ],
      ),
      Categoria(
        id: '7',
        categoria: 'Serviços Comercial',
        icon: 'store',
        subcategorias: [
          'Vendedor', 'Diarista Comercial', 'Segurança', 'Garçom', 'Tradutor',
          'Fotografia e Filmagem', 'Contador', 'Produtor de Festa',
          'Serviço de Buffet', 'Produtor Musical(DJ)'
        ],
      ),
      Categoria(
        id: '8',
        categoria: 'Fretes',
        icon: 'local_shipping',
        subcategorias: [
          'Transporte de Cargas', 'Carona', 'Abastecedor'
        ],
      ),
    ];
  }
} 