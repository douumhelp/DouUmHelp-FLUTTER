import 'package:flutter/material.dart';
import '../services/address_service.dart';
import '../services/cep_service.dart';
import '../models/endereco.dart';
import 'base_viewmodel.dart';

class AddressViewModel extends BaseViewModel {
  List<Endereco> _addresses = [];
  Endereco? _selectedAddress;

  List<Endereco> get addresses => _addresses;
  Endereco? get selectedAddress => _selectedAddress;

  // Controllers para formulário
  final TextEditingController cepController = TextEditingController();
  final TextEditingController addressLineController = TextEditingController();
  final TextEditingController addressNumberController = TextEditingController();
  final TextEditingController neighborhoodController = TextEditingController();
  final TextEditingController labelController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  // Campos bloqueados (preenchidos automaticamente pelo CEP)
  bool _addressLineLocked = false;
  bool _neighborhoodLocked = false;
  bool _cityLocked = false;
  bool _stateLocked = false;

  bool get addressLineLocked => _addressLineLocked;
  bool get neighborhoodLocked => _neighborhoodLocked;
  bool get cityLocked => _cityLocked;
  bool get stateLocked => _stateLocked;

  void setSelectedAddress(Endereco? address) {
    _selectedAddress = address;
    if (address != null) {
      _populateFormWithAddress(address);
    } else {
      _clearForm();
    }
    notifyListeners();
  }

  void _populateFormWithAddress(Endereco address) {
    cepController.text = _formatCep(address.cep);
    addressLineController.text = address.addressLine;
    addressNumberController.text = address.addressNumber;
    neighborhoodController.text = address.neighborhood ?? '';
    labelController.text = address.label ?? '';
    cityController.text = address.city;
    stateController.text = address.state;
    
    // Reset campos bloqueados ao editar
    _resetLockedFields();
  }

  void _clearForm() {
    cepController.clear();
    addressLineController.clear();
    addressNumberController.clear();
    neighborhoodController.clear();
    labelController.clear();
    cityController.clear();
    stateController.clear();
    _resetLockedFields();
  }

  void _resetLockedFields() {
    _addressLineLocked = false;
    _neighborhoodLocked = false;
    _cityLocked = false;
    _stateLocked = false;
    notifyListeners();
  }

  // Formatar CEP (00000-000)
  String _formatCep(String cep) {
    final cepLimpo = cep.replaceAll(RegExp(r'[^\d]'), '');
    if (cepLimpo.length == 8) {
      return '${cepLimpo.substring(0, 5)}-${cepLimpo.substring(5)}';
    }
    return cep;
  }

  // Consultar CEP via API
  Future<void> consultarCep() async {
    final cep = cepController.text.trim();
    if (cep.isEmpty) {
      setError('Digite um CEP');
      return;
    }

    await executeAsync(() async {
      try {
        final cepData = await CepService.consultarCep(cep);
        
        if (cepData != null) {
          // Determina quais campos serão bloqueados
          _addressLineLocked = cepData['logradouro']?.isNotEmpty == true;
          _neighborhoodLocked = cepData['bairro']?.isNotEmpty == true;
          _cityLocked = cepData['localidade']?.isNotEmpty == true;
          _stateLocked = cepData['uf']?.isNotEmpty == true;

          // Preenche os campos com os dados da API
          if (_addressLineLocked) {
            addressLineController.text = cepData['logradouro'];
          }
          if (_neighborhoodLocked) {
            neighborhoodController.text = cepData['bairro'];
          }
          if (_cityLocked) {
            cityController.text = cepData['localidade'];
          }
          if (_stateLocked) {
            stateController.text = cepData['uf'];
          }

          setSuccess('CEP consultado com sucesso!');
        }
      } catch (e) {
        setError('Erro ao consultar CEP: ${e.toString()}');
      }
    });
  }

  Future<void> loadAddresses() async {
    await executeAsync(() async {
      final addresses = await AddressService.getAddresses();
      _addresses = addresses;
    });
  }

  Future<bool> saveAddress(Endereco endereco) async {
    try {
      setLoading(true);
      
      print('=== SAVE ADDRESS VIEWMODEL ===');
      print('Endereco: $endereco');
      print('CEP: ${endereco.cep}');
      print('Address Line: ${endereco.addressLine}');
      print('Address Number: ${endereco.addressNumber}');
      print('City: ${endereco.city}');
      print('State: ${endereco.state}');
      print('Latitude: ${endereco.latitude}');
      print('Longitude: ${endereco.longitude}');
      print('User ID: ${endereco.userId}');
      
      // Validar campos obrigatórios
      if (endereco.cep.isEmpty || endereco.addressLine.isEmpty || 
          endereco.addressNumber.isEmpty || endereco.city.isEmpty || 
          endereco.state.isEmpty) {
        setError('Todos os campos obrigatórios devem ser preenchidos');
        return false;
      }
      
      // Validar CEP
      final cepDigits = endereco.cep.replaceAll(RegExp(r'[^\d]'), '');
      if (cepDigits.length != 8) {
        setError('CEP deve ter 8 dígitos');
        return false;
      }
      
      // Validar estado
      if (endereco.state.trim().length < 2) {
        setError('Estado deve ter pelo menos 2 caracteres');
        return false;
      }
      
      bool success;
      Endereco? createdAddress;
      
      if (endereco.id != null) {
        try {
          createdAddress = await AddressService.updateAddress(endereco.id!, endereco);
          success = true;
        } catch (e) {
          print('Erro ao atualizar endereço: $e');
          success = false;
        }
      } else {
        try {
          createdAddress = await AddressService.createAddress(endereco);
          success = true;
        } catch (e) {
          print('Erro ao criar endereço: $e');
          success = false;
        }
      }
      
      if (success && createdAddress != null) {
        // Adicionar o endereço criado/atualizado à lista
        if (endereco.id != null) {
          // Atualizar endereço existente
          final index = _addresses.indexWhere((addr) => addr.id == endereco.id);
          if (index != -1) {
            _addresses[index] = createdAddress;
          }
        } else {
          // Adicionar novo endereço
          _addresses.add(createdAddress);
        }
        notifyListeners();
        setError(null);
        return true;
      } else {
        setError('Erro ao salvar endereço');
        return false;
      }
    } catch (e) {
      print('Erro no saveAddress: $e');
      setError('Erro inesperado: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteAddress(String addressId) async {
    await executeAsync(() async {
      await AddressService.deleteAddress(addressId);
      setSuccess('Endereço excluído com sucesso!');
      await loadAddresses(); // Recarregar lista
    });
  }

  Future<void> refreshAddresses() async {
    await loadAddresses();
  }

  @override
  void dispose() {
    cepController.dispose();
    addressLineController.dispose();
    addressNumberController.dispose();
    neighborhoodController.dispose();
    labelController.dispose();
    cityController.dispose();
    stateController.dispose();
    super.dispose();
  }
} 