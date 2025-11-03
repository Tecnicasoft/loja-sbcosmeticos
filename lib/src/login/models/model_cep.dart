class Cep {
  final String logradouro;
  final String bairro;
  final String uf;
  final String municipio;
  final int idmunicipio;

  Cep({
    this.logradouro = '',
    this.bairro = '',
    this.uf = '',
    this.municipio = '',
    this.idmunicipio = 0,
  });

  factory Cep.fromJson(Map<String, dynamic> json) {
    return Cep(
      logradouro: json['logradouro'] as String,
      bairro: json['bairro'] as String,
      uf: json['uf'] as String,
      municipio: json['municipio'] as String,
      idmunicipio: json['id_municipio'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logradouro': logradouro,
      'bairro': bairro,
      'uf': uf,
      'municipio': municipio,
      'id_municipio': idmunicipio,
    };
  }
}
