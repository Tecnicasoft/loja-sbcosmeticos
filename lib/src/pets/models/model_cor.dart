class Cor {
  int id;
  String nome;

  Cor({
    this.id = 0,
    this.nome = '',
  });

  factory Cor.fromJson(Map<String, dynamic> json) {
    return Cor(
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
