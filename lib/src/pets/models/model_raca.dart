class Raca {
  int id;
  String nome;

  Raca({
    this.id = 0,
    this.nome = '',
  });

  factory Raca.fromJson(Map<String, dynamic> json) {
    return Raca(
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
