import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:petshop_template/src/produtos/models/model_fotos.dart';
import 'package:petshop_template/src/produtos/models/model_grupo.dart';
import 'package:petshop_template/src/produtos/models/model_produtos.dart';
import 'package:petshop_template/src/shared/util.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class PageProdutosController extends GetxController {
  TextEditingController txtPesquisar = TextEditingController();
  ItemScrollController ctr = ItemScrollController();

  void scrollToIndex() {
    ctr.scrollTo(
        index: 15,
        duration: const Duration(milliseconds: 800),
        curve: Curves.linear);
  }

  final uri = Util.uri;

  Future<List<ProdutosModel>> getProdutos(String filterString,
      String filterPromo, String filtroSubGrupo, int qrcode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    var params = {
      "find": filterString,
      "filtroPromo": filterPromo,
      "filtroSubGrupo": filtroSubGrupo,
      "qrcode": qrcode
    };
    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/produtos/getAllProdutos'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
        return parseProdutos(response.body);
      } else if (response.statusCode == 401) {
        Get.offAllNamed('/login');
        throw Exception();
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<FotoModel>> getFotosProdutos(String guid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    var params = {"find": guid};
    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/produtos/getAllFotosProdutos'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
        return parseFotos(response.body);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<GrupoModel>> getGrupos(String filter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    // var params = {"find": filter};
    // String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.get(
      Uri.parse('$uri/grupos/getAll'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      //body: body,
    );

    try {
      if (response.statusCode == 200) {
        return parseGrupos(response.body);
      } else if (response.statusCode == 401) {
        Get.offAllNamed('/login');
        throw Exception();
      } else {
        throw Exception();
      }
    } catch (e) {
      //print(e);
      throw Exception(e);
    }
  }

  Future<List<GrupoModel>> getSubGrupos(String filter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    var params = {"find": filter};
    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/grupos/getAllSubGrupo'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );

    try {
      if (response.statusCode == 200) {
        return parseGrupos(response.body);
      } else {
        throw Exception();
      }
    } catch (e) {
      //print(e);
      throw Exception(e);
    }
  }

  List<ProdutosModel> parseProdutos(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<ProdutosModel>((json) => ProdutosModel.fromJson(json))
        .toList();
  }

  List<GrupoModel> parseGrupos(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<GrupoModel>((json) => GrupoModel.fromJson(json)).toList();
  }

  List<FotoModel> parseFotos(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<FotoModel>((json) => FotoModel.fromJson(json)).toList();
  }
}
