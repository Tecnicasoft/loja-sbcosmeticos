import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:petshop_template/src/cliente/models/model_cliente.dart';
import 'package:petshop_template/src/shared/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientesControler extends GetxController {
  final uri = Util.uri;

  Future<List<ClienteModel>> getClientes(String filter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    var params = {"find": filter};
    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/clientes/retornaClientes'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
        return parseCliente(response.body);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  List<ClienteModel> parseCliente(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<dynamic, dynamic>>();
    return parsed
        .map<ClienteModel>((json) => ClienteModel.fromJson(json))
        .toList();
  }
}
