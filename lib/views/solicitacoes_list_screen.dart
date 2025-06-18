import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/solicitacao_servico.dart';
import '../Services/solicitacao_service.dart';

class SolicitacoesListScreen extends StatefulWidget {
  const SolicitacoesListScreen({Key? key}) : super(key: key);

  @override
  State<SolicitacoesListScreen> createState() => _SolicitacoesListScreenState();
}

class _SolicitacoesListScreenState extends State<SolicitacoesListScreen> {
  final SolicitacaoService _solicitacaoService = SolicitacaoService();
  
  List<SolicitacaoServico> solicitacoes = [];
  bool isLoading = true;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadSolicitacoes();
    _definirUserIdFixo(); // Definir userId fixo para testes
  }

  Future<void> _loadSolicitacoes() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userId') ?? 'user_${DateTime.now().millisecondsSinceEpoch}'; 
      
      final lista = await _solicitacaoService.listarSolicitacoesPorUsuario(userId!);
      
      setState(() {
        solicitacoes = lista;
      });
    } catch (e) {
      print('Erro ao carregar solicitações: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar solicitações: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Método para definir userId fixo para testes
  Future<void> _definirUserIdFixo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', 'user_teste_123');
    print('userId fixo definido: user_teste_123');
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pendente':
        return Colors.orange;
      case 'aceito':
        return Colors.blue;
      case 'em_andamento':
        return Colors.purple;
      case 'concluido':
        return Colors.green;
      case 'cancelado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _atualizarStatus(String id, String novoStatus) async {
    try {
      await _solicitacaoService.atualizarStatus(id, novoStatus);
      await _loadSolicitacoes(); // Recarregar lista
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status atualizado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar status: $e')),
      );
    }
  }

  Future<void> _deletarSolicitacao(String id) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir esta solicitação?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Excluir'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirmacao == true) {
      try {
        await _solicitacaoService.deletarSolicitacao(id);
        await _loadSolicitacoes(); // Recarregar lista
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Solicitação excluída com sucesso!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir solicitação: $e')),
        );
      }
    }
  }

  void _mostrarDetalhes(SolicitacaoServico solicitacao) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Detalhes da Solicitação',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Status
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(solicitacao.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _solicitacaoService.obterStatusEmPortugues(solicitacao.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Descrição
            const Text(
              'Descrição:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(solicitacao.description),
            
            const SizedBox(height: 8),
            
            // Data e hora
            const Text(
              'Data e Hora:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('${_solicitacaoService.formatarData(solicitacao.scheduledDate)} às ${_solicitacaoService.formatarHora(solicitacao.scheduledDate)}'),
            
            const SizedBox(height: 8),
            
            // Valores
            if (solicitacao.minValue > 0 || solicitacao.maxValue > 0) ...[
              const Text(
                'Valores:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('${_solicitacaoService.formatarValor(solicitacao.minValue)} - ${_solicitacaoService.formatarValor(solicitacao.maxValue)}'),
              const SizedBox(height: 8),
            ],
            
            // Data de criação
            const Text(
              'Criado em:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(_solicitacaoService.formatarData(solicitacao.createdAt)),
            
            const SizedBox(height: 16),
            
            // Ações
            if (solicitacao.status == 'pendente') ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _atualizarStatus(solicitacao.id, 'aceito');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Aceitar'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _atualizarStatus(solicitacao.id, 'cancelado');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                ],
              ),
            ] else if (solicitacao.status == 'aceito') ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _atualizarStatus(solicitacao.id, 'em_andamento');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  child: const Text('Iniciar Serviço'),
                ),
              ),
            ] else if (solicitacao.status == 'em_andamento') ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _atualizarStatus(solicitacao.id, 'concluido');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Concluir Serviço'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Minhas Solicitações',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'refresh':
                  _loadSolicitacoes();
                  break;
                case 'set_user':
                  _definirUserIdFixo().then((_) => _loadSolicitacoes());
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Text('Recarregar'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'set_user',
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text('Definir User ID Fixo'),
                  ],
                ),
              ),
            ],
            child: const Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            )
          : solicitacoes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhuma solicitação encontrada',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Crie uma nova solicitação de serviço',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadSolicitacoes,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: solicitacoes.length,
                    itemBuilder: (context, index) {
                      final solicitacao = solicitacoes[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            solicitacao.description.length > 50
                                ? '${solicitacao.description.substring(0, 50)}...'
                                : solicitacao.description,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${_solicitacaoService.formatarData(solicitacao.scheduledDate)} às ${_solicitacaoService.formatarHora(solicitacao.scheduledDate)}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              if (solicitacao.minValue > 0 || solicitacao.maxValue > 0) ...[
                                Row(
                                  children: [
                                    Icon(
                                      Icons.attach_money,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${_solicitacaoService.formatarValor(solicitacao.minValue)} - ${_solicitacaoService.formatarValor(solicitacao.maxValue)}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                              ],
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(solicitacao.status),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _solicitacaoService.obterStatusEmPortugues(solicitacao.status),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              switch (value) {
                                case 'detalhes':
                                  _mostrarDetalhes(solicitacao);
                                  break;
                                case 'excluir':
                                  _deletarSolicitacao(solicitacao.id);
                                  break;
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'detalhes',
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline),
                                    SizedBox(width: 8),
                                    Text('Ver detalhes'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'excluir',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Excluir', style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: () => _mostrarDetalhes(solicitacao),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
} 