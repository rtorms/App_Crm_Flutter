class Anotacao {
  final int? id;
  final DateTime? dataCadastro;
  final String? descricao;
  final int? idOportunidade;

  Anotacao({
    this.id,
    this.dataCadastro,
    this.descricao,
    this.idOportunidade,
  });

  // Método para converter de JSON para um objeto Anotacao
  factory Anotacao.fromJson(Map<String, dynamic> json) {
    return Anotacao(
      id: json['id'],
      dataCadastro: json['dataCadastro'] != null
          ? DateTime.parse(json['dataCadastro'])
          : null,
      descricao: json['descricao'],
      idOportunidade: json['idOportunidade'],
    );
  }

  // Método para converter um objeto Anotacao para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dataCadastro': dataCadastro?.toIso8601String(),
      'descricao': descricao,
      'idOportunidade': idOportunidade,
    };
  }
}
