import 'package:get/get.dart';

class EmpresaFormat extends GetxController {
  int id;
  String nome;
  String status;
  String cnpj;
  String abrev;
  String telefone;
  String enderecoLinha1;
  String enderecoLinha2;

  EmpresaFormat(
      {this.id = 0,
      this.nome = '',
      this.cnpj = '',
      this.abrev = '',
      this.status = '',
      this.telefone = '',
      this.enderecoLinha1 = '',
      this.enderecoLinha2 = ''});

  factory EmpresaFormat.fromJson(Map<String, dynamic> json) {
    return EmpresaFormat(
      id: json['Id'] as int,
      nome: json['Nome'] as String,
      status: json['Status'] as String,
      cnpj: json['CNPJ'] as String,
      abrev: json['Abrev'] as String,
      telefone: json['telefone'] as String,
      enderecoLinha1: json['enderecoLinha1'] as String,
      enderecoLinha2: json['enderecoLinha2'] as String,
    );
  }
}
