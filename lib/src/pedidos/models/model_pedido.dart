import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PedidoModel extends GetxController {
  int id;
  String nome;
  String cpfcnpj;
  String valor;
  String dataemicao;
  String status;
  int faturada;
  String obs;

  PedidoModel({
    this.id = 0,
    this.nome = '',
    this.cpfcnpj = '',
    this.valor = '',
    this.dataemicao = '',
    this.status = '',
    this.faturada = 0,
    this.obs = '',
  });

  factory PedidoModel.fromJson(Map<String, dynamic> json) {
    return PedidoModel(
      id: json['Id'] as int,
      nome: json['Nome'] as String,
      cpfcnpj: json['cpfcnpj'] as String,
      valor: json['Valor'] as String,
      dataemicao: json['DataEmissao'] as String,
      status: json['Status'] as String,
      faturada: json['Faturada'] as int,
      obs: json['Obs'] as String,
    );
  }
}
