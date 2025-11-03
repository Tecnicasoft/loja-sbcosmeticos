import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/carrinho/controller/controller_page_carrinho.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/produtos/component/component_menu_inferior.dart';
import 'package:petshop_template/src/produtos/component/component_produto.dart';
import 'package:petshop_template/src/produtos/component/component_textbox_pesquisar_click.dart';
import 'package:petshop_template/src/produtos/controller/controller_page_list_produtos.dart';
import 'package:petshop_template/src/produtos/models/model_grupo.dart';
import 'package:petshop_template/src/produtos/models/model_produtos.dart';
import 'package:petshop_template/src/shared/util.dart';

class PageProdutosResultadoPesquisa extends StatefulWidget {
  const PageProdutosResultadoPesquisa({super.key});

  @override
  State<PageProdutosResultadoPesquisa> createState() =>
      _PageProdutosResultadoPesquisaState();
}

class _PageProdutosResultadoPesquisaState
    extends State<PageProdutosResultadoPesquisa> {
  final PageProdutosController pageProdutosController = Get.find();
  final CarrinhoControler carrinhoControler = Get.find();

  List<GrupoModel> grupos = [];
  List<ProdutosModel> produtos = [];
  int idCategoria = 0;

  bool isLoadingProdutos = true;
  bool isLoadingCategorias = true;
  bool _primeiroInicio = true;
  bool _semResultados = false;
  String nomeCategoria = '';
  int qrcode = 0;
  bool colocandoNocarrinho = false;
  int indexProdutoCarrinho = -1;

  dynamic argumentData = Get.arguments;

  @override
  void initState() {
    super.initState();
    if (argumentData != null) {
      carregaListaProdutos(argumentData['idCategoria'].toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> carregaListaProdutos(String find) async {
    try {
      setState(() {
        isLoadingProdutos = true;
      });

      qrcode = int.parse(argumentData['qrcode']);

      if (find == '0') {
        nomeCategoria = argumentData['nomeCategoria'];
        if (nomeCategoria.isEmpty) {
          setState(() {
            isLoadingProdutos = false;
          });
          return;
        }
        produtos = await pageProdutosController.getProdutos(
            nomeCategoria, "0", "0", qrcode);
      } else {
        produtos =
            await pageProdutosController.getProdutos("", "0", find, qrcode);
      }

      if (produtos.isEmpty) {
        _semResultados = true;
      }

      setState(() {
        isLoadingProdutos = false;
      });
    } catch (e) {
      Util.callMessageSnackBar('Erro ao carregar produtos');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_primeiroInicio) {
      idCategoria = argumentData['idCategoria'];
      nomeCategoria = argumentData['nomeCategoria'];
    }

    return Scaffold(
      bottomNavigationBar: const MenuInferior(),
      appBar: null,
      body: SafeArea(
        child: Column(
          children: [
            // Barra de Pesquisa
            const TextBoxPesquisarFixo(false),
            // Barra Resultados da Pesquisa
            Container(
              alignment: Alignment.bottomLeft,
              color: CustomColors.colorFundo,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 13,
                  child: Text(
                    "${produtos.length} Resultados em $nomeCategoria",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: CustomColors.colorIcons,
                    ),
                  ),
                ),
              ),
            ),

            //Lista de Produtos
            _semResultados
                ? Expanded(
                    child: Center(
                      child: Text(
                        _primeiroInicio
                            ? 'Ops! Não encontramos resultados.'
                            : 'Ops! Não encontramos resultados.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.colorBottonCompra,
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: !isLoadingProdutos
                        ? ListView.builder(
                            itemCount: produtos.length,
                            itemBuilder: (context, index) {
                              _primeiroInicio = false;
                              return WidgetCustomProduto(
                                produtosModel: produtos[index],
                                colocandoNocarrinho: colocandoNocarrinho,
                                indexProdutoCarrinhoAdicionado:
                                    indexProdutoCarrinho,
                                indexProduto: index,
                                onPress: () async {
                                  setState(() {
                                    colocandoNocarrinho = true;
                                    indexProdutoCarrinho = index;
                                  });
                                  await carrinhoControler.addItemCarrinho(
                                      produtos[index], 1);
                                  setState(() {
                                    colocandoNocarrinho = false;
                                    indexProdutoCarrinho = -1;
                                  });
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
      ),
    );
  }
}
