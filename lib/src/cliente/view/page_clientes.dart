import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/cliente/controller/controller_page_cliente.dart';
import 'package:petshop_template/src/cliente/models/model_cliente.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/services/service_utils.dart';
import 'package:petshop_template/src/shared/util.dart';

ClientesControler clientesControler = Get.put(ClientesControler());

class PageClientes extends StatefulWidget {
  const PageClientes({super.key});

  @override
  State<PageClientes> createState() => _PageClientesState();
}

class _PageClientesState extends State<PageClientes> {
  //List<ProdutosModel> produtos = [
  List<ClienteModel> cliente = [];
  double total = 0;
  UtilsServices utilsServices = UtilsServices();

  bool isLoadingProdutos = false;

  @override
  void initState() {
    super.initState();
    //carregaClientes("1");
  }

  Future<void> carregaClientes(String find) async {
    try {
      setState(() {
        isLoadingProdutos = true;
      });
      cliente = await clientesControler.getClientes(find);
      setState(() {
        isLoadingProdutos = false;
      });
    } catch (e) {
      Util.callMessageSnackBar('Erro ao carregar clientes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.colorFundo,
        title: const Text(
          "Clientes",
          style: TextStyle(
            color: CustomColors.colorBottonCompra,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: CustomColors.colorBottonCompra,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 35,
              child: TextFormField(
                onFieldSubmitted: (value) {
                  carregaClientes(value);
                },
                autofocus: true,
                textInputAction: TextInputAction.search,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  hintText: 'Pesquisar cliente',
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  prefixIcon: Icon(
                    Icons.search,
                    fill: 1,
                    color: CustomColors.colorIcons,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: !isLoadingProdutos
                ? ListView.builder(
                    itemCount: cliente.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(cliente[index].nome),
                        subtitle: Text(cliente[index].CPF_CNPJ),
                        onTap: () {
                          Get.back(result: cliente[index]);
                        },
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
    );
  }
}
