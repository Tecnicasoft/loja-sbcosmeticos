import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class EnderecoEntregaModel extends GetxController {
  String nome;
  String endereco1;
  String endereco2;
  int idLoja;
  int distancia;
  int idLojaEntrega;
  bool entrega;

  EnderecoEntregaModel({
    this.nome = '',
    this.endereco1 = '',
    this.endereco2 = '',
    this.idLoja = 0,
    this.distancia = 0,
    this.idLojaEntrega = 0,
    this.entrega = false,
  });

  factory EnderecoEntregaModel.fromJson(Map<dynamic, dynamic> json) {
    return EnderecoEntregaModel(
      nome: json['nome'] as String,
      endereco1: json['endereco1'] as String,
      endereco2: json['endereco2'] as String,
      idLoja: json['IdLoja'] as int,
      distancia: (json['distancia'] as num).toInt(), // Converte float para int
      idLojaEntrega: json['idLojaEntrega'] as int,
      entrega: json['entrega'] as bool,
    );
  }
}
