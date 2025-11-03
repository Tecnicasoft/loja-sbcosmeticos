import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/routes/app_pages.dart';
import 'package:petshop_template/src/shared/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final uri = Util.uri;
  bool isLoading = false;

  Future<void> verificaLoginUsuario(bool tempUser) async {
    String login;
    String password;
    String loja =
        ConfigApp.nomeBancoDados; //'testeappcliente'; //'tudoparapet';
    String usuariaAvulso = 'consumidorfinal';
    String senha = Util.encryptWithKey('1q2w3e4r');

    if (tempUser) {
      login = usuariaAvulso;
      password = senha;
    } else {
      if (userController.text.trim().isEmpty ||
          passwordController.text.trim().isEmpty) {
        Util.callMessageSnackBar("Usuário ou senha não podem estar vazios!");
        return;
      }

      login = userController.text.trim();
      password = Util.encryptWithKey(passwordController.text.trim());
    }

    User user = User(login: login, password: password);
    var params = {"login": user.login, "senha": user.password, "loja": loja};
    String body = json.encode(params);

    try {
      http.Response response = await http
          .post(
            Uri.parse('$uri/token/generateTokenCliente'),
            headers: {"Content-Type": "application/json"},
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        await storeToken(response.body, user.login, tempUser)
            .then((value) async {
          if (!tempUser) await updateIdclienteCarrinho();
        }).then((value) {
          Get.offAllNamed(PageRoutes.baseRoute, arguments: {'index': 0});
        });
      } else {
        Util.callMessageSnackBar(response.body);
      }
    } catch (e) {
      Util.callMessageSnackBar("Erro ao tentar conectar com o servidor!");
    }
  }

  Future storeToken(String token, String nameUser, bool tempUser) async {
    String tokenString = json.decode(token)['token'];
    int idUsuarioString = json.decode(token)['idUsuario'];
    int usuarioMultiLoja = json.decode(token)['usuarioMultiLoja'];
    int idEmpresa = json.decode(token)['idEmpresa'];
    String guidCliente = json.decode(token)['guidCliente'];
    String nomeCompletoCliente = json.decode(token)['nomeCompletoCliente'];
    String nomeCompletoEmpresa = json.decode(token)['nomeCompletoEmpresa'];
    String clientePrimeiraCompra = json.decode(token)['clientePrimeiraCompra'];
    String valorPorcentagemDescontoPrimeiraCompra =
        json.decode(token)['valorPorcentagemDescontoPrimeiraCompra'];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', tokenString);
    await prefs.setString('idUsuario', idUsuarioString.toString());
    await prefs.setString('idLoja', idEmpresa.toString());
    await prefs.setString('isLoggedInUser', 'true');
    await prefs.setString('usuarioMultiLoja', usuarioMultiLoja.toString());
    await prefs.setString('nomeUsuario', nameUser);
    await prefs.setString('guidCliente', guidCliente);
    await prefs.setString('nomeCompletoCliente', nomeCompletoCliente);
    await prefs.setString('nomeCompletoEmpresa', nomeCompletoEmpresa);
    await prefs.setString('clienteJaFezCompra', clientePrimeiraCompra);
    await prefs.setString('valorPorcentagemDescontoPrimeiraCompra',
        valorPorcentagemDescontoPrimeiraCompra);

    if (tempUser) {
      await prefs.setString('tempUser', 'true');
      await prefs.setString('clienteJaFezCompra', 'true');
    } else {
      await prefs.setString('tempUser', 'false');
    }
  }

  Future<void> updateIdclienteCarrinho() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idCliente = prefs.getString('idUsuario').toString();
    String tokenMobile = prefs.getString('tokenMobile').toString();
    String token = prefs.getString('token').toString();

    var params = {"idCliente": idCliente, "tokenMobile": tokenMobile};
    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/carrinhoapp/atualizaIdclienteCarrinho'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception();
    }
  }

  Future<void> gotoRecovey() async {
    Get.toNamed('/recovery', arguments: userController.text.trim());
  }

  Future<void> gotoRegister() async {
    Get.toNamed('/register');
  }
}

class User {
  final String login;
  final String password;

  User({required this.login, required this.password});
}
