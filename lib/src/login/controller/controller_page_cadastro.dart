import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:petshop_template/src/login/models/model_cep.dart';
import 'package:petshop_template/src/login/models/model_cliente.dart';
import 'package:petshop_template/src/shared/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CadastroController extends GetxController {
  final uri = Util.uri;
  //final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _enderecoController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<String> alteraSenhaCliente(String senhaAtual, String senhaNova) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    String guidCliente = prefs.getString('guidCliente').toString();

    if (senhaAtual == senhaNova) {
      return "Senha atual e nova são iguais";
    }

    var params = {
      "guid": guidCliente,
      "senhaAtual": Util.encryptWithKey(senhaAtual),
      "senhaNova": Util.encryptWithKey(senhaNova)
    };

    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/clientes/alteraSenhaApp'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
        return "OK";
      }
      if (response.statusCode == 401) {
        return "Senha atual incorreta";
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> alteraCadastroClienteCancelamentoConta() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    String guidCliente = prefs.getString('guidCliente').toString();

    var params = {
      "guid": guidCliente,
    };

    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/clientes/alteraCadastroClienteAppCancelamentoConta'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
        return "OK";
      }
      if (response.statusCode == 401) {
        return "Senha atual incorreta";
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> cadastroCliente(Cliente cliente, bool isEdit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    var guidCliente = prefs.getString('guidCliente').toString();
    var uuid = const Uuid();
    bool achouCPF = false;
    bool achouEmail = false;
    String guidClienteAchado = '';
    String guid = uuid.v4();
    bool isCpfExistEmailNot = false;
    String uriAdress = '';

    if (cliente.cpf != cliente.cpfInicial) {
      guidClienteAchado = await verificaCPFcliente(cliente.cpf);
      if (guidClienteAchado.isNotEmpty) {
        achouCPF = true;
      }
    }

    if (cliente.email != cliente.emailInicial) {
      if (await verificaEmailcliente(cliente.email, guidClienteAchado)) {
        achouEmail = true;
      }
    }

    if (achouCPF && achouEmail) {
      return "CPF e Email já cadastrados, utilize a opção de recuperar senha";
    } else if (achouCPF && isEdit) {
      return "CPF já cadastrado";
    } else if (achouCPF && !achouEmail) {
      isCpfExistEmailNot = true;
    } else if (achouEmail) {
      return "Email já cadastrado";
    }

    if (isEdit) {
      uriAdress = 'alteraCadastroClienteApp?id=$guidCliente';
    } else if (isCpfExistEmailNot) {
      guid = guidClienteAchado;
      uriAdress = 'alteraCadastroClienteCadastraLoginApp?id=$guidClienteAchado';
    } else {
      uriAdress = 'cadastoCliente';
    }

    var params = {
      "nome": cliente.nome,
      "razaoSocial": "",
      "cpf_cnpj": cliente.cpf,
      "rg": "",
      "ie": "",
      "im": "",
      "sexo": cliente.sexo,
      "estadoCivil": "Solteiro(a)",
      "rua_n": cliente.numero,
      "rua": cliente.endereco,
      "bairro": cliente.bairro,
      "cep": cliente.cep,
      "cidade": cliente.cidade,
      "complemento": cliente.complemento,
      "status": "A",
      "tipo": "F",
      "guid": guid,
      "dataNascimento": cliente.dataNascimento,
      "Idtelefone": cliente.idTelefone,
      "clienteApp": {
        "email": cliente.email,
        "senha": isEdit ? '' : Util.encryptWithKey(cliente.senha),
        "telefone": cliente.telefone,
        "guid": guid
      }
    };

    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/clientes/$uriAdress'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
        return "OK";
      } else {
        if (response.statusCode == 500) {
          var responseBody = json.decode(response.body);
          if (responseBody['name'] == 'SequelizeUniqueConstraintError') {
            return "Email já cadastrado";
          }
        }
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> verificaCPFcliente(String cpf) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    var params = {"cpf_cnpj": cpf.replaceAll(".", "").replaceAll("-", "")};

    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/clientes/verificaCPFcadastrado'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
        bool resposta = json.decode(response.body)['exists'];
        String guid = json.decode(response.body)['Guid'];
        //json.decode(token)['token'];
        if (resposta) {
          return guid;
        } else {
          return "";
        }
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> verificaEmailcliente(String email, String guid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    var params = {"email": email, "guid": guid};

    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/clientes/verificaEmailcadastrado'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
        bool resposta = json.decode(response.body)['exists'];
        //json.decode(token)['token'];
        if (resposta) {
          return true;
        } else {
          return false;
        }
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Cep> consultaCep(String cep) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    var params = {"cep": cep.replaceAll("-", "")};

    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/clientes/consultaCep'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
        return Cep.fromJson(json.decode(response.body));
      } else {
        var decodedBody = json.decode(response.body)['error'];
        return Future.error(decodedBody.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Cliente> consultaCliente(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    http.Client client = http.Client();
    final response = await client.get(
      Uri.parse('$uri/clientes/retornaCliente?id=$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    try {
      if (response.statusCode == 200) {
        return Cliente.fromJson(json.decode(response.body).first);
      } else {
        throw Exception('Erro ao buscar cliente');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> verificaEmailCpfCadastrado(String cpf, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    var params = {
      "email": email,
      "cpf_cnpj": cpf.replaceAll(".", "").replaceAll("-", "")
    };

    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/clientes/verificaCpfEmailRecuperarSenha'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        if (responseBody.containsKey('codigo') &&
            responseBody['codigo'].isNotEmpty) {
          await prefs.setString(
              'codigoClienteSenhaRecupera', responseBody['codigo']);
          await prefs.setString(
              'GuidClienteSenhaRecupera', responseBody['Guid']);
          return "OK";
        } else {
          return "NOTOK";
        }
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> enviaEmailSenhaRecuperadaNova(
      String email, String guidCliente) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    var params = {"email": email, "guid": guidCliente};

    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/clientes/enviaEmailSenhaRecuperadaNova'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
        return "OK";
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  List<Cliente> parseClientes(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Cliente>((json) => Cliente.fromJson(json)).toList();
  }
}
