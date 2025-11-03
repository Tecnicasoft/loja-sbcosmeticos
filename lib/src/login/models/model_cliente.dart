import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Cliente extends GetxController {
  int id;
  int idTelefone;
  String nome;
  String cpf;
  String cpfInicial;
  String emailInicial;
  String endereco;
  String telefone;
  String email;
  String senha;
  String cep;
  String numero;
  String complemento;
  String bairro;
  String cidade;
  String estado;
  int cidadeId;
  String sexo;
  String dataNascimento;

  Cliente({
    this.id = 0,
    this.idTelefone = 0,
    this.nome = '',
    this.cpf = '',
    this.cpfInicial = '',
    this.emailInicial = '',
    this.endereco = '',
    this.telefone = '',
    this.email = '',
    this.senha = '',
    this.cep = '',
    this.numero = '',
    this.complemento = '',
    this.bairro = '',
    this.cidade = '',
    this.estado = '',
    this.cidadeId = 0,
    this.sexo = '',
    this.dataNascimento = '',
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['ID'] as int,
      idTelefone: json['Idtelefone'] as int,
      nome: json['Nome'] as String,
      cpf: json['CPF_CNPJ'] as String,
      endereco: json['Rua'] as String,
      telefone: json['telefone'] as String,
      email: json['email'] as String,
      cep: json['CEP'] as String,
      numero: json['Rua_N'] as String,
      complemento: json['complemento'] as String,
      bairro: json['Bairro'] as String,
      cidade: json['nome_municipio'] as String,
      estado: json['nome_uf'] as String,
      cidadeId: json['cidadeId'] as int,
      sexo: json['Sexo'] as String,
      dataNascimento: json['DataNascimento'] as String,
    );
  }
}
