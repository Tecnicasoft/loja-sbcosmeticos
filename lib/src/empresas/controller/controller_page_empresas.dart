import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:petshop_template/src/empresas/models/model_empresas.dart';
import 'package:petshop_template/src/empresas/models/model_empresas_format.dart';
import 'package:petshop_template/src/shared/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmpresaControler extends GetxController {
  final uri = Util.uri;

  Future<List<Empresa>> getAllEmpresas(int loja) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    // var idLoja = prefs.getString('idLoja').toString();
    // if (loja != 0) {
    //   idLoja = loja.toString();
    // }

    // var params = {"idLoja": idLoja};

    //String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.get(
      Uri.parse('$uri/empresas/getAll'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      //body: body,
    );
    try {
      if (response.statusCode == 200) {
        return parseEmpresas(response.body);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  List<Empresa> parseEmpresas(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<dynamic, dynamic>>();
    return parsed.map<Empresa>((json) => Empresa.fromJson(json)).toList();
  }

  List<EmpresaFormat> parseEmpresasFormat(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<dynamic, dynamic>>();
    return parsed
        .map<EmpresaFormat>((json) => EmpresaFormat.fromJson(json))
        .toList();
  }

  Future<List<EmpresaFormat>> getEmpresasFormat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    http.Client client = http.Client();
    final response = await client.get(
      Uri.parse('$uri/empresas/retornaEmpresas'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      //body: body,
    );
    try {
      if (response.statusCode == 200) {
        return parseEmpresasFormat(response.body);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
