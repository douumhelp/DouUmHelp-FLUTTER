import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../viewmodels/address_viewmodel.dart';
import '../models/endereco.dart';
import '../utils/config.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressViewModel>(
      builder: (context, addressViewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: AppBar(
            title: Text(
              'Meus Endereços',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            backgroundColor: const Color(0xFFFACC15),
            foregroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: addressViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // Formulário
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Consulta de CEP
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Consulta de CEP',
                                      style: GoogleFonts.outfit(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: addressViewModel.cepController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'CEP',
                                              hintText: '00000-000',
                                              prefixIcon: const Icon(Icons.pin_drop, color: Colors.brown),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              filled: true,
                                              fillColor: Colors.grey[50],
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              LengthLimitingTextInputFormatter(8),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        ElevatedButton(
                                          onPressed: addressViewModel.isLoading 
                                              ? null 
                                              : () => addressViewModel.consultarCep(),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFFACC15),
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Text(
                                            'Consultar',
                                            style: GoogleFonts.outfit(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Formulário de endereço
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dados do Endereço',
                                      style: GoogleFonts.outfit(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // Rua
                                    TextFormField(
                                      controller: addressViewModel.addressLineController,
                                      enabled: !addressViewModel.addressLineLocked,
                                      decoration: InputDecoration(
                                        labelText: 'Rua *',
                                        prefixIcon: const Icon(Icons.streetview, color: Colors.brown),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        filled: true,
                                        fillColor: addressViewModel.addressLineLocked 
                                            ? Colors.grey[200] 
                                            : Colors.grey[50],
                                        suffixIcon: addressViewModel.addressLineLocked
                                            ? const Icon(Icons.lock, color: Colors.grey)
                                            : null,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, insira a rua';
                                        }
                                        return null;
                                      },
                                    ),
                                    
                                    const SizedBox(height: 16),
                                    
                                    // Número
                                    TextFormField(
                                      controller: addressViewModel.addressNumberController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Número *',
                                        prefixIcon: const Icon(Icons.home, color: Colors.brown),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, insira o número';
                                        }
                                        return null;
                                      },
                                    ),
                                    
                                    const SizedBox(height: 16),
                                    
                                    // Complemento
                                    TextFormField(
                                      controller: addressViewModel.labelController,
                                      decoration: InputDecoration(
                                        labelText: 'Complemento',
                                        prefixIcon: const Icon(Icons.add_location, color: Colors.brown),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 16),
                                    
                                    // Bairro
                                    TextFormField(
                                      controller: addressViewModel.neighborhoodController,
                                      enabled: !addressViewModel.neighborhoodLocked,
                                      decoration: InputDecoration(
                                        labelText: 'Bairro',
                                        prefixIcon: const Icon(Icons.location_city, color: Colors.brown),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        filled: true,
                                        fillColor: addressViewModel.neighborhoodLocked 
                                            ? Colors.grey[200] 
                                            : Colors.grey[50],
                                        suffixIcon: addressViewModel.neighborhoodLocked
                                            ? const Icon(Icons.lock, color: Colors.grey)
                                            : null,
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 16),
                                    
                                    // Cidade
                                    TextFormField(
                                      controller: addressViewModel.cityController,
                                      enabled: !addressViewModel.cityLocked,
                                      decoration: InputDecoration(
                                        labelText: 'Cidade *',
                                        prefixIcon: const Icon(Icons.location_city, color: Colors.brown),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        filled: true,
                                        fillColor: addressViewModel.cityLocked 
                                            ? Colors.grey[200] 
                                            : Colors.grey[50],
                                        suffixIcon: addressViewModel.cityLocked
                                            ? const Icon(Icons.lock, color: Colors.grey)
                                            : null,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, insira a cidade';
                                        }
                                        return null;
                                      },
                                    ),
                                    
                                    const SizedBox(height: 16),
                                    
                                    // Estado
                                    TextFormField(
                                      controller: addressViewModel.stateController,
                                      enabled: !addressViewModel.stateLocked,
                                      decoration: InputDecoration(
                                        labelText: 'Estado *',
                                        prefixIcon: const Icon(Icons.map, color: Colors.brown),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        filled: true,
                                        fillColor: addressViewModel.stateLocked 
                                            ? Colors.grey[200] 
                                            : Colors.grey[50],
                                        suffixIcon: addressViewModel.stateLocked
                                            ? const Icon(Icons.lock, color: Colors.grey)
                                            : null,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Por favor, insira o estado';
                                        }
                                        return null;
                                      },
                                    ),
                                    
                                    const SizedBox(height: 24),
                                    
                                    // Botão Salvar
                                    ElevatedButton(
                                      onPressed: addressViewModel.isLoading ? null : () async {
                                        if (_formKey.currentState!.validate()) {
                                          // Criar objeto Endereco com os dados do formulário
                                          final endereco = Endereco(
                                            id: addressViewModel.selectedAddress?.id,
                                            cep: addressViewModel.cepController.text.trim(),
                                            addressLine: addressViewModel.addressLineController.text.trim(),
                                            addressNumber: addressViewModel.addressNumberController.text.trim(),
                                            neighborhood: addressViewModel.neighborhoodController.text.trim().isEmpty 
                                                ? null 
                                                : addressViewModel.neighborhoodController.text.trim(),
                                            label: addressViewModel.labelController.text.trim().isEmpty 
                                                ? null 
                                                : addressViewModel.labelController.text.trim(),
                                            city: addressViewModel.cityController.text.trim(),
                                            state: addressViewModel.stateController.text.trim(),
                                          );
                                          
                                          final success = await addressViewModel.saveAddress(endereco);
                                          
                                          if (success && mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Endereço salvo com sucesso!'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                            // Limpar formulário após sucesso
                                            addressViewModel.setSelectedAddress(null);
                                          } else if (addressViewModel.errorMessage != null && mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(addressViewModel.errorMessage!),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFFACC15),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: addressViewModel.isLoading
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                              ),
                                            )
                                          : Text(
                                              addressViewModel.selectedAddress != null ? 'Atualizar' : 'Salvar',
                                              style: GoogleFonts.outfit(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Mensagens de erro/sucesso
                              if (addressViewModel.errorMessage != null)
                                Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.red[200]!),
                                  ),
                                  child: Text(
                                    addressViewModel.errorMessage!,
                                    style: GoogleFonts.outfit(
                                      color: Colors.red[700],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Lista de endereços
                    Container(
                      height: 300,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Endereços Cadastrados',
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
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
                                            fontSize: 16,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: addressViewModel.addresses.length,
                                    itemBuilder: (context, index) {
                                      final address = addressViewModel.addresses[index];
                                      return Card(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.all(12),
                                          leading: CircleAvatar(
                                            backgroundColor: const Color(0xFFFACC15),
                                            child: Icon(
                                              Icons.location_on,
                                              color: Colors.black,
                                            ),
                                          ),
                                          title: Text(
                                            '${address.addressLine}, ${address.addressNumber}',
                                            style: GoogleFonts.outfit(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              if (address.label?.isNotEmpty == true)
                                                Text(
                                                  'Complemento: ${address.label}',
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              if (address.neighborhood?.isNotEmpty == true)
                                                Text(
                                                  'Bairro: ${address.neighborhood}',
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              Text(
                                                '${address.city} - ${address.state}',
                                                style: GoogleFonts.outfit(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              Text(
                                                'CEP: ${address.cep}',
                                                style: GoogleFonts.outfit(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: PopupMenuButton<String>(
                                            onSelected: (value) async {
                                              if (value == 'edit') {
                                                addressViewModel.setSelectedAddress(address);
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
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
} 