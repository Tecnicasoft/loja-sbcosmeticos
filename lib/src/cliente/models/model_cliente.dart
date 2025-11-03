import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ClienteModel extends GetxController {
  int id;
  String nome;
  // ignore: non_constant_identifier_names
  String CPF_CNPJ;

  ClienteModel({
    this.id = 0,
    this.nome = '',
    // ignore: non_constant_identifier_names
    this.CPF_CNPJ = '',
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      id: json['ID'] as int,
      nome: json['Nome'] as String,
      CPF_CNPJ: json['CPF_CNPJ'] as String,
    );
  }
}
