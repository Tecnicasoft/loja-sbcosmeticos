import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:petshop_template/src/carrinho/models/model_carrinho.dart';
import 'package:petshop_template/src/carrinho/models/model_carrinho_details.dart';
import 'package:petshop_template/src/carrinho/models/model_endereco_entrega.dart';
import 'package:petshop_template/src/produtos/models/model_produtos.dart';
import 'package:petshop_template/src/services/service_utils.dart';
import 'package:petshop_template/src/shared/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

CarrinhoDetails carrinhoDetailsControler = Get.put(CarrinhoDetails());

class CarrinhoControler extends GetxController {
  UtilsServices util = UtilsServices();
  final uri = Util.uri;
  var uuid = const Uuid();

  Future finalizarPedido(
      String obs, int idLojaEntrega, double valorFrete) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    String idusuario = prefs.getString('idUsuario').toString();
    String nomeUsuarioCompleto =
        prefs.getString('nomeCompletoCliente').toString();
    String nomeCompletoEmpresa =
        prefs.getString('nomeCompletoEmpresa').toString();

    var params = {
      "idUsuario": idusuario,
      "obs": obs,
      "nomeCompletoCliente": nomeUsuarioCompleto,
      "nomeCompletoEmpresa": nomeCompletoEmpresa,
      "idLojaEntrega": idLojaEntrega,
      "valorFrete": valorFrete
    };
    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/comanda/salvaComandaAppCliente'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
        //carrinhoControler.qtd = 0;
        carrinhoDetailsControler.qtd = int.parse(await getQtdItensCarrinho());
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

  Future<List<CarrinhoModel>> getProdutos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    String idusuario = prefs.getString('idUsuario').toString();
    String tokenMobile = prefs.getString('tokenMobile').toString();

    var params = {"idUsuario": idusuario, "tokenMobile": tokenMobile};
    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/carrinhoapp/retornaItemCarrinho'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
        return parseCarrinho(response.body);
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

  Future<String> getQtdItensCarrinho() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    String idusuario = prefs.getString('idUsuario').toString();
    String tokenMobile = prefs.getString('tokenMobile').toString();

    var params = {"idUsuario": idusuario, "tokenMobile": tokenMobile};
    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/carrinhoapp/retornaQtdItemsCarrinho'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
        String qtdItens = response.body.toString();
        return qtdItens;
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

  Future updateItemCarrinho(CarrinhoModel carrinhoModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tokenMobile = prefs.getString('tokenMobile').toString();
    String token = prefs.getString('token').toString();
    String idusuario = prefs.getString('idUsuario').toString();

    // double subTotal =
    //     double.parse(carrinhoModel.valorBruto) * carrinhoModel.qtd;

    // double total =
    //     double.parse(carrinhoModel.valorFinal.toString()) * carrinhoModel.qtd;
    var params = {
      "Id": carrinhoModel.id,
      "qtd": carrinhoModel.qtd,
      "atualizaUmProduto": true,
      "idCliente": idusuario,
      "tokenMobile": tokenMobile,
      "token": token

      //"total": total,
      //"ValTotSemDesc": subTotal.toString(),
    };

    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      //Uri.parse('$uri/carrinhoapp/atualizaItemCarrinho'),
      Uri.parse('$uri/carrinhoapp/updateIdclienteCarrinho'),

      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // Future updateIdclienteCarrinho(int idCliente) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String token = prefs.getString('token').toString();
  //   String idusuario = prefs.getString('idUsuario').toString();

  //   var params = {"IdCliente": idCliente, "IdUsuario": idusuario};

  //   String body = json.encode(params);

  //   http.Client client = http.Client();
  //   final response = await client.post(
  //     Uri.parse('$uri/carrinhoapp/atualizaIdclienteCarrinho'),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $token",
  //     },
  //     body: body,
  //   );
  //   try {
  //     if (response.statusCode == 200) {
  //     } else {
  //       throw Exception();
  //     }
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  // Future<bool> updateObsCarrinho(String obs) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String token = prefs.getString('token').toString();
  //   String idusuario = prefs.getString('idUsuario').toString();

  //   var params = {"IdUsuario": idusuario, "Obs": obs};

  //   String body = json.encode(params);

  //   http.Client client = http.Client();
  //   final response = await client.post(
  //     Uri.parse('$uri/carrinhoapp/atualizaObsCarrinho'),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $token",
  //     },
  //     body: body,
  //   );
  //   try {
  //     if (response.statusCode == 200) {
  //       return true;
  //     } else {
  //       throw Exception();
  //     }
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  Future removeItemCarrinho(CarrinhoModel carrinhoModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();

    var params = {"Id": carrinhoModel.id};

    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/carrinhoapp/removeItemCarrinho'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
        carrinhoDetailsControler.qtd = int.parse(await getQtdItensCarrinho());
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addItemCarrinho(ProdutosModel produto, double qtd) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    String tokenMobile = prefs.getString('tokenMobile').toString();
    String idcliente = prefs.getString('idUsuario').toString();
    String idLoja = prefs.getString('idLoja').toString();

    // double total = 0;
    // double subTotal = double.parse(produto.valorBruto) * qtd;

    // if (produto.promoAtiva == 1) {
    //   total = subTotal -
    //       ((subTotal * double.parse(produto.valorPorDesconto) / 100));
    // } else {
    //   total = subTotal;
    // }
    // double totalFinal = total;

    var params = {
      "IdClienteApp": idcliente,
      "IdProduto": produto.id.toString(),
      "valorBruto": produto.valorBruto.toString(),
      "valorPorDesconto": produto.valorPorDesconto.toString(),
      "valorFinal": produto.valorFinal.toString(),
      "qtd": qtd.toString(),
      "IdLoja": idLoja,
      "Guid": uuid.v4(),
      "tokenMobile": tokenMobile,
      "promoAtiva": produto.promoAtiva.toString(),
      "usarCalculoPrecoNovo": "True",
    };

    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/carrinhoapp/salvaItemCarrinho'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
        carrinhoDetailsControler.qtd = int.parse(await getQtdItensCarrinho());
        //return "Produto adicionado ao carrinho com sucesso!";
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

  Future<List<EnderecoEntregaModel>> retornaEnderecoEntregaCliente() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token').toString();
    String idusuario = prefs.getString('idUsuario').toString();

    var params = {"idusuario": idusuario};
    String body = json.encode(params);

    http.Client client = http.Client();
    final response = await client.post(
      Uri.parse('$uri/clientes/retornaEnderecoEntregaCliente'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    try {
      if (response.statusCode == 200) {
        List<EnderecoEntregaModel> endereco =
            parseEnderecoEntrega(response.body);
        return endereco;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  List<EnderecoEntregaModel> parseEnderecoEntrega(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<dynamic, dynamic>>();
    return parsed
        .map<EnderecoEntregaModel>(
            (json) => EnderecoEntregaModel.fromJson(json))
        .toList();
  }

  List<CarrinhoModel> parseCarrinho(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<dynamic, dynamic>>();
    return parsed
        .map<CarrinhoModel>((json) => CarrinhoModel.fromJson(json))
        .toList();
  }
}
