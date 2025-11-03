import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/produtos/models/model_produtos.dart';
import 'package:petshop_template/src/routes/app_pages.dart';
import 'package:petshop_template/src/services/service_utils.dart';

//PageProdutosController pageProdutosController = Get.find();

// ignore: must_be_immutable
class WidgetCustomProduto extends StatelessWidget {
  WidgetCustomProduto(
      {super.key,
      required this.produtosModel,
      required this.onPress,
      required this.colocandoNocarrinho,
      required this.indexProdutoCarrinhoAdicionado,
      required this.indexProduto});

  final ProdutosModel produtosModel;
  final VoidCallback onPress;
  bool colocandoNocarrinho;
  int indexProdutoCarrinhoAdicionado;
  int indexProduto;

  final ProdutosModel produtosModels = Get.find();

  @override
  Widget build(BuildContext context) {
    UtilsServices utilsServices = UtilsServices();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(2),
          child: Card(
            elevation: 2,
            shadowColor: CustomColors.colorIcons,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 130,
                    height: 160,
                    child: GestureDetector(
                      onTap: () {
                        produtosModels.descricao = produtosModel.descricao;
                        produtosModels.valorBruto = produtosModel.valorBruto;
                        produtosModels.valorFinal = produtosModel.valorFinal;
                        produtosModels.valorPorDesconto =
                            produtosModel.valorPorDesconto;
                        produtosModels.promoAtiva = produtosModel.promoAtiva;
                        produtosModels.imagem = produtosModel.imagem;
                        produtosModels.codigo = produtosModel.codigo;
                        produtosModels.id = produtosModel.id;
                        produtosModels.utilidade = produtosModel.utilidade;

                        Get.toNamed(PageRoutes.produtosDetails);
                      },
                      child: Image.network(
                        produtosModel.imagem,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          produtosModel.descricao,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: CustomColors.textoBottao,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          produtosModel.codigo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: CustomColors.textoBottao,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      //if promo is true
                      if (produtosModel.promoAtiva == 1)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                utilsServices.toFixed(
                                    produtosModel.valorBruto, 2),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.green, width: 1),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      utilsServices
                                          .formatDecimalToIntWhitPorcentagemString(
                                              double.parse(produtosModel
                                                  .valorPorDesconto)),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              utilsServices.toFixed(
                                  produtosModel.valorFinal, 2),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                        child: ElevatedButton.icon(
                          onPressed:
                              indexProdutoCarrinhoAdicionado == indexProduto
                                  ? null
                                  : onPress,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor: CustomColors.colorFundoShadow,
                          ),
                          label: !colocandoNocarrinho ||
                                  indexProdutoCarrinhoAdicionado != indexProduto
                              ? const Text(
                                  'Adicionar ao carrinho',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.colorBottonCompra,
                                  ),
                                )
                              : const Text(
                                  'Adicionando...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.colorBottonCompra,
                                  ),
                                ),
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                            color: CustomColors.colorBottonCompra,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
