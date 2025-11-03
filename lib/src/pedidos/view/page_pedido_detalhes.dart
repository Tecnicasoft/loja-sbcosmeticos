import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/carrinho/controller/controller_page_carrinho.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/pedidos/controller/controller_page_pedidos.dart';
import 'package:petshop_template/src/pedidos/models/model_pedido_detalhes.dart';
import 'package:petshop_template/src/produtos/controller/controller_page_list_produtos.dart';
import 'package:petshop_template/src/produtos/models/model_produtos.dart';
import 'package:petshop_template/src/services/service_utils.dart';
import 'package:petshop_template/src/shared/util.dart';

PedidosControler pedidosControler = Get.put(PedidosControler());
CarrinhoControler carrinhoControler = Get.put(CarrinhoControler());
PageProdutosController pageProdutosController =
    Get.put(PageProdutosController());

class PagePedidoDetalhe extends StatefulWidget {
  const PagePedidoDetalhe({super.key});

  @override
  State<PagePedidoDetalhe> createState() => _PagePedidoDetalheState();
}

class _PagePedidoDetalheState extends State<PagePedidoDetalhe> {
  List<PedidoDetalhesModel> pedido = [];
  String nomeCliente = "";
  String stringObservacoes = "";
  double totalgeral = 0;
  double desconto = 0;
  double totalprodutos = 0;
  int qtdItens = 0;
  String idPedido = "";
  String dataemicao = "";
  String statuspedido = "";
  double valorFrete = 0;

  UtilsServices utilsServices = UtilsServices();

  bool isLoadingProdutos = true;

