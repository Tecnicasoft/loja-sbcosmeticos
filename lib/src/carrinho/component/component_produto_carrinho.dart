import 'package:flutter/material.dart';
import 'package:petshop_template/src/carrinho/component/component_qtd_carrinho.dart';
import 'package:petshop_template/src/carrinho/models/model_carrinho.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/services/service_utils.dart';

class WidgetCustomProdutoCarrinho extends StatefulWidget {
  const WidgetCustomProdutoCarrinho(
      {super.key,
      required this.produtosModel,
      required this.result,
      required this.onPress});

  final CarrinhoModel produtosModel;
  final VoidCallback onPress;
  final Function(int quantity) result;

  @override
  State<WidgetCustomProdutoCarrinho> createState() =>
      _WidgetCustomProdutoCarrinhoState();
}

class _WidgetCustomProdutoCarrinhoState
    extends State<WidgetCustomProdutoCarrinho> {
  //final CarrinhoModel produtosModels = Get.find();

  @override
  Widget build(BuildContext context) {
    UtilsServices utilsServices = UtilsServices();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagem do produto
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                clipBehavior: Clip.antiAlias,
                child: widget.produtosModel.imagem.isNotEmpty
                    ? Image.network(
                        widget.produtosModel.imagem,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade100,
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey.shade100,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey,
                        ),
                      ),
              ),

              const SizedBox(width: 12),

              // Informações do produto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Descrição do produto
                    Text(
                      widget.produtosModel.descricao,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Código do produto
                    Text(
                      "Cód: ${widget.produtosModel.codigo}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Promoção ativa (se houver)
                    if (widget.produtosModel.promoAtiva == 1 ||
                        widget.produtosModel.promoPrimeiraCompra == 1)
                      Row(
                        children: [
                          Text(
                            utilsServices.toFixed(
                                widget.produtosModel.valorBruto, 2),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Text(
                              utilsServices
                                  .formatDecimalToIntWhitPorcentagemString(
                                      double.parse(widget
                                          .produtosModel.valorPorDesconto)),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 6),

                    //row primeira compra
                    if (widget.produtosModel.promoPrimeiraCompra == 1)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.brown.shade700,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Text(
                              "Desconto Primeira Compra",
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 6),

                    // Preço
                    Text(
                      utilsServices.toFixed(
                          widget.produtosModel.total.toString(), 2),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.colorBottonCompra,
                      ),
                    ),
                  ],
                ),
              ),

              // Controle de quantidade
              Column(
                children: [
                  SizedBox(
                    height: 80,
                    child: QuantityWidget(
                      value: widget.produtosModel.qtd,
                      suffixText: '',
                      isRemovable: true,
                      result: (value) {
                        widget.produtosModel.qtd = value;
                        widget.result(value);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
