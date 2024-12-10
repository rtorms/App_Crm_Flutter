import 'package:crm_flutter/model/Cliente.dart';
import 'package:crm_flutter/route/config.dart';
import 'package:crm_flutter/screens/Lista_cliente_screen.dart';
import 'package:crm_flutter/service/ClienteService.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class CadastroClienteScreen extends StatefulWidget {
  final Cliente? cliente;

  const CadastroClienteScreen({Key? key, this.cliente}) : super(key: key);

  @override
  _CadastroClienteScreenState createState() => _CadastroClienteScreenState();
}

class _CadastroClienteScreenState extends State<CadastroClienteScreen> {
  late final TextEditingController _razaoSocialController;
  late final TextEditingController _nomeFantasiaController;
  late final TextEditingController _cpfCnpjController;
  late final TextEditingController _telefoneController;
  late final TextEditingController _cepController;
  late final TextEditingController _enderecoController;
  late final TextEditingController _numeroController;
  late final TextEditingController _bairroController;
  late final TextEditingController _complementoController;
  late final TextEditingController _cidadeController;

  late final ClienteService clienteService;

  String _cpfCnpjMask = '###.###.###-##'; // Inicia com CPF

  void _updateMask(String value) {
    setState(() {
      // formata de acordo com quantidades digitos
      _cpfCnpjMask =
          value.length < 14 ? '###.###.###-##' : '##.###.###/####-##';
    });
  }

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    dio.options.baseUrl = config.urlBase;
    clienteService = ClienteService(dio);

    _razaoSocialController =
        TextEditingController(text: widget.cliente?.razaoSocial ?? '');
    _nomeFantasiaController =
        TextEditingController(text: widget.cliente?.nomeFantasia ?? '');
    _cpfCnpjController =
        TextEditingController(text: widget.cliente?.cpfCnpj ?? '');
    _telefoneController =
        TextEditingController(text: widget.cliente?.telefone ?? '');
    _cepController = TextEditingController(text: widget.cliente?.cep ?? '');
    _enderecoController =
        TextEditingController(text: widget.cliente?.endereco ?? '');
    _numeroController =
        TextEditingController(text: widget.cliente?.numero ?? '');
    _bairroController =
        TextEditingController(text: widget.cliente?.bairro ?? '');
    _complementoController =
        TextEditingController(text: widget.cliente?.complemento ?? '');
    _cidadeController =
        TextEditingController(text: widget.cliente?.cidade ?? '');
  }

  Future<void> _salvarCliente() async {
    Cliente cliente = Cliente(
      id: widget.cliente?.id, // Mantém o ID se for edição
      razaoSocial: _razaoSocialController.text,
      nomeFantasia: _nomeFantasiaController.text,
      cpfCnpj: _cpfCnpjController.text,
      telefone: _telefoneController.text,
      cep: _cepController.text,
      endereco: _enderecoController.text,
      numero: _numeroController.text,
      bairro: _bairroController.text,
      complemento: _complementoController.text,
      cidade: _cidadeController.text,
    );

    try {
      final savedCliente = await clienteService.save(cliente);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cliente salvo com sucesso!')),
      );
      Navigator.pop(context, savedCliente);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar cliente: $e')),
      );
    }
  }

  Future<void> _excluirCliente() async {
    if (widget.cliente != null) {
      try {
        bool result = await clienteService.delete(widget.cliente!.id!);
        if (result) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cliente excluído com sucesso!')),
          );
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ClienteListScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Erro ao excluir cliente. Tente novamente!')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir cliente!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cliente == null
            ? 'Novo Cliente'
            : 'Editar Cliente: ${widget.cliente!.razaoSocial}'),
        actions: [
          if (widget.cliente != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _excluirCliente,
              tooltip: 'Excluir Cliente',
            ),
          IconButton(
              key: Key('ibSalvarCliente'),
              icon: const Icon(Icons.save),
              onPressed: _salvarCliente),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextField(_razaoSocialController, 'Razão Social'),
              _buildTextField(_nomeFantasiaController, 'Nome Fantasia'),
              _buildTextField(
                _cpfCnpjController,
                'CPF/CNPJ',
                inputFormatters: [
                  MaskedInputFormatter(_cpfCnpjMask),
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
                onChanged: _updateMask,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                _telefoneController,
                'Telefone',
                inputFormatters: [PhoneInputFormatter()],
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                _cepController,
                'CEP',
                inputFormatters: [MaskedInputFormatter('#####-###')],
                keyboardType: TextInputType.number,
              ),
              _buildTextField(_enderecoController, 'Endereço'),
              _buildTextField(_numeroController, 'Número'),
              _buildTextField(_bairroController, 'Bairro'),
              _buildTextField(_complementoController, 'Complemento'),
              _buildTextField(_cidadeController, 'Cidade'),
              const SizedBox(height: 20),
              ElevatedButton(
                key: Key('ebSalvarCliente'),
                onPressed: _salvarCliente,
                child: const Text('Salvar Cliente'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    List<TextInputFormatter>? inputFormatters,
    void Function(String)? onChanged,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        keyboardType: keyboardType,
      ),
    );
  }
}
