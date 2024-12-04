import 'package:crm_flutter/model/Cliente.dart';
import 'package:crm_flutter/route/config.dart';
import 'package:crm_flutter/screens/Lista_cliente_screen.dart';
import 'package:crm_flutter/service/ClienteService.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
  late final TextEditingController _bairroController;
  late final TextEditingController _complementoController;
  late final TextEditingController _cidadeController;

  late final ClienteService clienteService;

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
            SnackBar(content: Text('Cliente excluido com sucesso!')),
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
          SnackBar(content: Text('Erro ao excluir cliente: $error')),
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: _razaoSocialController,
                  decoration: const InputDecoration(labelText: 'Razão Social'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: _nomeFantasiaController,
                  decoration: const InputDecoration(labelText: 'Nome Fantasia'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: _cpfCnpjController,
                  decoration: const InputDecoration(labelText: 'CPF/CNPJ'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: _telefoneController,
                  decoration: const InputDecoration(labelText: 'Telefone'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: _cepController,
                  decoration: const InputDecoration(labelText: 'CEP'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: _enderecoController,
                  decoration: const InputDecoration(labelText: 'Endereço'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: _bairroController,
                  decoration: const InputDecoration(labelText: 'Bairro'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: _complementoController,
                  decoration: const InputDecoration(labelText: 'Complemento'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: _cidadeController,
                  decoration: const InputDecoration(labelText: 'Cidade'),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarCliente,
                child: const Text('Salvar Cliente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
