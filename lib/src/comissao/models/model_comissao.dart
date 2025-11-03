import 'package:get/get.dart';

class Comissao extends GetxController {
  String nome;
  String total;
  String data;

  Comissao({required this.nome, required this.total, required this.data});

  factory Comissao.fromJson(Map<String, dynamic> json) {
    return Comissao(
      nome: json['nome'],
      total: json['total'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'total': total,
      'data': data,
    };
  }
}
