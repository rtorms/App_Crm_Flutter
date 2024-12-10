import 'package:crm_flutter/model/Anotacao.dart';
import 'package:crm_flutter/model/Cliente.dart';
import 'package:crm_flutter/model/Oportunidade.dart';
import 'package:crm_flutter/route/config.dart';
import 'package:crm_flutter/screens/AnotacoesScreen.dart';
import 'package:crm_flutter/service/ClienteService.dart';
import 'package:crm_flutter/service/OportunidadeService.dart';
import 'package:crm_flutter/util/EnumSituacaoOportunidade.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CadastroOportunidadeScreen extends StatefulWidget {
  final Oportunidade? oportunidade;

  const CadastroOportunidadeScreen({Key? key, this.oportunidade})
      : super(key: key);

  @override
  _CadastroOportunidadeScreenState createState() =>
      _CadastroOportunidadeScreenState();
}

class _CadastroOportunidadeScreenState
    extends State<CadastroOportunidadeScreen> {
  late final TextEditingController _descricaoController;
  late final TextEditingController _valorController;
  late EnumSituacaoOportunidade _situacaoSelecionada;
  Cliente? _clienteSelecionado;
  List<Cliente> _clientes = [];
  late final OportunidadeService _oportunidadeService;
  late final ClienteService _clienteService;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    dio.options.baseUrl = config.urlBase;

    _oportunidadeService = OportunidadeService(dio);
    _clienteService = ClienteService(dio);

    _descricaoController =
        TextEditingController(text: widget.oportunidade?.descricao ?? '');
    _valorController = TextEditingController(
        text: widget.oportunidade?.valor?.toString() ?? '');
    _situacaoSelecionada = EnumSituacaoOportunidade.fromValue(
        widget.oportunidade?.situacaoOportunidade ?? 0);
    _clienteSelecionado = null;

    _carregarAnotacoes();
    _carregarClientes();
  }

  Future<void> _carregarAnotacoes() async {
    if (widget.oportunidade == null || widget.oportunidade!.id == null) {
      print('Oportunidade ou ID não disponível para carregar anotações');
      return;
    }
    try {
      final Oportunidade opt =
          await _oportunidadeService.findById(widget.oportunidade!.id!);
      setState(() {
        widget.oportunidade?.anotacoes = opt.anotacoes;
      });
    } catch (e) {
      print('Erro ao carregar anotações: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar anotações: $e')),
      );
    }
  }

  Future<void> _carregarClientes() async {
    try {
      final clientes = await _clienteService.listarClientes();
      setState(() {
        _clientes = clientes;
        if (widget.oportunidade?.idCliente != null) {
          _clienteSelecionado = _clientes.firstWhere(
              (c) => c.id == widget.oportunidade!.idCliente,
              orElse: () => Cliente());
        }
      });
    } catch (e) {
      print('Erro ao carregar clientes: $e');
    }
  }

  Future<void> _salvarOportunidade() async {
    final oportunidade = Oportunidade(
      id: widget.oportunidade?.id,
      descricao: _descricaoController.text,
      situacaoOportunidade: _situacaoSelecionada.value,
      idCliente: _clienteSelecionado?.id,
      nomeCliente: _clienteSelecionado?.nomeFantasia,
      valor: double.tryParse(_valorController.text),
      anotacoes: widget.oportunidade?.anotacoes,
    );

    try {
      final savedOpt = await _oportunidadeService.save(oportunidade);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Oportunidade salva com sucesso!')),
      );
      Navigator.pop(context, savedOpt);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar oportunidade: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Oportunidade'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Campo de Descrição
              TextField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              const SizedBox(height: 16),
              // Dropdown para Situação
              DropdownButton<EnumSituacaoOportunidade>(
                value: _situacaoSelecionada,
                isExpanded: true,
                items: EnumSituacaoOportunidade.values.map((situacao) {
                  return DropdownMenuItem<EnumSituacaoOportunidade>(
                    value: situacao,
                    child: Text(situacao.descricao),
                  );
                }).toList(),
                onChanged: (situacao) {
                  setState(() {
                    _situacaoSelecionada = situacao!;
                  });
                },
                hint: const Text('Selecione a situação'),
              ),
              const SizedBox(height: 16),
              // Dropdown para Cliente
              DropdownButton<Cliente?>(
                value: _clienteSelecionado,
                isExpanded: true,
                items: _clientes.map((cliente) {
                  return DropdownMenuItem<Cliente?>(
                    value: cliente,
                    child: Text(cliente.nomeFantasia ?? ''),
                  );
                }).toList(),
                onChanged: (cliente) {
                  setState(() {
                    _clienteSelecionado = cliente!;
                  });
                },
                hint: const Text('Selecione o cliente'),
              ),
              const SizedBox(height: 16),
              // Campo de Valor
              TextField(
                controller: _valorController,
                decoration: const InputDecoration(labelText: 'Valor'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  // Formatar com ponto decimal, permitindo dois dígitos decimais
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    // Retirar caracteres não numéricos e permitir apenas números e ponto
                    String newText =
                        newValue.text.replaceAll(RegExp('[^0-9.]'), '');
                    if (newText.contains('.') &&
                        newText.indexOf('.') != newText.lastIndexOf('.')) {
                      // Permite apenas um ponto decimal
                      newText = newText.substring(0, newText.lastIndexOf('.'));
                    }
                    return TextEditingValue(
                      text: newText,
                      selection:
                          TextSelection.collapsed(offset: newText.length),
                    );
                  })
                ],
              ),

              const SizedBox(height: 20),
              // Botão de salvar
              ElevatedButton(
                onPressed: _salvarOportunidade,
                child: const Text('Salvar Oportunidade'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final novasAnotacoes = await Navigator.push<List<Anotacao>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnotacoesScreen(
                        anotacoes: widget.oportunidade?.anotacoes ?? [],
                        idOportunidade: widget.oportunidade?.id ?? 0,
                        nomeCliente: _clienteSelecionado?.nomeFantasia ?? "",
                      ),
                    ),
                  );

                  // Atualizar as anotações no objeto oportunidade, se houver retorno
                  if (novasAnotacoes != null) {
                    setState(() {
                      widget.oportunidade?.anotacoes = novasAnotacoes;
                    });
                  }
                },
                child: const Text('Visualizar Anotações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
