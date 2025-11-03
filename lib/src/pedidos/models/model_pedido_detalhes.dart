import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PedidoDetalhesModel extends GetxController {
  int id;
  String nome;
  String valortotalcomanda;
  String valortotalprodutoscomanda;
  String valortotaldescontocomanda;
  String obs;
  String descricao;
  String qtd;
  String valor;
  String desconto;
  String total;
  String dataemicao;
  String datafinalizado;
  String datafaturado;
  String status;
  int faturada;
  int qtditens;
  String gtin;
  int idProduto;
  double qtdDouble;
  String valorFrete;

  PedidoDetalhesModel({
    this.id = 0,
    this.nome = '',
    this.valortotalcomanda = '',
    this.valortotalprodutoscomanda = '',
    this.valortotaldescontocomanda = '',
    this.dataemicao = '',
    this.status = '',
    this.faturada = 0,
    this.obs = '',
    this.descricao = '',
    this.qtd = '',
    this.valor = '',
    this.desconto = '',
    this.total = '',
    this.datafinalizado = '',
    this.datafaturado = '',
    this.qtditens = 0,
    this.gtin = '',
    this.idProduto = 0,
    this.qtdDouble = 0.0,
    this.valorFrete = '',
  });

  factory PedidoDetalhesModel.fromJson(Map<String, dynamic> json) {
    return PedidoDetalhesModel(
      id: json['id'] as int,
      nome: json['nome'] as String,
      valortotalcomanda: json['valortotalcomanda'] as String,
      valortotalprodutoscomanda: json['valortotalprodutoscomanda'] as String,
      valortotaldescontocomanda: json['valortotaldescontocomanda'] as String,
      dataemicao: json['dataemicao'] as String,
      status: json['status'] as String,
      faturada: json['faturada'] as int,
      obs: json['obs'] as String,
      descricao: json['descricao'] as String,
      qtd: json['qtd'] as String,
      valor: json['valor'] as String,
      desconto: json['desconto'] as String,
      total: json['total'] as String,
      datafinalizado: json['datafinalizado'] as String,
      datafaturado: json['datafaturado'] as String,
      qtditens: json['qtditens'] as int,
      gtin: json['gtin'] as String,
      idProduto: json['Id_produto'] as int,
      qtdDouble: (json['qtdDouble'] is int)
          ? (json['qtdDouble'] as int).toDouble()
          : json['qtdDouble'] as double,
      valorFrete: json['ValorFrete'] as String,
    );
  }
}
