import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/carrinho/controller/controller_page_carrinho.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/produtos/component/component_categoria_basico.dart';
import 'package:petshop_template/src/produtos/component/component_produto.dart';
import 'package:petshop_template/src/produtos/component/component_textbox_pesquisar_click.dart';
import 'package:petshop_template/src/produtos/controller/controller_page_list_produtos.dart';
import 'package:petshop_template/src/produtos/models/model_grupo.dart';
import 'package:petshop_template/src/produtos/models/model_produtos.dart';
import 'package:petshop_template/src/routes/app_pages.dart';
import 'package:petshop_template/src/shared/util.dart';
import 'package:video_player/video_player.dart';

class PageProdutosPromo extends StatefulWidget {
  const PageProdutosPromo({super.key});

  @override
  State<PageProdutosPromo> createState() => _PageProdutosPromoState();
}

class _PageProdutosPromoState extends State<PageProdutosPromo> {
  late VideoPlayerController _videoController;
  bool _videoInitialized = false;
  List<ProdutosModel> produtos = [];
  List<GrupoModel> grupos = [];

  bool isLoadingProdutos = true;
  bool isLoadingCategorias = true;
  bool colocandoNocarrinho = false;
  int indexProdutoCarrinho = -1;

  final PageProdutosController pageProdutosController = Get.find();
  final CarrinhoControler carrinhoControler = Get.find();
  bool _primeiroInicio = true;
  bool _isLoggedInUser = true;

  @override
  void initState() {
    super.initState();
    carregaListaCategorias('');
    carregaListaProdutosPromo('');

    _videoController =
        VideoPlayerController.asset('assets/images/primeiracomprahight.mp4')
          ..initialize().then((_) {
            setState(() {
              _videoInitialized = true;
            });
            _videoController.setLooping(true);
            _videoController.play();
          });
    verificaSemUsuarioEstaLogado();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  Future verificaSemUsuarioEstaLogado() async {
    var isLoggedInUser = await Util.verificaSemUsuarioAvulsoEstaLogado();

    if (mounted) {
      setState(() {
        _isLoggedInUser = isLoggedInUser;
      });
    }
  }

  Future<void> carregaListaProdutosPromo(String find) async {
    try {
      setState(() {
        isLoadingProdutos = true;
      });
      produtos = await pageProdutosController.getProdutos("", "1", "0", 0);

      if (mounted) {
        setState(() {
          isLoadingProdutos = false;
          _primeiroInicio = false;
        });
      }
    } catch (e) {
      Util.callMessageSnackBar('Erro ao carregar produtos');
    }
  }

  Future<void> carregaListaCategorias(String find) async {
    try {
      setState(() {
        isLoadingCategorias = true;
      });
      grupos = await pageProdutosController.getGrupos(find);
      setState(() {
        isLoadingCategorias = false;
      });
    } catch (e) {
      Util.callMessageSnackBar('Erro ao carregar as categorias');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de Pesquisa

            const TextBoxPesquisarFixo(false),

            _isLoggedInUser
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                    child: _videoInitialized
                        ? Center(
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(PageRoutes.login);
                              },
                              child: SizedBox(
                                height: 100,
                                width: 500 * 16 / 9,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: VideoPlayer(_videoController),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(
                            height: 100,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                  )
                : Container(),

            // Lista de Categorias
            Container(
              color: CustomColors.colorFundo,
              padding: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 10, top: 10),
              child: SizedBox(
                height: 30,
                child: isLoadingCategorias
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              // const Icon(Icons.ac_unit_sharp,
                              //     color: CustomColors.colorBottonCompra),
                              // const SizedBox(height: 8),
                              WidgetCustomCategoryTile(
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
                                isSelected: false,
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (_, index) =>
                            const SizedBox(width: 5),
                        itemCount: grupos.length,
                      ),
              ),
            ),

            // Promoções da Semana
            // Container(
            //   alignment: Alignment.bottomLeft,
            //   color: CustomColors.colorFundo,
            //   child: const Padding(
            //     padding:
            //         EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            //     child: SizedBox(
            //       height: 25,
            //       child: Text(
            //         "Promoções",
            //         style: TextStyle(
            //           fontSize: 18,
            //           fontWeight: FontWeight.bold,
            //           color: CustomColors.colorBottonCompra,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            // Lista de Produtos
            if (produtos.isEmpty)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _primeiroInicio
                          ? 'Aguarde! Estamos preparando novas promoções!'
                          : 'Atualmente, não há promoções disponíveis. Confira novamente em breve!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.colorBottonCompra,
                      ),
                    ),
                  ),
                ),
              ),
            if (_primeiroInicio)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Expanded(
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
