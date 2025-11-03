import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:petshop_template/src/pedidos/models/model_pedido.dart';
import 'package:petshop_template/src/pedidos/models/model_pedido_detalhes.dart';
import 'package:petshop_template/src/shared/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PedidosControler extends GetxController {
  final uri = Util.uri;

  Future<List<PedidoModel>> getAllPedidos(
      String dataIni, String dataFim) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    String idUsuario = prefs.getString('idUsuario').toString();

    var params = {"de": dataIni, "ate": dataFim, "idusuario": idUsuario};

    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/comanda/getallcomandasAppCliente'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
        return parsePedidos(response.body);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<PedidoDetalhesModel>> getProdutosPedidos(int idPedido) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    var params = {"id": idPedido};

    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/comanda/getComandaId'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
        // final PedidoDetalhesModel parsed =
        //     json.decode(response.body.toString());
        // return parsed;
        return parsePedidoDetalhe(response.body);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  List<PedidoModel> parsePedidos(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<dynamic, dynamic>>();
    return parsed
        .map<PedidoModel>((json) => PedidoModel.fromJson(json))
        .toList();
  }

  List<PedidoDetalhesModel> parsePedidoDetalhe(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<dynamic, dynamic>>();
    return parsed
        .map<PedidoDetalhesModel>((json) => PedidoDetalhesModel.fromJson(json))
        .toList();
  }

  String converRetornaStatus(String status) {
    if (status == 'A') {
      return 'Emitido';
    } else if (status == 'F') {
      return 'Finalizado';
    } else if (status == 'C') {
      return 'Cancelado';
    } else {
      return '';
    }
  }

  String convertRetornaStatusFaturado(int faturado) {
    if (faturado == 0) {
      return 'Não';
    } else if (faturado == 1) {
      return 'Sim';
    } else {
      return 'Erro';
    }
  }
}
