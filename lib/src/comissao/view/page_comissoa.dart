import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/comissao/controller/controller_page_comissao.dart';
import 'package:petshop_template/src/comissao/models/model_comissao.dart';
import 'package:petshop_template/src/comissao/models/model_usuario.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/empresas/controller/controller_page_empresas.dart';
import 'package:petshop_template/src/empresas/models/model_empresas.dart';
import 'package:petshop_template/src/services/service_utils.dart';
import 'package:petshop_template/src/shared/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

ComissaoControler comissaoControler = Get.put(ComissaoControler());
EmpresaControler empresaControler = Get.put(EmpresaControler());

class PageComissao extends StatefulWidget {
  const PageComissao({super.key});

  @override
  State<PageComissao> createState() => _PageComissaoState();
}

class _PageComissaoState extends State<PageComissao> {
  List<Comissao> comissao = [];
  List<Empresa> empresa = [];
  List<Usuario> usuario = [];
  bool isLoadingProdutos = false;
  bool isLoadingEmpresas = false;
  bool ocultarEmpresas = false;
  UtilsServices utilsServices = UtilsServices();
  var mesEscolhido = 0;
  var empresaEscolhida = 1;
  var empresaEscolhidaButton = 0;
  var ususarioEscolhido = 0;
  double totalComissao = 0.0;

  List<String> lista = [
    '${DateTime.now().month.toString()}/${DateTime.now().year.toString()}',
    '${DateTime.now().month - 1}/${DateTime.now().year.toString()}',
    '${DateTime.now().month - 2}/${DateTime.now().year.toString()}',
    '${DateTime.now().month - 3}/${DateTime.now().year.toString()}',
  ];

  @override
  void initState() {
    super.initState();
    verificaMultiloja();
    carregaComissao();
  }

  void verificaMultiloja() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var usuarioMultiLoja = prefs.getString('usuarioMultiLoja').toString();
    var idLoja = prefs.getString('idLoja').toString();
    if (usuarioMultiLoja == '0') {
      setState(() {
        ocultarEmpresas = true;
        empresaEscolhida = int.parse(idLoja);
      });
    } else {
      carregaEmpresas();
    }
  }

  Future<void> carregaEmpresas() async {
    try {
      setState(() {
        isLoadingEmpresas = true;
      });

      empresa = await empresaControler.getAllEmpresas(1);
      empresaEscolhida = empresa.isNotEmpty ? empresa[0].id : 0;
      setState(() {
        isLoadingEmpresas = false;
      });
    } catch (e) {
      Util.callMessageSnackBar('Erro ao carregar as empresas');
    }
  }

  Future<void> carregaComissao() async {
    try {
      setState(() {
        isLoadingProdutos = true;
      });
      comissao = await comissaoControler.getComissao(
          mesEscolhido.toString(), ususarioEscolhido, empresaEscolhida);

      totalComissao = 0.0;
      for (var i = 0; i < comissao.length; i++) {
        totalComissao += double.parse(comissao[i].total);
      }

      setState(() {
        isLoadingProdutos = false;
      });
    } catch (e) {
      Util.callMessageSnackBar('Erro ao carregar comissão');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.colorFundo,
        title: const Text(
          "Vendas por Vendedor",
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
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: ocultarEmpresas ? 0 : 50,
              child: isLoadingEmpresas
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: empresa.length,
                        itemBuilder: (context, index) {
                          return ElevatedButton(
                            onPressed: () {
                              setState(() {
                                empresaEscolhida = empresa[index].id;
                                empresaEscolhidaButton = index;
                                carregaComissao();
                              });
                              //carregaComissao();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: empresaEscolhidaButton == index
                                  ? CustomColors.colorBottonCompra
                                  : CustomColors.colorFundoObs,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Text(
                                empresa[index].abrev,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(width: 10);
                        },
                      ),
                    ),
            ),
            SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: lista.length,
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          mesEscolhido = index;
                        });
                        carregaComissao();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mesEscolhido == index
                            ? CustomColors.colorBottonCompra
                            : CustomColors.colorFundoObs,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          lista[index],
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 10);
                  },
                ),
              ),
            ),
            const Divider(
              height: 0,
              color: Colors.black,
            ),
            isLoadingProdutos
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: comissao.isEmpty
                        ? const Center(
                            child: Text(
                              'Nenhum dado disponível no momento.',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )
                        : ListView.builder(
                            itemCount: comissao.length,
                            itemBuilder: (context, index) {
                              final comissaoItem = comissao[index];
                              return Column(
                                children: [
                                  ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Text(comissaoItem.nome,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                    trailing: Text(
                                      utilsServices.toFixed(
                                          comissaoItem.total, 2),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    height: 0,
                                    color: Colors.black,
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
            Container(
              padding: const EdgeInsets.all(16.0),
              color: CustomColors.colorFundoObs,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    utilsServices.toFixed(totalComissao.toString(), 2),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyListView extends StatelessWidget {
  const MyListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20, // Número de itens na lista
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              title: Text('Item $index'),
              tileColor: Colors.blue[100 * (index % 9 + 1)],
            ),
            const SizedBox(
                height: 4.0), // Ajuste a altura para controlar a separação
          ],
        );
      },
    );
  }
}
