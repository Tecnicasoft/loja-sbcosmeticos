import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:pointycastle/export.dart' as pc;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// A utility class that provides various helper methods.
abstract class Util {
  /// Gets the URI from the configuration.
  static String get uri => ConfigApp.retornaUrlAPI('URI');

  /// Retrieves a value from the configuration based on the provided key.
  //static String _get(String key) => dotenv.env[key] ?? '';
  //static String _get(String key) => "http://15.228.219.52:3001";
  //static String _retornaUrlAPI(String key) => "http://192.168.56.1:3000";
  //static String _get(String key) =>
  //    "http://lb-tecnicasoft-1224673766.sa-east-1.elb.amazonaws.com:3000";

  /// Checks if a user is logged in.
  ///
  /// Returns `true` if a user is logged in, otherwise `false`.
  static Future<bool> verificaSemUsuarioEstaLogado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? isLoggedInUser = prefs.getString('isLoggedInUser');
    if (isLoggedInUser == 'true') {
      //Get.offAndToNamed(PageRoutes.baseRoute);
      return true;
    }
    return false;
  }

  /// Checks if a temporary user is logged in.
  ///
  /// Returns `true` if a temporary user is logged in, otherwise `false`.
  static Future<bool> verificaSemUsuarioAvulsoEstaLogado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tempUser = prefs.getString('tempUser');
    if (tempUser == 'true') {
      return true;
    }
    return false;
  }

  /// Verifies or creates a token for the mobile application.
  static Future<void> verificaOuCriaToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('tokenMobile');
    if (token == null) {
      var uuid = const Uuid();
      token = uuid.v4();
      await prefs.setString('tokenMobile', token);
    }
  }

  /// Encrypts the given plaintext using a predefined key.
  ///
  /// Returns the encrypted text as a base64 encoded string.
  static String encryptWithKey(String plaintext) {
    var keyString = "12345";

    // Gerar a chave MD5 e expandi-la
    var key = pc.MD5Digest().process(utf8.encode(keyString));
    var keyBytes = key + key.sublist(0, 8); // Expandir para 24 bytes

    // Configurar o TripleDES com ECB e PKCS7
    final keyParam = pc.KeyParameter(Uint8List.fromList(keyBytes));
    final params = pc.PaddedBlockCipherParameters<pc.KeyParameter, Null>(
        keyParam, null); // ECB não usa IV
    final padding = pc.PKCS7Padding();
    final cipher =
        pc.PaddedBlockCipherImpl(padding, pc.ECBBlockCipher(pc.DESedeEngine()))
          ..init(true, params);

    // Criptografar o texto
    var textBytes = utf8.encode(plaintext);
    var encryptedBytes = cipher.process(Uint8List.fromList(textBytes));

    // Converter para base64
    var base64String = base64.encode(encryptedBytes);
    return base64String;
  }

  /// Displays a snackbar message.
  ///
  /// [msg] is the message to display.
  /// [duracaoMensagem] is the duration of the message in seconds (default is 3 seconds).
  static Future<void> callMessageSnackBar1(String msg,
      {int duracaoMensagem = 3}) async {
    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: Duration(seconds: duracaoMensagem),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: '',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }
  }

  static Future<void> callMessageSnackBar(String msg,
      {int duracaoMensagem = 3}) async {
    if (Get.context != null) {
      Get.snackbar(
        'Atenção',
        msg,
        backgroundColor: CustomColors.colorBottonCompra,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        icon: const Icon(
          Icons.info,
          color: Colors.white,
        ),
      );
    }
  }

  /// Formats a CPF string.
  ///
  /// [cpf] is the CPF string to format.
  /// Returns the formatted CPF string.
  static String formatCpf(String cpf) {
    if (cpf.length == 11) {
      return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9, 11)}';
    } else {
      return cpf;
    }
  }

  /// Formats a CEP string.
  ///
  /// [cep] is the CEP string to format.
  /// Returns the formatted CEP string.
  static String formatCep(String cep) {
    if (cep.length == 8) {
      return '${cep.substring(0, 5)}-${cep.substring(5, 8)}';
    } else {
      return cep;
    }
  }

  /// Converts a date string to a date in full text.
  ///
  /// [data] is the date string in the format 'dd/MM/yyyy'.
  /// Returns the date in full text format.
  static String convertirDataParaDataExtenso(String data) {
    List<String> meses = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro'
    ];

    List<String> partes = data.split('/');
    if (partes.length != 3) {
      throw const FormatException('Data inválida');
    }

    String dia = int.parse(partes[0]).toString();
    String mes = meses[int.parse(partes[1]) - 1];
    String ano = partes[2];

    return '$dia de $mes de $ano';
  }

  static String formatTelefone(String telefone) {
    if (telefone.length == 11) {
      return '(${telefone.substring(0, 2)})${telefone.substring(2, 7)}-${telefone.substring(7, 11)}';
    } else {
      return telefone;
    }
  }
}
