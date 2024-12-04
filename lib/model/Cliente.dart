class Cliente {
  final int? id;
  final bool inativo;
  final String? razaoSocial;
  final String? nomeFantasia;
  final String? cpfCnpj;
  final String? telefone;
  final String? cep;
  final String? endereco;
  final String? numero;
  final String? bairro;
  final String? complemento;
  final String? cidade;

  Cliente({
    this.id,
    this.inativo = false,
    this.razaoSocial,
    this.nomeFantasia,
    this.cpfCnpj,
    this.telefone,
    this.cep,
    this.endereco,
    this.numero,
    this.bairro,
    this.complemento,
    this.cidade,
  });

  // Método para converter de JSON para um objeto Cliente
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      inativo: json['inativo'] ?? false,
      razaoSocial: json['razaoSocial'],
      nomeFantasia: json['nomeFantasia'],
      cpfCnpj: json['cpfCnpj'],
      telefone: json['telefone'],
      cep: json['cep'],
      endereco: json['endereco'],
      numero: json['numero'],
      bairro: json['bairro'],
      complemento: json['complemento'],
      cidade: json['cidade'],
    );
  }

  // Método para converter um objeto Cliente para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inativo': inativo,
      'razaoSocial': razaoSocial,
      'nomeFantasia': nomeFantasia,
      'cpfCnpj': cpfCnpj,
      'telefone': telefone,
      'cep': cep,
      'endereco': endereco,
      'numero': numero,
      'bairro': bairro,
      'complemento': complemento,
      'cidade': cidade,
    };
  }
}
