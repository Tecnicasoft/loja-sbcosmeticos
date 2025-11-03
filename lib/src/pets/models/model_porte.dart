class Porte {
  int id;
  String nome;

  Porte({
    this.id = 0,
    this.nome = '',
  });

  factory Porte.fromJson(Map<String, dynamic> json) {
    return Porte(
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
