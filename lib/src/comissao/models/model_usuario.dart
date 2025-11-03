import 'package:get/get.dart';

class Usuario extends GetxController {
  String nome;
  String nomecompleto;
  int id;

  Usuario({required this.nome, required this.nomecompleto, required this.id});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nome: json['nome'] as String,
      nomecompleto: json['nomecompleto'] as String,
      id: json['id'] as int,
    );
  }
}

// {
// 		"porcomicao": "0.00",
// 		"loja": "TUDO PARA PET RN",
// 		"perfil": "Administrador",
// 		"email": "a@a.com",
// 		"bloqueado": "NAO",
// 		"id": 1,
// 		"nome": "Admin",
// 		"nomecompleto": "Admin"
// 	},