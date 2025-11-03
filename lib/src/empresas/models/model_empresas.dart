import 'package:get/get.dart';

class Empresa extends GetxController {
  int id;
  String nome;
  String status;
  String cnpj;
  String abrev;
  String telefone;

  Empresa(
      {this.id = 0,
      this.nome = '',
      this.cnpj = '',
      this.abrev = '',
      this.status = '',
      this.telefone = ''});

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      id: json['Id'] as int,
      nome: json['Nome'] as String,
      status: json['Status'] as String,
      cnpj: json['CNPJ'] as String,
      abrev: json['Abrev'] as String,
      telefone: json['telefone'] as String,
    );
  }
}
