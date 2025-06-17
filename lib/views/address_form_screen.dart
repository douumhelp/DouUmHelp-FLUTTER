import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../viewmodels/address_viewmodel.dart';
import '../models/endereco.dart';

class AddressFormScreen extends StatefulWidget {
  const AddressFormScreen({Key? key}) : super(key: key);

  @override
  AddressFormScreenState createState() => AddressFormScreenState();
}

class AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressViewModel>(
      builder: (context, addressViewModel, child) {
        final isEditing = addressViewModel.selectedAddress != null;
        
    return Scaffold(
      appBar: AppBar(
        title: Text(
              isEditing ? 'Editar Endereço' : 'Novo Endereço',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: const Color(0xFFFACC15),
            foregroundColor: Colors.black,
      ),
          body: addressViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
        key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                        // CEP
                        TextFormField(
                          controller: addressViewModel.cepController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'CEP *',
                            prefixIcon: const Icon(Icons.pin_drop, color: Colors.brown),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o CEP';
                  }
                            if (value.length != 8) {
                    return 'CEP deve ter 8 dígitos';
                  }
                  return null;
                },
              ),
                        
              const SizedBox(height: 16),
                        
                        // Rua (Address Line)
                        TextFormField(
                          controller: addressViewModel.addressLineController,
                          decoration: InputDecoration(
                            labelText: 'Rua *',
                            prefixIcon: const Icon(Icons.streetview, color: Colors.brown),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                              return 'Por favor, insira a rua';
                  }
                  return null;
                },
              ),
                        
              const SizedBox(height: 16),
                        
                        // Número (Address Number)
                        TextFormField(
                          controller: addressViewModel.addressNumberController,
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
                        
                        // Bairro (Neighborhood)
                        TextFormField(
                          controller: addressViewModel.neighborhoodController,
                          decoration: InputDecoration(
                            labelText: 'Bairro',
                            prefixIcon: const Icon(Icons.location_city, color: Colors.brown),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                        
              const SizedBox(height: 16),
                        
                        // Complemento (Label)
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
                        
                        // Cidade (City)
                        TextFormField(
                          controller: addressViewModel.cityController,
                          decoration: InputDecoration(
                            labelText: 'Cidade *',
                            prefixIcon: const Icon(Icons.location_city, color: Colors.brown),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a cidade';
                  }
                  return null;
                },
              ),
                        
              const SizedBox(height: 16),
                        
                        // Estado (State)
                        TextFormField(
                          controller: addressViewModel.stateController,
                          decoration: InputDecoration(
                            labelText: 'Estado *',
                            prefixIcon: const Icon(Icons.map, color: Colors.brown),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                              return 'Por favor, insira o estado';
                  }
                  return null;
                },
              ),
                        
              const SizedBox(height: 32),
                        
                        // Botão Salvar
                ElevatedButton(
                          onPressed: addressViewModel.isLoading ? null : () async {
                            if (_formKey.currentState!.validate()) {
                              // Criar objeto Endereco com os dados do formulário
                              final endereco = Endereco(
                                id: isEditing ? addressViewModel.selectedAddress?.id : null,
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
                                Navigator.pop(context);
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
                                  isEditing ? 'Atualizar' : 'Salvar',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
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
                        
                        if (addressViewModel.successMessage != null)
                          Container(
                            margin: const EdgeInsets.only(top: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green[200]!),
                            ),
                            child: Text(
                              addressViewModel.successMessage!,
                              style: GoogleFonts.outfit(
                                color: Colors.green[700],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
      },
    );
  }
} 