class Especie {
  int id;
  String nome;
  String descricao;

  Especie({
    this.id = 0,
    this.nome = '',
    this.descricao = '',
  });

  factory Especie.fromJson(Map<String, dynamic> json) {
    return Especie(
      id: json['Id'] as int? ?? 0,
      nome: json['Nome'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Nome': nome,
    };
  }

  @override
  String toString() => nome;
}
