import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/produtos/component/component_categoria_full.dart';
import 'package:petshop_template/src/produtos/component/component_textbox_pesquisar_click.dart';
import 'package:petshop_template/src/produtos/controller/controller_page_list_produtos.dart';
import 'package:petshop_template/src/produtos/models/model_grupo.dart';
import 'package:petshop_template/src/routes/app_pages.dart';
import 'package:petshop_template/src/shared/util.dart';

class PageCategorias extends StatefulWidget {
  const PageCategorias({super.key});

  @override
  State<PageCategorias> createState() => _PageCategoriasState();
}

class _PageCategoriasState extends State<PageCategorias> {
  PageProdutosController pageProdutosController = Get.find();
  List<GrupoModel> grupos = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    carregaLista("");
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> carregaLista(String find) async {
    try {
      grupos = await pageProdutosController.getGrupos(find);
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      Util.callMessageSnackBar('Erro ao carregar as categorias');
    }
  }

  void pesquisarGrupo(String value, List<GrupoModel> lista) {
    if (value.isEmpty) {
      setState(() {
        grupos = lista;
      });
    } else {
      setState(() {
        grupos = lista
            .where((element) =>
                element.descricao.toLowerCase().contains(value.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        //
        child: Column(
          children: [
            // Barra de Pesquisa
            const TextBoxPesquisarFixo(false),
            // Categorias
            Container(
              alignment: Alignment.bottomLeft,
              color: CustomColors.colorFundo,
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: SizedBox(
                  child: Text(
                    "Categorias",
                    style: TextStyle(
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
                                      PageRoutes.pageCategoriasSub,
                                      arguments: {
                                        "idCategoria": grupos[index].id,
                                        "index": index,
                                        "nomeCategoria":
                                            grupos[index].descricao,
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
                      )),
          ],
        ),
      ),
    );
  }
}
