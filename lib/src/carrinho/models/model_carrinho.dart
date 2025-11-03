import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CarrinhoModel extends GetxController {
  int id;
  String valorBruto;
  String valorPorDesconto;
  String valorFinal;
  int qtd;
  String total;
  String descricao;
  String imagem;
  String? nomeCliente;
  int promoAtiva;
  String obs;
  String codigo;
  int promoPrimeiraCompra;
  String valTotDesc;
  int valorMinimoFreteEntrega;
  int valorFretePadrao;

  CarrinhoModel({
    this.id = 0,
    this.valorBruto = '',
    this.valorPorDesconto = '',
    this.valorFinal = '',
    this.qtd = 0,
    this.total = '',
    this.descricao = '',
    this.imagem = '',
    this.nomeCliente = '',
    this.promoAtiva = 0,
    this.obs = '',
    this.codigo = '',
    this.promoPrimeiraCompra = 0,
    this.valTotDesc = '',
    this.valorMinimoFreteEntrega = 0,
    this.valorFretePadrao = 0,
  });

  factory CarrinhoModel.fromJson(Map<dynamic, dynamic> json) {
    return CarrinhoModel(
      id: json['Id'] as int,
      valorBruto: json['valorBruto'] as String,
      valorPorDesconto: json['valorPorDesconto'] as String,
      valorFinal: json['valorFinal'] as String,
      qtd: int.parse(json['qtd'].toString()),
      total: json['total'],
      descricao: json['descricao'] as String,
      imagem: json['foto'] as String,
      nomeCliente: json['nomeCliente'] as String?,
      promoAtiva: json['promoAtiva'] as int,
      obs: json['obs'] as String,
      codigo: json['gtin'] as String,
      promoPrimeiraCompra: json['promoPrimeiraCompra'] as int,
      valTotDesc: json['ValTotDesc'] as String,
      valorMinimoFreteEntrega: json['ValorMinimoFreteEntrega'] as int,
      valorFretePadrao: json['ValorPadraoFreteEntrega'] as int,
    );
  }
}
