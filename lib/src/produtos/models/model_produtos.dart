import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ProdutosModel extends GetxController {
  int id;
  String codigo;
  String descricao;
  String status;
  String valorBruto;
  String valorPorDesconto;
  String valorFinal;
  int promoAtiva;
  String imagem;
  String utilidade;

  ProdutosModel({
    this.id = 0,
    this.codigo = '',
    this.descricao = '',
    this.status = '',
    this.valorBruto = '',
    this.valorPorDesconto = '',
    this.valorFinal = '',
    this.promoAtiva = 0,
    this.imagem = '',
    this.utilidade = '',
  });

  factory ProdutosModel.fromJson(Map<String, dynamic> json) {
    return ProdutosModel(
      id: json['ids'] as int,
      codigo: json['gtin'] as String,
      descricao: json['descricao'] as String,
      status: json['grupo'] as String,
      valorBruto: json['valorBruto'] as String,
      valorPorDesconto: json['valorPorDesconto'] as String,
      valorFinal: json['valorFinal'] as String,
      promoAtiva: json['promoAtiva'] as int,
      imagem: json['foto'] as String,
      utilidade: json['utilicacao'] as String? ?? '',
    );
  }
}
