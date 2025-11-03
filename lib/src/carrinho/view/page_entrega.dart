import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/carrinho/controller/controller_page_carrinho.dart';
import 'package:petshop_template/src/carrinho/models/model_endereco_entrega.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/routes/app_pages.dart';
import 'package:petshop_template/src/shared/util.dart';

class PageEntrega extends StatefulWidget {
  const PageEntrega({super.key});

  @override
  State<PageEntrega> createState() => _PageEntregaState();
}

class _PageEntregaState extends State<PageEntrega> {
  CarrinhoControler carrinhoControler = Get.put(CarrinhoControler());
  List<EnderecoEntregaModel> enderecoEntregaModel = [];
  String? selectedEndereco;
  int indexSelect = 0;
  bool isLoading = true;
  String? observacaoEntrega;
  double valorFretePadrao = 0;
  double valorTotal = 0;
  double valorFrete = 0;
  double valorTotalPassa = 0;

  @override
  void initState() {
    super.initState();
    _loadEnderecos();
    valorFretePadrao = Get.arguments['frete'] ?? 0;
    valorTotal = Get.arguments['total'] ?? 0;
  }

  Future<void> _loadEnderecos() async {
    try {
      enderecoEntregaModel =
          await carrinhoControler.retornaEnderecoEntregaCliente();

      // Adiciona opção extra para observação personalizada
      enderecoEntregaModel.add(
        EnderecoEntregaModel(
          idLoja: -2, // id especial para identificar
          nome: 'Clique aqui para adicionar outro endereço de entrega',
          endereco1: '',
          endereco2: '',
          entrega: true,
          idLojaEntrega: -2,
        ),
      );

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      Util.callMessageSnackBar('Erro ao carregar endereços');
      setState(() {
        isLoading = false;
        //voltar para a tela anterior
        Get.back();
      });
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
                          "Entrega",
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
                          Icons.location_on,
                          color: Colors.grey,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Escolha como deseja receber seu pedido",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Conteúdo principal
            isLoading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: Container(
                      color: Colors.grey.shade50,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        itemCount: enderecoEntregaModel.length,
                        itemBuilder: (context, index) {
                          if (enderecoEntregaModel[index].idLoja == -2) {
                            // Opção personalizada
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 6.0, horizontal: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: selectedEndereco == 'personalizado'
                                      ? CustomColors.colorBottonCompra
                                          .withOpacity(0.5)
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              elevation: 2,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  setState(() {
                                    selectedEndereco = 'personalizado';
                                    indexSelect = index;
                                  });
                                  final TextEditingController obsController =
                                      TextEditingController(
                                          text: observacaoEntrega ?? "");
                                  showDialogOutroEndereco(
                                      context, obsController);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: Icon(
                                          Icons.edit_location_alt,
                                          color: CustomColors.colorBottonCompra,
                                          size: 28,
                                        ),
                                        title: Text(
                                          enderecoEntregaModel[index].nome,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      RadioListTile<String>(
                                        title: Text(
                                          observacaoEntrega ?? '',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        value: 'personalizado',
                                        groupValue: selectedEndereco,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedEndereco = value;
                                            indexSelect = index;
                                          });
                                        },
                                        activeColor:
                                            CustomColors.colorBottonCompra,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: selectedEndereco ==
                                        enderecoEntregaModel[index].endereco2
                                    ? CustomColors.colorBottonCompra
                                        .withOpacity(0.5)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            elevation: 2,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                setState(() {
                                  selectedEndereco =
                                      enderecoEntregaModel[index].endereco2;
                                  indexSelect = index;
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(
                                        enderecoEntregaModel[index].entrega ==
                                                true
                                            ? Icons.local_shipping
                                            : Icons.store,
                                        color: CustomColors.colorBottonCompra,
                                        size: 28,
                                      ),
                                      title: Text(
                                        enderecoEntregaModel[index].nome,
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    RadioListTile<String>(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            enderecoEntregaModel[index]
                                                .endereco1,
                                            style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            enderecoEntregaModel[index]
                                                .endereco2,
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      value:
                                          enderecoEntregaModel[index].endereco2,
                                      groupValue: selectedEndereco,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedEndereco = value;
                                          indexSelect = index;
                                        });
                                      },
                                      activeColor:
                                          CustomColors.colorBottonCompra,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

            // Botão de continuar
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
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      valorTotalPassa = 0;
                      if (selectedEndereco != null) {
                        if (selectedEndereco == 'personalizado') {
                          if (observacaoEntrega == null ||
                              observacaoEntrega!.isEmpty) {
                            Util.callMessageSnackBar(
                              'Por favor, insira um endereço para entrega personalizada.',
                            );
                            return;
                          }
                          // Opção personalizada
                          valorFrete = valorFretePadrao;
                          valorTotalPassa = valorTotal;
                          Get.toNamed(
                            PageRoutes.pageCarrinhoPagamento,
                            arguments: {
                              'total': valorTotalPassa,
                              'frete': valorFrete,
                              'endereco': observacaoEntrega,
                              'idLoja': 1,
                              'entrega': true,
                              'observacaoEntrega': '',
                            },
                          );
                        } else {
                          if (enderecoEntregaModel[indexSelect].entrega ==
                              false) {
                            valorTotalPassa = valorTotal - valorFretePadrao;
                            valorFrete = 0;
                          } else {
                            valorFrete = valorFretePadrao;
                            valorTotalPassa = valorTotal;
                          }
                          Get.toNamed(
                            PageRoutes.pageCarrinhoPagamento,
                            arguments: {
                              'total': valorTotalPassa,
                              'frete': valorFrete,
                              'endereco':
                                  '${enderecoEntregaModel[indexSelect].endereco1} ${enderecoEntregaModel[indexSelect].endereco2}',
                              if (enderecoEntregaModel[indexSelect].entrega ==
                                  true)
                                'idLoja': enderecoEntregaModel[indexSelect]
                                    .idLojaEntrega
                              else
                                'idLoja':
                                    enderecoEntregaModel[indexSelect].idLoja,
                              'entrega':
                                  enderecoEntregaModel[indexSelect].entrega,
                              if (observacaoEntrega != null &&
                                  observacaoEntrega!.isNotEmpty)
                                'observacaoEntrega': observacaoEntrega,
                            },
                          );
                        }
                      } else {
                        Util.callMessageSnackBar(
                          'Por favor, selecione um endereço de entrega.',
                        );
                      }
                    },
                    icon: const Icon(Icons.payment),
                    label: const Text(
                      'Escolher forma de pagamento',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDialogOutroEndereco(
      BuildContext context, TextEditingController obsController) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.edit_location_alt,
                        color: CustomColors.colorBottonCompra, size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      'Endereço para entrega',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.colorBottonCompra,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: obsController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Digite aqui o endereço ou referência...',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: CustomColors.colorBottonCompra),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close, color: Colors.grey),
                      label: const Text('Cancelar',
                          style: TextStyle(color: Colors.grey)),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          observacaoEntrega = obsController.text.trim();
                        });
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Salvar',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.colorBottonCompra,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
