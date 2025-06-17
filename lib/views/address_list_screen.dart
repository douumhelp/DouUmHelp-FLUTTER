import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../viewmodels/address_viewmodel.dart';
import 'address_form_screen.dart';
import '../services/address_service.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({Key? key}) : super(key: key);

  @override
  AddressListScreenState createState() => AddressListScreenState();
}

class AddressListScreenState extends State<AddressListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressViewModel>().loadAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressViewModel>(
      builder: (context, addressViewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Meus Endereços',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: const Color(0xFFFACC15),
            foregroundColor: Colors.black,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  addressViewModel.refreshAddresses();
                },
              ),
              IconButton(
                icon: const Icon(Icons.bug_report),
                onPressed: () async {
                  final isConnected = await AddressService.testApiConnection();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isConnected ? 'API conectada!' : 'Erro na conexão com API'),
                        backgroundColor: isConnected ? Colors.green : Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          body: addressViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: addressViewModel.refreshAddresses,
                  child: addressViewModel.addresses.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhum endereço cadastrado',
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Toque no botão + para adicionar um endereço',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: addressViewModel.addresses.length,
                          itemBuilder: (context, index) {
                            final address = addressViewModel.addresses[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xFFFACC15),
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.black,
                                  ),
                                ),
                                title: Text(
                                  (address.label?.isNotEmpty == true) ? address.label! : 'Endereço ${index + 1}',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${address.addressLine}, ${address.addressNumber}',
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if (address.neighborhood != null && address.neighborhood!.isNotEmpty)
                                      Text(
                                        'Bairro: ${address.neighborhood}',
                                        style: GoogleFonts.outfit(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    if (address.neighborhood != null && address.neighborhood!.isNotEmpty)
                                      const SizedBox(height: 4),
                                    if (address.label != null && address.label!.isNotEmpty)
                                      Text(
                                        'Complemento: ${address.label}',
                                        style: GoogleFonts.outfit(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    if (address.label != null && address.label!.isNotEmpty)
                                      const SizedBox(height: 4),
                                    Text(
                                      '${address.city} - ${address.state}',
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'CEP: ${address.cep}',
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      addressViewModel.setSelectedAddress(address);
                                      if (mounted) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const AddressFormScreen(),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, color: Colors.blue),
                                          SizedBox(width: 8),
                                          Text('Editar'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              addressViewModel.setSelectedAddress(null);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddressFormScreen(),
                ),
              );
            },
            backgroundColor: const Color(0xFFFACC15),
            foregroundColor: Colors.black,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
} 