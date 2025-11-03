import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/main.dart';
import 'package:petshop_template/src/carrinho/models/model_carrinho_details.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/routes/app_pages.dart';
import 'package:petshop_template/src/services/service_utils.dart';
import 'package:petshop_template/src/shared/util.dart';

CarrinhoDetails carrinhoDetailsControler = Get.put(CarrinhoDetails());

class PageFormaPagamento extends StatefulWidget {
  const PageFormaPagamento({super.key});

  @override
  State<PageFormaPagamento> createState() => _PageEntregaState();
}

class _PageEntregaState extends State<PageFormaPagamento> {
  final List<String> enderecos = [
    'Dinheiro',
    'Pix',
    'Cartão de Crédito',
    'Cartão de Débito'
  ];
  String? valorTroco;
  final TextEditingController trocoController = TextEditingController();
  String? selectedFormaPagamento;
  String? selectedEnderecoEntrega;
  bool? selectEntrega;
  int? selectedIdLoja;
  UtilsServices util = UtilsServices();
  final uri = Util.uri;
  bool finalizaPedido = false;
  bool isLoadingProdutos = true;
  String? observacaoEntrega = "";
  double total = 0;
  double frete = 0;
  //double totalFinal = 0;

  @override
  void initState() {
    super.initState();
    selectedEnderecoEntrega = Get.arguments["endereco"] as String?;
    selectedIdLoja = Get.arguments["idLoja"] as int?;
    selectEntrega = Get.arguments["entrega"] as bool?;
    //observacaoEntrega = Get.arguments["observacaoEntrega"] as String?;
    if (Get.arguments["observacaoEntrega"] != null) {
      observacaoEntrega = Get.arguments["observacaoEntrega"] as String?;
    }
    total = Get.arguments["total"] as double;
    frete = Get.arguments["frete"] as double;
  }

  Future<void> finalizarPedido() async {
    try {
      setState(() {
        isLoadingProdutos = true;
        finalizaPedido = true;
      });

      var stringEntrega =
          selectEntrega == false ? 'Retirar na loja' : 'Entregar em';

      var valorFreteString =
          frete > 0 ? ' - Frete: ${util.toFixed(frete.toString(), 2)}' : '';

      var valorTrocoString = valorTroco != null && valorTroco!.isNotEmpty
          ? ' - Troco para: ${util.toFixed(valorTroco!, 2)}'
          : '';

      double valorFrete = frete > 0 ? frete : 0;

      await carrinhoControler.finalizarPedido(
          '$stringEntrega ${selectedEnderecoEntrega!} - ${selectedFormaPagamento!} $valorTrocoString ${observacaoEntrega!} $valorFreteString',
          selectedIdLoja!,
          valorFrete);
      if (mounted) {
        finalizaPedido = false;
        Util.callMessageSnackBar('Pedido salvo com sucesso');
        Get.toNamed(PageRoutes.baseRoute);
      }
    } catch (e) {
      Util.callMessageSnackBar('Erro ao finalizar pedido');
    }
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Botão voltar e título
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Get.back(),
                          borderRadius: BorderRadius.circular(50),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: CustomColors.colorBottonCompra,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Pagamento",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.colorBottonCompra,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Subtítulo explicativo
                    Row(
                      children: [
                        const Icon(
                          Icons.payment,
                          color: Colors.grey,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Escolha como deseja pagar seu pedido",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    // Endereço de entrega selecionado
                    if (selectedEnderecoEntrega != null)
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              selectEntrega == false
                                  ? Icons.store
                                  : Icons.local_shipping,
                              color: CustomColors.colorBottonCompra,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectEntrega == false
                                        ? 'Retirar na loja'
                                        : 'Entregar em',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    selectedEnderecoEntrega!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.attach_money,
                            color: CustomColors.colorBottonCompra,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Frete:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      util.toFixed(frete.toString(), 2),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: CustomColors.colorBottonCompra,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Valor total: (produtos + frete)',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      util.toFixed(total.toString(), 2),
                                      style: const TextStyle(
                                        fontSize: 14,
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
                  ],
                ),
              ),
            ),

            // Opções de pagamento
            Expanded(
              child: Container(
                color: Colors.grey.shade50,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: enderecos.length,
                  itemBuilder: (context, index) {
                    // Configurações do card de pagamento
                    IconData paymentIcon;
                    Color cardColor;

                    switch (enderecos[index]) {
                      case 'Dinheiro':
                        paymentIcon = Icons.money;
                        cardColor = Colors.green.shade50;
                        break;
                      case 'Pix':
                        paymentIcon = Icons.bolt;
                        cardColor = Colors.blue.shade50;
                        break;
                      case 'Cartão de Crédito':
                        paymentIcon = Icons.credit_card;
                        cardColor = Colors.purple.shade50;
                        break;
                      case 'Cartão de Débito':
                        paymentIcon = Icons.credit_card;
                        cardColor = Colors.orange.shade50;
                        break;
                      default:
                        paymentIcon = Icons.payment;
                        cardColor = Colors.grey.shade50;
                    }

                    return Column(
                      children: [
                        Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: selectedFormaPagamento == enderecos[index]
                                  ? CustomColors.colorBottonCompra
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          elevation: 2,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              setState(() {
                                selectedFormaPagamento = enderecos[index];
                              });
                            },
                            child: Container(
                              color: selectedFormaPagamento == enderecos[index]
                                  ? cardColor
                                  : Colors.white,
                              child: RadioListTile<String>(
                                title: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: cardColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        paymentIcon,
                                        color: Colors.black87,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      enderecos[index],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                value: enderecos[index],
                                groupValue: selectedFormaPagamento,
                                activeColor: CustomColors.colorBottonCompra,
                                onChanged: (value) {
                                  setState(() {
                                    selectedFormaPagamento = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        if (enderecos[index] == 'Dinheiro' &&
                            selectedFormaPagamento == 'Dinheiro')
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 4),
                            child: TextField(
                              controller: trocoController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Precisa de troco para quanto?',
                                hintText: 'Ex: 100.00',
                                prefixIcon: const Icon(Icons.attach_money),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade100,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  valorTroco = value;
                                });
                              },
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // Botão finalizar pedido
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: ElevatedButton.icon(
                onPressed: () {
                  if (selectedFormaPagamento == null) {
                    Util.callMessageSnackBar(
                        'Por favor, selecione uma forma de pagamento');
                    return;
                  }
                  _showConfirmationDialog(context);
                },
                icon: const Icon(Icons.check_circle),
                label: const Text(
                  'Finalizar Pedido',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.colorBottonCompra,
                  foregroundColor: CustomColors.colorTextoPrimario,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    // Salva valorTroco antes de finalizar
    if (selectedFormaPagamento == 'Dinheiro') {
      valorTroco = trocoController.text.trim();
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: CustomColors.colorBottonCompra,
                size: 28,
              ),
              const SizedBox(width: 8),
              const Text(
                "Confirmar pedido",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Por favor, confirme a finalização do seu pedido."),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      selectedFormaPagamento == 'Pix'
                          ? Icons.bolt
                          : selectedFormaPagamento == 'Dinheiro'
                              ? Icons.money
                              : Icons.credit_card,
                      size: 20,
                      color: CustomColors.colorBottonCompra,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      selectedFormaPagamento ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[800],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.colorBottonCompra,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _showLoadingDialog(context);
                finalizarPedido();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      CustomColors.colorBottonCompra),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Registrando pedido",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Aguarde um momento...",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
