import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/produtos/component/component_categoria_full.dart';
import 'package:petshop_template/src/produtos/component/component_menu_inferior.dart';
import 'package:petshop_template/src/produtos/component/component_textbox_pesquisar_click.dart';
import 'package:petshop_template/src/produtos/controller/controller_page_list_produtos.dart';
import 'package:petshop_template/src/produtos/models/model_grupo.dart';
import 'package:petshop_template/src/routes/app_pages.dart';
import 'package:petshop_template/src/shared/util.dart';

class PageCategoriasSub extends StatefulWidget {
  const PageCategoriasSub({super.key});

  @override
  State<PageCategoriasSub> createState() => _PageCategoriasSubState();
}

class _PageCategoriasSubState extends State<PageCategoriasSub> {
  PageProdutosController pageProdutosController = Get.find();
  List<GrupoModel> grupos = [];

  bool isLoading = true;
  dynamic argumentData = Get.arguments;
  String nomeCategoria = '';

  @override
  void initState() {
    super.initState();
    nomeCategoria = argumentData['idCategoria'].toString();
    carregaLista(nomeCategoria);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> carregaLista(String find) async {
    try {
      grupos = await pageProdutosController.getSubGrupos(find);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      Util.callMessageSnackBar('Erro ao carregar as categorias');
    }
  }

  @override
  Widget build(BuildContext context) {
    nomeCategoria = argumentData['nomeCategoria'];
    return Scaffold(
      appBar: null,
      bottomNavigationBar: const MenuInferior(),
      body: SafeArea(
        child: Column(
          children: [
            // Barra de Pesquisa
            const TextBoxPesquisarFixo(false),
            // sub Categoria
            Container(
              alignment: Alignment.bottomLeft,
              color: CustomColors.colorFundo,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  child: Text(
                    nomeCategoria,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.colorBottonCompra,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: !isLoading
                  ? ListView.builder(
                      //scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        //return Text(grupos[index].descricao);
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                          child: WidgetCategoriaFull(
                            onPress: () {
                              setState(
                                () {
                                  Get.toNamed(
                                    PageRoutes.produtosCategoriasPesquisar,
                                    arguments: {
                                      "idCategoria": grupos[index].id,
                                      "index": index,
                                      "nomeCategoria": grupos[index].descricao,
                                      "qrcode": "0",
                                    },
                                  );
                                },
                              );
                            },
                            category: grupos[index].descricao,
                            isSelected: true,
                            isDescricao: true,
                            isDescricaoDetalhes:
                                grupos[index].descricaoDetalhes ?? '',
                          ),
                        );
                      },
                      itemCount: grupos.length,
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
