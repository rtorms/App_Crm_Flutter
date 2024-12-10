import 'package:crm_flutter/model/Oportunidade.dart';
import 'package:crm_flutter/route/config.dart';
import 'package:crm_flutter/screens/Cadastro_Oportunidade_screen.dart';
import 'package:crm_flutter/service/OportunidadeService.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class OportunidadeListScreen extends StatefulWidget {
  @override
  _OportunidadeListScreenState createState() => _OportunidadeListScreenState();
}

class _OportunidadeListScreenState extends State<OportunidadeListScreen> {
  final dio = Dio();
  late final OportunidadeService oportunidadeService;

  final TextEditingController _filtroController = TextEditingController();
  List<Oportunidade> _oportunidades = [];
  List<Oportunidade> _oportunidadesFiltradas = [];

  @override
  void initState() {
    super.initState();
    dio.options.baseUrl = config.urlBase;
    oportunidadeService = OportunidadeService(dio);
    _carregarOportunidades();
  }

  // Carrega as Oportunidades da API
  Future<void> _carregarOportunidades() async {
    try {
      final oportunidades = await oportunidadeService.listarOportunidades();
      setState(() {
        _oportunidades = oportunidades;
        _oportunidadesFiltradas = oportunidades;
      });
    } catch (e) {
      // Exibe erro em um SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Erro ao carregar Oportunidades, verifique a conexão e tente mais tarde!')),
      );
    }
  }

  // Filtra a lista de Oportunidades com base no texto digitado
  void _filtrarOportunidades(String filtro) {
    setState(() {
      if (filtro.isEmpty) {
        _oportunidadesFiltradas = _oportunidades;
      } else {
        _oportunidadesFiltradas = _oportunidades
            .where((oportunidade) =>
                oportunidade.descricao
                    ?.toLowerCase()
                    .contains(filtro.toLowerCase()) ??
                false)
            .toList();
      }
    });
  }

  // Abre a tela de cadastro para nova Oportunidade
  Future<void> _novaOportunidade() async {
    final novaOportunidade = await Navigator.push<Oportunidade>(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroOportunidadeScreen(),
      ),
    );

    if (novaOportunidade != null) {
      // Atualiza a lista após inserir um novo Oportunidade
      setState(() {
        _oportunidades.add(novaOportunidade);
        _oportunidadesFiltradas = _oportunidades;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Oportunidades')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de filtro
            TextField(
              controller: _filtroController,
              decoration: const InputDecoration(
                labelText: 'Filtrar Oportunidades',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filtrarOportunidades,
            ),
            const SizedBox(height: 16),
            // Lista de Oportunidades
            Expanded(
              child: _oportunidadesFiltradas.isEmpty
                  ? const Center(
                      child: Text('Nenhuma Oportunidade encontrada'),
                    )
                  : ListView.builder(
                      itemCount: _oportunidadesFiltradas.length,
                      itemBuilder: (context, index) {
                        final oportunidade = _oportunidadesFiltradas[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(oportunidade.descricao ?? 'N/C'),
                            subtitle: Text(oportunidade.nomeCliente ?? 'N/C'),
                            onTap: () async {
                              final oportunidadeEditada =
                                  await Navigator.push<Oportunidade>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CadastroOportunidadeScreen(
                                          oportunidade: oportunidade),
                                ),
                              );

                              // Atualiza a lista se o Oportunidade foi editada
                              if (oportunidadeEditada != null) {
                                setState(() {
                                  _oportunidades[index] = oportunidadeEditada;
                                  _oportunidadesFiltradas = _oportunidades;
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
        onPressed: _novaOportunidade,
        child: const Icon(Icons.add),
        tooltip: 'Nova Oportunidade',
      ),
    );
  }
}
