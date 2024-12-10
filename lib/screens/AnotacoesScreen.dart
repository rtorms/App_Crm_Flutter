import 'package:crm_flutter/model/Anotacao.dart';
import 'package:crm_flutter/service/AgendaService.dart';
import 'package:flutter/material.dart';

class AnotacoesScreen extends StatefulWidget {
  final List<Anotacao> anotacoes;
  final int idOportunidade;
  final String nomeCliente;

  const AnotacoesScreen({
    Key? key,
    required this.anotacoes,
    required this.idOportunidade,
    required this.nomeCliente,
  }) : super(key: key);

  @override
  _AnotacoesScreenState createState() => _AnotacoesScreenState();
}

class _AnotacoesScreenState extends State<AnotacoesScreen> {
  late List<Anotacao> _anotacoes;
  late TextEditingController _novaAnotacaoController;
  late String _nomeCliente;

  @override
  void initState() {
    super.initState();
    _anotacoes =
        List.from(widget.anotacoes); // Copiar para evitar alterações diretas
    _novaAnotacaoController = TextEditingController();
    _nomeCliente = widget.nomeCliente;
  }

  void _adicionarAnotacao() {
    final descricao = _novaAnotacaoController.text.trim();
    if (descricao.isEmpty) return;

    setState(() {
      _anotacoes.add(Anotacao(
        dataCadastro: DateTime.now(),
        descricao: descricao,
        idOportunidade: widget.idOportunidade,
      ));
    });

    _novaAnotacaoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anotações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Retorna a lista atualizada para a tela anterior
              Navigator.pop(context, _anotacoes);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Lista de Anotações
            Expanded(
              child: ListView.builder(
                itemCount: _anotacoes.length,
                itemBuilder: (context, index) {
                  final anotacao = _anotacoes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(anotacao.descricao ?? ''),
                      subtitle: Text(
                        'Criado em: ${anotacao.dataCadastro?.toLocal().toString().substring(0, 19)}',
                      ),
                    ),
                  );
                },
              ),
            ),
            // Campo para adicionar nova anotação
            TextField(
              controller: _novaAnotacaoController,
              decoration: const InputDecoration(
                labelText: 'Nova Anotação',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _adicionarAnotacao,
              child: const Text('Adicionar Anotação'),
            ),
            ElevatedButton(
              onPressed: () async {
                await AgendaService.adicionarEvento(
                  titulo: "Compromisso com cliente: ${_nomeCliente}  ",
                  descricao: _novaAnotacaoController.text,
                  inicio: DateTime.now(),
                  fim: DateTime.now().add(Duration(hours: 1)),
                );
              },
              child: Text('Adicionar na Agenda'),
            )
          ],
        ),
      ),
    );
  }
}
