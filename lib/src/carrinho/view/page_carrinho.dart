import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/carrinho/component/component_produto_carrinho.dart';
import 'package:petshop_template/src/carrinho/controller/controller_page_carrinho.dart';
import 'package:petshop_template/src/carrinho/models/model_carrinho.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/produtos/component/component_textbox_pesquisar_click.dart';
import 'package:petshop_template/src/routes/app_pages.dart';
import 'package:petshop_template/src/services/service_utils.dart';
import 'package:petshop_template/src/shared/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

CarrinhoControler carrinhoControler = Get.put(CarrinhoControler());

class PageCarrinho extends StatefulWidget {
  const PageCarrinho({super.key});

  @override
  State<PageCarrinho> createState() => _PageCarrinhoState();
}

class _PageCarrinhoState extends State<PageCarrinho> {
  List<CarrinhoModel> produtos = [];
  String nomeCliente = "";
  String stringObservacoes = "";
  double subtotal = 0;
  double desconto = 0;
  double total = 0;
  double valorMinimoFreteEntrega = 0;
  double valorRestanteparaFreteGratis = 0;
  String mensagemFreteGratis = "";
  double valorFretePadrao = 0;

  UtilsServices utilsServices = UtilsServices();

  bool isLoadingProdutos = true;
  bool finalizaPedido = false;

  @override
  void initState() {
    super.initState();
    carregaProdutosCarrinho();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void atualizaTotal() {
    total = 0;
    desconto = 0;
    subtotal = 0;
    mensagemFreteGratis = "";

    for (var i = 0; i < produtos.length; i++) {
      String descontosub =
          utilsServices.toFixedNotCurrency(produtos[i].valTotDesc, 2);
      String totalsub = utilsServices.toFixedNotCurrency(produtos[i].total, 2);

      total += double.parse(totalsub);
      desconto += double.parse(descontosub);

      subtotal = desconto + total;

      valorRestanteparaFreteGratis = valorMinimoFreteEntrega - total;

      if (valorMinimoFreteEntrega == 0) {
        mensagemFreteGratis = "";
        valorFretePadrao = 0;
      } else {
        mensagemFreteGratis = valorRestanteparaFreteGratis > 0
            ? "Adicione mais ${utilsServices.toFixed(valorRestanteparaFreteGratis.toString(), 2)} para conseguir frete grátis"
            : "Parabéns! Você ganhou frete grátis, continue aproveitando!";
      }
    }
    if (valorRestanteparaFreteGratis <= 0) {
      valorFretePadrao = 0;
    }
    total += valorFretePadrao;
    setState(() {});
  }

  Future<void> carregaProdutosCarrinho() async {
    try {
      setState(() {
        isLoadingProdutos = true;
      });

      valorFretePadrao = 0;
      valorMinimoFreteEntrega = 0;

      produtos = await carrinhoControler.getProdutos();

      if (produtos.isEmpty) {
        if (mounted) {
          setState(() {
            stringObservacoes = "";
            isLoadingProdutos = false;
            atualizaTotal();
          });
        }
        return;
      }

      if (produtos[0].nomeCliente != null) {
        nomeCliente = produtos[0].nomeCliente!;
        valorMinimoFreteEntrega =
            produtos[0].valorMinimoFreteEntrega.toDouble();
        valorFretePadrao = produtos[0].valorFretePadrao.toDouble();
      } else {
        nomeCliente = "";
      }

      stringObservacoes = produtos[0].obs;

      if (mounted) {
        setState(() {
          isLoadingProdutos = false;
        });
      }

      atualizaTotal();
    } catch (e) {
      Util.callMessageSnackBar('Erro ao carregar produtos');
    }
  }

  Future<void> updateItemCarrinho(CarrinhoModel carrinhoModel) async {
    try {
      await carrinhoControler.updateItemCarrinho(carrinhoModel);
      if (mounted) {
        carregaProdutosCarrinho();
      }
    } catch (e) {
      Util.callMessageSnackBar('Erro ao atualizar produtos');
    }
  }

  Future<void> removeItemCarrinho(CarrinhoModel carrinhoModel) async {
    try {
      await carrinhoControler.removeItemCarrinho(carrinhoModel);
      if (mounted) {
        carregaProdutosCarrinho();
      }
    } catch (e) {
      Util.callMessageSnackBar('Erro ao remover produto');
    }
  }

  // Future<void> updateObsCarrinho(String obs) async {
  //   try {
  //     if (obs.isEmpty) {
  //       Util.callMessageSnackBar('Observação não pode ser vazia');
  //       return;
  //     }

  //     if (produtos.isEmpty) {
  //       Util.callMessageSnackBar('Nenhum produto no carrinho');
  //       return;
  //     }

  //     await carrinhoControler.updateObsCarrinho(obs);
  //     Util.callMessageSnackBar('Observações atualizada com sucesso');
  //     carregaProdutosCarrinho();
  //   } catch (e) {
  //     Util.callMessageSnackBar('Erro ao atualizar observações');
  //   }
  // }

  // Future<void> updateIdclienteCarrinho(int idCliente) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await carrinhoControler.updateIdclienteCarrinho(idCliente);
  //     await prefs.setString('idUsuario', idCliente.toString());
  //     carregaProdutosCarrinho();
  //   } catch (e) {
  //     Util.callMessageSnackBar('Erro ao atualizar cliente');
  //   }
  // }

  Future<bool> verificaUsuarioTemp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tempUser = prefs.getString('tempUser');
    if (tempUser == 'true') {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho melhorado
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Barra de Pesquisa
                  const TextBoxPesquisarFixo(false),

                  // Título do carrinho
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.shopping_cart,
                              color: CustomColors.colorBottonCompra,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Meu Carrinho",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.colorBottonCompra,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Conteúdo principal - Lista de produtos
            if (isLoadingProdutos)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (produtos.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Seu carrinho está vazio',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Adicione produtos para continuar',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: produtos.length,
                    itemBuilder: (context, index) {
                      return WidgetCustomProdutoCarrinho(
                        result: (value) {
                          if (value == 0) {
                            removeItemCarrinho(produtos[index]);
                            return;
                          }

                          produtos[index].qtd = value;
                          updateItemCarrinho(produtos[index]);
                        },
                        produtosModel: produtos[index],
                        onPress: () async {},
                      );
                    },
                  ),
                ),
              ),

