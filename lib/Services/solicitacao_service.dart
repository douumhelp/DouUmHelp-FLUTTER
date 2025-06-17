import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/solicitacao_servico.dart';
import '../models/categoria.dart';
import '../models/endereco.dart';

class SolicitacaoService {
  static const String _storageKey = 'solicitacoes_servico';
  
  // Criar nova solicitação
  Future<SolicitacaoServico> criarSolicitacao({
    required String categoryId,
    required String description,
    required DateTime scheduledDate,
    required double minValue,
    required double maxValue,
    required String addressId,
    required String userPFId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Gerar ID único
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Criar nova solicitação
    final solicitacao = SolicitacaoServico(
      id: id,
      categoryId: categoryId,
      description: description,
      scheduledDate: scheduledDate,
      minValue: minValue,
      maxValue: maxValue,
      addressId: addressId,
      userPFId: userPFId,
      createdAt: DateTime.now(),
    );
    
    // Buscar solicitações existentes
    final solicitacoes = await listarSolicitacoes();
    solicitacoes.add(solicitacao);
    
    // Salvar no storage
    await _salvarSolicitacoes(solicitacoes);
    
    return solicitacao;
  }
  
  // Listar todas as solicitações
  Future<List<SolicitacaoServico>> listarSolicitacoes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    
    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => SolicitacaoServico.fromJson(json)).toList();
    } catch (e) {
      print('Erro ao carregar solicitações: $e');
      return [];
    }
  }
  
  // Listar solicitações por usuário
  Future<List<SolicitacaoServico>> listarSolicitacoesPorUsuario(String userPFId) async {
    final todas = await listarSolicitacoes();
    return todas.where((s) => s.userPFId == userPFId).toList();
  }
  
  // Buscar solicitação por ID
  Future<SolicitacaoServico?> buscarPorId(String id) async {
    final todas = await listarSolicitacoes();
    try {
      return todas.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Atualizar status da solicitação
  Future<bool> atualizarStatus(String id, String novoStatus) async {
    final solicitacoes = await listarSolicitacoes();
    final index = solicitacoes.indexWhere((s) => s.id == id);
    
    if (index == -1) return false;
    
    solicitacoes[index] = solicitacoes[index].copyWith(status: novoStatus);
    await _salvarSolicitacoes(solicitacoes);
    
    return true;
  }
  
  // Deletar solicitação
  Future<bool> deletarSolicitacao(String id) async {
    final solicitacoes = await listarSolicitacoes();
    solicitacoes.removeWhere((s) => s.id == id);
    await _salvarSolicitacoes(solicitacoes);
    
    return true;
  }
  
  // Método auxiliar para salvar no storage
  Future<void> _salvarSolicitacoes(List<SolicitacaoServico> solicitacoes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = solicitacoes.map((s) => s.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await prefs.setString(_storageKey, jsonString);
  }
  
  // Buscar categoria por ID
  Future<Categoria?> buscarCategoria(String categoryId) async {
    // Simular busca de categoria (você pode implementar um CategoryService similar)
    final categorias = [
      Categoria(id: '1', categoria: 'Limpeza', icon: 'home', subcategorias: ['Limpeza Residencial']),
      Categoria(id: '2', categoria: 'Manutenção', icon: 'build', subcategorias: ['Reparos']),
      Categoria(id: '3', categoria: 'Transporte', icon: 'directions_car', subcategorias: ['Frete']),
      Categoria(id: '4', categoria: 'Tecnologia', icon: 'code', subcategorias: ['Desenvolvimento']),
      Categoria(id: '5', categoria: 'Educação', icon: 'school', subcategorias: ['Aulas']),
    ];
    
    try {
      return categorias.firstWhere((c) => c.id == categoryId);
    } catch (e) {
      return null;
    }
  }
  
  // Buscar endereço por ID
  Future<Endereco?> buscarEndereco(String addressId) async {
    // Simular busca de endereço (você pode implementar um AddressService similar)
    // Por enquanto, retorna null - você pode integrar com o AddressService existente
    return null;
  }
  
  // Formatar valor monetário
  String formatarValor(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }
  
  // Formatar data
  String formatarData(DateTime data) {
    final hoje = DateTime.now();
    final amanha = hoje.add(Duration(days: 1));
    
    if (data.year == hoje.year && data.month == hoje.month && data.day == hoje.day) {
      return 'Hoje';
    } else if (data.year == amanha.year && data.month == amanha.month && data.day == amanha.day) {
      return 'Amanhã';
    } else {
      return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
    }
  }
  
  // Formatar hora
  String formatarHora(DateTime data) {
    return '${data.hour.toString().padLeft(2, '0')}:00';
  }
  
  // Obter status em português
  String obterStatusEmPortugues(String status) {
    switch (status) {
      case 'pendente':
        return 'Pendente';
      case 'aceito':
        return 'Aceito';
      case 'em_andamento':
        return 'Em Andamento';
      case 'concluido':
        return 'Concluído';
      case 'cancelado':
        return 'Cancelado';
      default:
        return 'Desconhecido';
    }
  }
} 