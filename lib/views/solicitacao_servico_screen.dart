import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../models/categoria.dart';
import '../models/endereco.dart';
import '../models/solicitacao_servico.dart';
import '../Services/solicitacao_service.dart';
import '../Services/category_service.dart';
import '../Services/address_service.dart';
import 'address_screen.dart';
import '../viewmodels/address_viewmodel.dart';

class SolicitacaoServicoScreen extends StatefulWidget {
  final String? categoryName;

  const SolicitacaoServicoScreen({Key? key, this.categoryName}) : super(key: key);

  @override
  State<SolicitacaoServicoScreen> createState() => _SolicitacaoServicoScreenState();
}

class _SolicitacaoServicoScreenState extends State<SolicitacaoServicoScreen> {
  final SolicitacaoService _solicitacaoService = SolicitacaoService();
  final CategoryService _categoryService = CategoryService();

  List<Categoria> categories = [];
  List<Endereco> addresses = [];
  
  String? selectedCategoryId;
  String? selectedAddressId;
  String? selectedSubcategory;
  
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _minValueController = TextEditingController();
  final TextEditingController _maxValueController = TextEditingController();
  
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  
  bool isValueChecked = false;
  bool isLoading = false;
  String? successMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddressViewModel>(context, listen: false).loadAddresses();
      _loadData();
    });
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      print('=== CARREGANDO DADOS ===');
      print('Usando rotas /addresses/[id] para buscar endereços');
      
      // Carregar categorias
      final categorias = await _categoryService.getCategories();
      print('Categorias carregadas: ${categorias.length}');
      categorias.forEach((cat) => print('- ${cat.id}: ${cat.categoria}'));
      
      // Carregar endereços usando rota /addresses/[id]
      List<Endereco> enderecos = [];
      try {
        enderecos = await _loadAddressesFromRoutes();
        print('Endereços carregados via rotas: ${enderecos.length}');
        enderecos.forEach((addr) => print('- /addresses/${addr.id}: ${addr.addressLine}'));
      } catch (e) {
        print('Erro ao carregar endereços das rotas: $e');
        // Fallback: criar endereços de exemplo
        enderecos = [
          Endereco(
            id: '1',
            addressLine: 'Rua das Flores',
            addressNumber: '123',
            neighborhood: 'Centro',
            city: 'São Paulo',
            state: 'SP',
            cep: '01234-567',
            userId: 'user_1',
          ),
          Endereco(
            id: '2',
            addressLine: 'Av. Paulista',
            addressNumber: '1000',
            neighborhood: 'Bela Vista',
            city: 'São Paulo',
            state: 'SP',
            cep: '01310-100',
            userId: 'user_1',
          ),
        ];
      }
      print('Endereços carregados: ${enderecos.length}');
      enderecos.forEach((addr) => print('- ${addr.id}: ${addr.addressLine}'));
      
      setState(() {
        categories = categorias;
        addresses = enderecos;
        
        // Selecionar primeira categoria se não houver categoria específica
        if (categories.isNotEmpty) {
          selectedCategoryId = categories.first.id;
          print('Categoria selecionada: $selectedCategoryId');
        }
        
        // Selecionar primeiro endereço se disponível
        if (addresses.isNotEmpty) {
          selectedAddressId = addresses.first.id;
          print('Endereço selecionado: $selectedAddressId');
        }
      });
    } catch (e) {
      print('Erro ao carregar dados: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatarPreco(String valor) {
    if (valor.isEmpty) return '';
    
    // Remove tudo que não é número
    final numero = valor.replaceAll(RegExp(r'[^\d]'), '');
    
    if (numero.isEmpty) return '';
    
    // Converte para número e divide por 100 para obter o valor em reais
    final valorEmReais = (double.parse(numero) / 100).toStringAsFixed(2);
    
    // Formata com R$ e vírgula
    return 'R\$ ${valorEmReais.replaceAll('.', ',')}';
  }

  void _handleMinValueChange(String texto) {
    final apenasNumeros = texto.replaceAll(RegExp(r'[^\d]'), '');
    final novoValorMin = double.tryParse(apenasNumeros) ?? 0;
    final valorMax = double.tryParse(_maxValueController.text.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
    
    if (valorMax > 0 && novoValorMin >= valorMax) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O valor mínimo deve ser menor que o valor máximo.')),
      );
      return;
    }
    
    setState(() {
      _minValueController.text = apenasNumeros;
    });
  }

  void _handleMaxValueChange(String texto) {
    final apenasNumeros = texto.replaceAll(RegExp(r'[^\d]'), '');
    final novoValorMax = double.tryParse(apenasNumeros) ?? 0;
    final valorMin = double.tryParse(_minValueController.text.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
    
    if (valorMin > 0 && novoValorMax <= valorMin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O valor máximo deve ser maior que o valor mínimo.')),
      );
      return;
    }
    
    setState(() {
      _maxValueController.text = apenasNumeros;
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  String _displayDate() {
    final today = DateTime.now();
    if (selectedDate.year == today.year && 
        selectedDate.month == today.month && 
        selectedDate.day == today.day) {
      return 'Hoje';
    }
    return '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}';
  }

  Future<void> _handleSubmit() async {
    if (selectedCategoryId == null ||
        selectedAddressId == null ||
        _descriptionController.text.trim().isEmpty ||
        (isValueChecked && (_minValueController.text.isEmpty || _maxValueController.text.isEmpty))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
      );
      return;
    }

    if (isValueChecked) {
      final valorMin = double.tryParse(_minValueController.text.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      final valorMax = double.tryParse(_maxValueController.text.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      
      if (valorMin >= valorMax) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('O valor mínimo deve ser menor que o valor máximo.')),
        );
        return;
      }
      
      if (valorMin == 0 || valorMax == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Os valores não podem ser zero.')),
        );
        return;
      }
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Obter ID do usuário do SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userPFId = prefs.getString('userId') ?? 'user_teste_123'; // Usar userId fixo para testes
      
      print('=== CRIANDO SOLICITAÇÃO ===');
      print('userPFId usado: $userPFId');

      // Combinar data e hora
      final scheduledDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      // Corrigir valores para envio
      final valorMin = double.tryParse(_minValueController.text.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      final valorMax = double.tryParse(_maxValueController.text.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

      // Criar solicitação
      await _solicitacaoService.criarSolicitacao(
        categoryId: selectedCategoryId!,
        description: _descriptionController.text.trim(),
        scheduledDate: scheduledDateTime,
        minValue: isValueChecked ? valorMin / 100 : 0,
        maxValue: isValueChecked ? valorMax / 100 : 0,
        addressId: selectedAddressId!,
        userPFId: userPFId,
      );

      setState(() {
        successMessage = 'Serviço agendado com sucesso!';
      });

      // Navegar de volta após 1.5 segundos
      Future.delayed(const Duration(milliseconds: 1500), () {
        Navigator.of(context).pop();
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao agendar serviço: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Função para buscar endereços usando rota /addresses/[id]
  Future<List<Endereco>> _loadAddressesFromRoutes() async {
    List<Endereco> enderecos = [];
    
    try {
      // Simular busca de endereços usando rotas /addresses/[id]
      // Em um cenário real, você faria requisições para cada ID
      final addressIds = ['1', '2', '3']; // IDs dos endereços disponíveis
      
      for (String id in addressIds) {
        try {
          // Simular requisição para /addresses/[id]
          final endereco = await _fetchAddressById(id);
          if (endereco != null) {
            enderecos.add(endereco);
          }
        } catch (e) {
          print('Erro ao buscar endereço $id: $e');
        }
      }
    } catch (e) {
      print('Erro ao carregar endereços das rotas: $e');
    }
    
    return enderecos;
  }

  // Função para buscar endereço específico por ID
  Future<Endereco?> _fetchAddressById(String id) async {
    try {
      // Simular requisição para /addresses/[id]
      // Em um cenário real, você faria uma requisição HTTP
      print('Buscando endereço na rota /addresses/$id');
      
      // Simular dados de endereços baseados no ID
      switch (id) {
        case '1':
          return Endereco(
            id: '1',
            addressLine: 'Rua das Flores',
            addressNumber: '123',
            neighborhood: 'Centro',
            city: 'São Paulo',
            state: 'SP',
            cep: '01234-567',
            userId: 'user_1',
          );
        case '2':
          return Endereco(
            id: '2',
            addressLine: 'Av. Paulista',
            addressNumber: '1000',
            neighborhood: 'Bela Vista',
            city: 'São Paulo',
            state: 'SP',
            cep: '01310-100',
            userId: 'user_1',
          );
        case '3':
          return Endereco(
            id: '3',
            addressLine: 'Rua Augusta',
            addressNumber: '500',
            neighborhood: 'Consolação',
            city: 'São Paulo',
            state: 'SP',
            cep: '01305-000',
            userId: 'user_1',
          );
        default:
          return null;
      }
    } catch (e) {
      print('Erro ao buscar endereço $id: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressViewModel = Provider.of<AddressViewModel>(context);
    final addresses = addressViewModel.addresses;

    // Patch definitivo: garantir que o valor selecionado sempre exista na lista
    if (addresses.isNotEmpty && (selectedAddressId == null || !addresses.any((a) => a.id == selectedAddressId))) {
      selectedAddressId = addresses.first.id;
    }
    if (addresses.isEmpty) {
      selectedAddressId = null;
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Solicitação de Serviço',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _loadData,
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (successMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Text(
                        successMessage!,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  
                  // Debug info (remover em produção)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Debug Info:',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Categorias: ${categories.length}',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          'Endereços: ${addresses.length}',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          'Categoria selecionada: $selectedCategoryId',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          'Endereço selecionado: $selectedAddressId',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          'Rotas disponíveis: ${addresses.map((addr) => '/addresses/${addr.id}').join(', ')}',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Endereço
                  const Text(
                    'Endereço',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  if (addresses.isNotEmpty) ...[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedAddressId,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          hintText: 'Selecione um endereço',
                        ),
                        items: [
                          ...addresses.map((addr) => DropdownMenuItem(
                            value: addr.id,
                            child: SizedBox(
                              width: 220, // Ajuste conforme necessário
                              child: Text(
                                '${addr.addressLine}, ${addr.addressNumber} - ${addr.neighborhood ?? ''}',
                                style: const TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )),
                          const DropdownMenuItem(
                            value: 'meus_enderecos',
                            child: Text(
                              'Meus Endereços',
                              style: TextStyle(fontSize: 16, color: Colors.blue),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == 'meus_enderecos') {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const AddressScreen(),
                              ),
                            );
                          } else {
                            setState(() {
                              selectedAddressId = value;
                            });
                          }
                        },
                      ),
                    ),
                  ] else ...[
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AddressScreen(),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber),
                        ),
                        child: const Text(
                          'Clique aqui para cadastrar um endereço',
                          style: TextStyle(color: Colors.amber),
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Categoria
                  const Text(
                    'Categoria',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedCategoryId,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        hintText: 'Selecione uma categoria',
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Selecione uma categoria'),
                        ),
                        ...categories.map((cat) => DropdownMenuItem(
                          value: cat.id,
                          child: Text(
                            cat.categoria,
                            style: const TextStyle(fontSize: 16),
                          ),
                        )).toList(),
                      ],
                      onChanged: (value) {
                        print('Categoria selecionada: $value');
                        setState(() {
                          selectedCategoryId = value;
                          selectedSubcategory = null; // Reset subcategoria quando categoria muda
                        });
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Subcategoria (se categoria selecionada)
                  if (selectedCategoryId != null) ...[
                    const Text(
                      'Subcategoria',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedSubcategory,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          hintText: 'Selecione uma subcategoria',
                        ),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('Selecione uma subcategoria'),
                          ),
                          ...categories
                              .firstWhere((cat) => cat.id == selectedCategoryId)
                              .subcategorias
                              .map((subcat) => DropdownMenuItem(
                                    value: subcat,
                                    child: Text(
                                      subcat,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ))
                              .toList(),
                        ],
                        onChanged: (value) {
                          print('Subcategoria selecionada: $value');
                          setState(() {
                            selectedSubcategory = value;
                          });
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                  
                  // Descrição
                  const Text(
                    'Descrição do Serviço',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  TextField(
                    controller: _descriptionController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: 'Descreva detalhes sobre o serviço',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Data
                  const Text(
                    'Data do Serviço',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  GestureDetector(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _displayDate(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Hora
                  const Text(
                    'Hora do Serviço',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  GestureDetector(
                    onTap: _selectTime,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${selectedTime.hour.toString().padLeft(2, '0')}:00',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Icon(Icons.access_time),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Switch para valores
                  Row(
                    children: [
                      Switch(
                        value: isValueChecked,
                        onChanged: (value) {
                          setState(() {
                            isValueChecked = value;
                          });
                        },
                        activeColor: Colors.amber,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Definir Valores',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  
                  if (isValueChecked) ...[
                    const SizedBox(height: 16),
                    
                    // Valor Mínimo
                    const Text(
                      'Valor Mínimo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    TextField(
                      controller: _minValueController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        hintText: 'R\$ 0,00',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _minValueController.text = _formatarPreco(value);
                        });
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Valor Máximo
                    const Text(
                      'Valor Máximo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    TextField(
                      controller: _maxValueController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        hintText: 'R\$ 0,00',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _maxValueController.text = _formatarPreco(value);
                        });
                      },
                    ),
                  ],
                  
                  const SizedBox(height: 32),
                  
                  // Botão de agendar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: addresses.isEmpty ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: addresses.isEmpty ? Colors.grey : Colors.amber,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Agendar Serviço',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _minValueController.dispose();
    _maxValueController.dispose();
    super.dispose();
  }
} 