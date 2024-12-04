class Cep {
  final String cep;
  final String logradouro;
  final String bairro;
  final String cidade;
  final String uf;

  // Construtor
  Cep({
    this.cep = '',
    this.logradouro = '',
    this.bairro = '',
    this.cidade = '',
    this.uf = '',
  });

  // Método para gerar a cidade-uf
  String get cidadeUf => '$cidade - $uf';

  // Método para converter de JSON para objeto Cep (caso você receba dados de uma API)
  factory Cep.fromJson(Map<String, dynamic> json) {
    return Cep(
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      bairro: json['bairro'] ?? '',
      cidade: json['localidade'] ?? '', // Equivalente ao "localidade" em Kotlin
      uf: json['uf'] ?? '',
    );
  }

  // Método para converter o objeto Cep para JSON (caso precise enviar para uma API)
  Map<String, dynamic> toJson() {
    return {
      'cep': cep,
      'logradouro': logradouro,
      'bairro': bairro,
      'localidade': cidade, // "localidade" como chave no JSON
      'uf': uf,
    };
  }
}