  @override
  void initState() {
    super.initState();
    carregaProdutosCarrinho();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> comprarNovamente() async {
    try {
      int idPedidoVem = Get.arguments['idPedido'];
      pedido = await pedidosControler.getProdutosPedidos(idPedidoVem);

      for (var produto in pedido) {
        ProdutosModel produtox = ProdutosModel();

        produtox =
            (await pageProdutosController.getProdutos(produto.gtin, "", "", 1))
                .first;

        carrinhoControler.addItemCarrinho(produtox, produto.qtdDouble);
      }

      // Mostra mensagem de sucesso com botão para ir ao carrinho
      Get.snackbar(
        'Sucesso!',
        'Produtos adicionados ao carrinho',
        backgroundColor: CustomColors.colorBottonCompra,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 7),
        snackPosition: SnackPosition.TOP,
        mainButton: TextButton(
          onPressed: () {
            Get.back(); // Fecha o pedido atual
            Get.toNamed('/carrinho'); // Navega para o carrinho
          },
          child: const Text(
            'IR PARA O CARRINHO',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } catch (e) {
      Util.callMessageSnackBar('Erro ao comprar novamente');
    }
  }

  Future<void> carregaProdutosCarrinho() async {
    try {
      setState(() {
        isLoadingProdutos = true;
      });

      int idPedidoVem = Get.arguments['idPedido'];
      pedido = await pedidosControler.getProdutosPedidos(idPedidoVem);

      // nomeCliente = pedido[0].nome;
      // stringObservacoes = pedido[0].obs;
      // totalgeral = double.parse(pedido[0].valortotalcomanda);
      // desconto = double.parse(pedido[0].valortotaldescontocomanda);
      // totalprodutos = double.parse(pedido[0].valortotalprodutoscomanda);
      // qtdItens = int.parse(pedido[0].qtditens.toString());
      // idPedido = pedido[0].id.toString();

      if (mounted) {
        setState(() {
          isLoadingProdutos = false;
          nomeCliente = pedido[0].nome;
          stringObservacoes = pedido[0].obs;
          valorFrete = double.parse(pedido[0].valorFrete);
          totalgeral = double.parse(pedido[0].valortotalcomanda) + valorFrete;
          desconto = double.parse(pedido[0].valortotaldescontocomanda);

          totalprodutos = double.parse(pedido[0].valortotalprodutoscomanda);
          qtdItens = int.parse(pedido[0].qtditens.toString());
          idPedido = pedido[0].id.toString();
          dataemicao = pedido[0].dataemicao;
          statuspedido = pedido[0].status;
        });
      }
    } catch (e) {
      Util.callMessageSnackBar('Erro ao carregar produtos');
    }
  }

  // Funções auxiliares para status de pedidos
  Color _getStatusColor(String status) {
    switch (status) {
      case 'A':
        return Colors.green;
      case 'P':
        return Colors.orange;
      case 'C':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'A':
        return Icons.check_circle;
      case 'P':
        return Icons.hourglass_empty;
      case 'C':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho com título, data, status e nome do cliente - design melhorado
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título do pedido com botão de voltar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: CustomColors.colorBottonCompra,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Pedido #$idPedido",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.colorBottonCompra,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Informações do cliente
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            nomeCliente,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Data e status em cards lado a lado
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      children: [
                        // Data do pedido
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: CustomColors.colorFundo.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    dataemicao,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Status do pedido
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: _getStatusColor(statuspedido)
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _getStatusColor(statuspedido)
                                    .withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _getStatusIcon(statuspedido),
                                  size: 16,
                                  color: _getStatusColor(statuspedido),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    pedidosControler
                                        .converRetornaStatus(statuspedido),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _getStatusColor(statuspedido),
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
                ],
              ),
            ),

            // Lista de produtos (removido o cabeçalho redundante)
            Expanded(
              child: !isLoadingProdutos
                  ? ListView.builder(
                      itemCount: pedido.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product code and description
                                Row(
                                  children: [
                                    Container(
                                      width: 110,
                                      margin: const EdgeInsets.only(right: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Código:",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            pedido[index].gtin,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: CustomColors.colorIcons,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Descrição:",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            pedido[index].descricao,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: CustomColors.colorIcons,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // Product values
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Quantity
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Qtd",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          pedido[index].qtd,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: CustomColors.colorIcons,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Unit price
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Valor Unit.",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          utilsServices.toFixed(
                                              pedido[index].valor, 2),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: CustomColors.colorIcons,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Discount
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Desconto",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          '${pedido[index].desconto}%',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Total
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          "Total",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          utilsServices.toFixed(
                                              pedido[index].total, 2),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                CustomColors.colorBottonCompra,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            //observacoes
            if (stringObservacoes != "")
              Container(
                margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.amber.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.comment,
                                size: 16,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                "Observações",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ExpandableText(
                            stringObservacoes,
                            expandText: 'mostrar mais',
                            collapseText: 'mostrar menos',
                            animation: true,
                            maxLines: 2,
                            linkColor: Colors.blue,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Resumo do pedido (totais)
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Cabeçalho do resumo
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  //   child: Row(
                  //     children: [
                  //       const Icon(
                  //         Icons.receipt_long,
                  //         size: 18,
                  //         color: CustomColors.colorBottonCompra,
                  //       ),
                  //       const SizedBox(width: 8),
                  //       const Text(
                  //         "Resumo do Pedido",
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.bold,
                  //           color: CustomColors.colorBottonCompra,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  const Divider(height: 1),

                  // Itens do resumo
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Sub Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Sub Total:",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              utilsServices.toFixed(
                                  totalprodutos.toString(), 2),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),

                        // Desconto
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Desconto:",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              utilsServices.toFixed(desconto.toString(), 2),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),

                        // Frete
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Frete:",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              utilsServices.toFixed(valorFrete.toString(), 2),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),

                        // Quantidade de itens
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Itens:",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "$qtdItens ${qtdItens == 1 ? 'item' : 'itens'}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Divider(thickness: 1),
                        ),

                        // Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.colorBottonCompra,
                              ),
                            ),
                            Text(
                              utilsServices.toFixed(totalgeral.toString(), 2),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.colorBottonCompra,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Botões
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      children: [
                        // Comprar Novamente button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              comprarNovamente();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.colorBottonCompra,
                              foregroundColor: CustomColors.colorTextoPrimario,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                            icon: const Icon(Icons.shopping_cart, size: 20),
                            label: const Text(
                              'Comprar Novamente',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.colorTextoPrimario,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Close button
                        SizedBox(
                          width: 100,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                            icon: const Icon(Icons.close, size: 20),
                            label: const Text(
                              'Fechar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