            // Rodapé com total e botões
            Container(
              decoration: BoxDecoration(
                color: CustomColors.colorFundoPrimario,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Subtotal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Subtotal",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          utilsServices.toFixed(subtotal.toString(), 2),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.colorBottonCompra,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 10,
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    // Desconto
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Desconto",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          utilsServices.toFixed(desconto.toString(), 2),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.colorBottonCompra,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 10,
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    // Frete
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Frete",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          utilsServices.toFixed(valorFretePadrao.toString(), 2),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.colorBottonCompra,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 10,
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    // Total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          utilsServices.toFixed(total.toString(), 2),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.colorBottonCompra,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 10,
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    if (mensagemFreteGratis.isNotEmpty)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  mensagemFreteGratis,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade800,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),

                    // Botão continuar compra
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (produtos.isEmpty) {
                          Util.callMessageSnackBar(
                              'Nenhum produto no carrinho');
                          return;
                        }

                        await verificaUsuarioTemp().then(
                          (value) {
                            if (value) {
                              Get.toNamed(PageRoutes.login);
                            } else {
                              if (context.mounted) {
                                Get.toNamed(PageRoutes.pageCarrinhoEntrega,
                                    arguments: {
                                      'frete': valorFretePadrao,
                                      'total': total,
                                      'valorRestanteparaFreteGratis':
                                          valorRestanteparaFreteGratis
                                    });
                              }
                            }
                          },
                        );
                      },
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: const Text('Continuar a compra'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.colorBottonCompra,
                        foregroundColor: CustomColors.colorTextoPrimario,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Botão retornar à página inicial
                    OutlinedButton.icon(
                      onPressed: () {
                        Get.toNamed(PageRoutes.baseRoute);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Retornar à página inicial'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
