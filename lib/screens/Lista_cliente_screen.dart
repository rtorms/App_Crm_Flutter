import 'package:crm_flutter/model/Cliente.dart';
import 'package:crm_flutter/route/config.dart';
import 'package:crm_flutter/screens/Cadastro_cliente_screen.dart';
import 'package:crm_flutter/service/ClienteService.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ClienteListScreen extends StatefulWidget {
  @override
  _ClienteListScreenState createState() => _ClienteListScreenState();
}

class _ClienteListScreenState extends State<ClienteListScreen> {
  final dio = Dio();
  late final ClienteService clienteService;

  final TextEditingController _filtroController = TextEditingController();
  List<Cliente> _clientes = [];
  List<Cliente> _clientesFiltrados = [];

  @override
  void initState() {
    super.initState();
    dio.options.baseUrl = config.urlBase;
    clienteService = ClienteService(dio);
    _carregarClientes();
  }

  // Carrega os clientes da API
  Future<void> _carregarClientes() async {
    try {
      final clientes = await clienteService.listarClientes();
      setState(() {
        _clientes = clientes;
        _clientesFiltrados = clientes;
      });
    } catch (e) {
      // Exibe erro em um SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Erro ao carregar clientes, verifique conexão de dados, '
                    'e tente mais tarde!')),
      );
    }
  }

  // Filtra a lista de clientes com base no texto digitado
  void _filtrarClientes(String filtro) {
    setState(() {
      if (filtro.isEmpty) {
        _clientesFiltrados = _clientes;
      } else {
        _clientesFiltrados = _clientes
            .where((cliente) =>
                cliente.nomeFantasia
                    ?.toLowerCase()
                    .contains(filtro.toLowerCase()) ??
                false)
            .toList();
      }
    });
  }

  // Abre a tela de cadastro para novo cliente
  Future<void> _novoCliente() async {
    final novoCliente = await Navigator.push<Cliente>(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroClienteScreen(),
      ),
    );

    if (novoCliente != null) {
      // Atualiza a lista após inserir um novo cliente
      setState(() {
        _clientes.add(novoCliente);
        _clientesFiltrados = _clientes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de filtro com Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _filtroController,
                  decoration: const InputDecoration(
                    labelText: 'Filtrar clientes',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                  onChanged: _filtrarClientes,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Lista de clientes
            Expanded(
              child: _clientesFiltrados.isEmpty
                  ? const Center(
                      child: Text('Nenhum cliente encontrado'),
                    )
                  : ListView.builder(
                      itemCount: _clientesFiltrados.length,
                      itemBuilder: (context, index) {
                        final cliente = _clientesFiltrados[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(cliente.nomeFantasia ?? 'N/C'),
                            subtitle: Text(cliente.telefone ?? 'N/C'),
                            onTap: () async {
                              final clienteEditado =
                                  await Navigator.push<Cliente>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CadastroClienteScreen(cliente: cliente),
                                ),
                              );

                              // Atualiza a lista se o cliente foi editado
                              if (clienteEditado != null) {
                                setState(() {
                                  _clientes[index] = clienteEditado;
                                  _clientesFiltrados = _clientes;
                                });
                              }
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _novoCliente,
        child: const Icon(Icons.add),
        tooltip: 'Novo Cliente',
      ),
    );
  }
}
