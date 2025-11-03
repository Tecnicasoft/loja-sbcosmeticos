import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:petshop_template/src/comissao/models/model_comissao.dart';
import 'package:petshop_template/src/comissao/models/model_usuario.dart';
import 'package:petshop_template/src/shared/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComissaoControler extends GetxController {
  final uri = Util.uri;

  Future<List<Comissao>> getComissao(
      String filter, int usuario, int idEmpresa) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    var idUsuario = prefs.getString('idUsuario').toString();
    var idLoja = idEmpresa; //prefs.getString('idLoja').toString();
    //var usuarioMultiLoja = prefs.getString('usuarioMultiLoja').toString();
    String dataIni = '';
    String dataFin = '';

    switch (filter) {
      case '0':
        dataIni = '${DateTime.now().year}-${DateTime.now().month}-01';
        var lastDayOfMonth =
            DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
        dataFin =
            '${DateTime.now().year}-${DateTime.now().month}-$lastDayOfMonth';
        break;
      case '1':
        dataIni = '${DateTime.now().year}-${DateTime.now().month - 1}-01';
        var lastDayOfMonth =
            DateTime(DateTime.now().year, DateTime.now().month, 0).day;
        dataFin =
            '${DateTime.now().year}-${DateTime.now().month - 1}-$lastDayOfMonth';
        break;
      case '2':
        dataIni = '${DateTime.now().year}-${DateTime.now().month - 2}-01';
        var lastDayOfMonth =
            DateTime(DateTime.now().year, DateTime.now().month - 1, 0).day;
        dataFin =
            '${DateTime.now().year}-${DateTime.now().month - 2}-$lastDayOfMonth';
        break;
      case '3':
        dataIni = '${DateTime.now().year}-${DateTime.now().month - 3}-01';
        var lastDayOfMonth =
            DateTime(DateTime.now().year, DateTime.now().month - 2, 0).day;
        dataFin =
            '${DateTime.now().year}-${DateTime.now().month - 3}-$lastDayOfMonth';
        break;
    }

    var params = {
      "idsGrupos": "",
      "idUsuario": idUsuario,
      //"idUsuario": null,
      "DataIni": dataIni.toString(),
      "DataFin": dataFin.toString(),
      "idLoja": idLoja
    };

    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/comicao/getComicao'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
        return parseComissao(response.body);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  List<Comissao> parseComissao(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<dynamic, dynamic>>();
    return parsed.map<Comissao>((json) => Comissao.fromJson(json)).toList();
  }

  Future<List<Usuario>> getUsuario(String filter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    var params = {
      "find": "",
    };

    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/usuarios/GetAllUsuarios'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
        return parseUsuarios(response.body);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  List<Usuario> parseUsuarios(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<dynamic, dynamic>>();
    return parsed.map<Usuario>((json) => Usuario.fromJson(json)).toList();
  }
}
