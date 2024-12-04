enum EnumSituacaoOportunidade {
  desconhecida(0, 'Desconhecida'),
  aberta(1, 'Aberta'),
  conquistada(2, 'Conquistada'),
  perdida(3, 'Perdida');

  final int value;
  final String descricao;

  const EnumSituacaoOportunidade(this.value, this.descricao);

  // Busca um enum pelo valor associado
  static EnumSituacaoOportunidade fromValue(int? value) {
    return EnumSituacaoOportunidade.values.firstWhere(
      (e) => e.value == value,
      orElse: () => EnumSituacaoOportunidade.desconhecida, // Valor padrão
    );
  }

  // Lista de descrições (para autocomplete)
  static List<String> get descricoes =>
      EnumSituacaoOportunidade.values.map((e) => e.descricao).toList();

  // Busca um enum pela descrição
  static EnumSituacaoOportunidade fromDescricao(String descricao) {
    return EnumSituacaoOportunidade.values.firstWhere(
      (e) => e.descricao == descricao,
      orElse: () => EnumSituacaoOportunidade.desconhecida,
    );
  }
}
