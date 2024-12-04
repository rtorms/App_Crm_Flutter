import 'Anotacao.dart';

class Oportunidade {
  final int? id;
  final DateTime? dataCadastro;
  final DateTime? dataConquistaPerda;
  final String? descricao;
  final int? situacaoOportunidade;
  final int? idCliente;
  final double? valor;
  final String? nomeCliente;
  List<Anotacao>? anotacoes;

  Oportunidade({
    this.id,
    this.dataCadastro,
    this.dataConquistaPerda,
    this.descricao,
    this.situacaoOportunidade,
    this.idCliente,
    this.valor,
    this.nomeCliente,
    this.anotacoes,
  });

  // Método para converter de JSON para um objeto Oportunidade
  factory Oportunidade.fromJson(Map<String, dynamic> json) {
    return Oportunidade(
      id: json['id'],
      dataCadastro: json['dataCadastro'] != null
          ? DateTime.parse(json['dataCadastro'])
          : null,
      dataConquistaPerda: json['dataConquistaPerda'] != null
          ? DateTime.parse(json['dataConquistaPerda'])
          : null,
      descricao: json['descricao'],
      situacaoOportunidade: json['situacaoOportunidade'],
      idCliente: json['idCliente'],
      valor: json['valor'] != null ? (json['valor'] as num).toDouble() : null,
      nomeCliente: json['nomeCliente'],
      anotacoes: json['anotacoes'] != null
          ? (json['anotacoes'] as List)
              .map((e) => Anotacao.fromJson(e))
              .toList()
          : null,
    );
  }

  // Método para converter um objeto Oportunidade para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dataCadastro': dataCadastro?.toIso8601String(),
      'dataConquistaPerda': dataConquistaPerda?.toIso8601String(),
      'descricao': descricao,
      'situacaoOportunidade': situacaoOportunidade,
      'idCliente': idCliente,
      'valor': valor,
      'nomeCliente': nomeCliente,
      'anotacoes': anotacoes?.map((e) => e.toJson()).toList(),
    };
  }
}
