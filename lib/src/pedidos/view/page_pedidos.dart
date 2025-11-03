import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/pedidos/controller/controller_page_pedidos.dart';
import 'package:petshop_template/src/pedidos/models/model_pedido.dart';
import 'package:petshop_template/src/routes/app_pages.dart';
import 'package:petshop_template/src/services/service_utils.dart';
import 'package:petshop_template/src/shared/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

PedidosControler pedidosControler = Get.put(PedidosControler());

class PagePedidos extends StatefulWidget {
  const PagePedidos({super.key});

  @override
  State<PagePedidos> createState() => _PagePedidosState();
}

class _PagePedidosState extends State<PagePedidos> {
  List<PedidoModel> item = [];
  List<PedidoModel> itemtemp = [];

  UtilsServices utilsServices = UtilsServices();
  int dias = 30;
  String diasFiltroPedidos = '';
  String qtdPedidosString = '';
  bool isLoadingProdutos = true;
  String textopesquisa = '';
  bool usuarioTempLogodo = false;

  @override
  void initState() {
    super.initState();
    diasFiltroPedidos = 'Últimas 24 horas';
    getAllPedidos();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getAllPedidos() async {
    try {
      setState(() {
        qtdPedidosString = '';
        isLoadingProdutos = true;
      });

      await verificaUsuarioTemp().then(
        (onValue) {
          if (onValue == true) {
            //Util.callMessageSnackBar(
            //  'Por favor, faça o login para acessar seus pedidos.');
            setState(() {
              isLoadingProdutos = false;
              usuarioTempLogodo = true;
            });
            return;
          }
        },
      );

      DateTime now = DateTime.now();
      DateTime startDate = now.subtract(Duration(days: dias));
      DateTime endDate = now;
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      String formattedStartDate = formatter.format(startDate);
      String formattedEndDate = formatter.format(endDate);

      itemtemp = await pedidosControler.getAllPedidos(
          formattedStartDate, formattedEndDate);

      //item = itemtemp;
      filterSearchResults(textopesquisa);

      if (item.isEmpty) {
        isLoadingProdutos = false;
        qtdPedidosString = '';
        return;
      }
      setState(() {
        isLoadingProdutos = false;
        qtdPedidosString = ' (${item.length} pedidos)';
      });
    } catch (e) {
      Util.callMessageSnackBar('Erro ao carregar os pedidos');
    }
  }

  void filterSearchResults(String query) {
    setState(() {
      item = itemtemp
          .where((item) =>
              item.nome.toLowerCase().contains(query.toLowerCase()) ||
              item.cpfcnpj.toLowerCase().contains(query.toLowerCase()) ||
              item.id.toString().contains(query.toLowerCase()))
          .toList();
      qtdPedidosString = ' (${item.length} pedidos)';
    });
  }

  Future<bool> verificaUsuarioTemp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tempUser = prefs.getString('tempUser');
    if (tempUser == 'true') {
      usuarioTempLogodo = true;
      return true;
    }
    usuarioTempLogodo = false;
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.shopping_bag,
                          color: CustomColors.colorBottonCompra,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Meus Pedidos",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.colorBottonCompra,
                              ),
                            ),
                            if (usuarioTempLogodo == false &&
                                !isLoadingProdutos)
                              Text(
                                '$diasFiltroPedidos$qtdPedidosString',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    if (usuarioTempLogodo == false)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.filter_list_alt,
                            color: CustomColors.colorBottonCompra,
                          ),
                          onPressed: () {
                            showListaFiltro(context);
                          },
                          tooltip: "Filtrar pedidos",
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Barra de pesquisa removida conforme solicitado

            // Conteúdo principal
            if (usuarioTempLogodo == true)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Ícone ilustrativo
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color:
                              CustomColors.colorFundoPrimario.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 70,
                          color: CustomColors.colorFundoPrimario,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Título da mensagem
                      const Text(
                        'Acesse seus pedidos',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      // Mensagem descritiva
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Faça login para visualizar seu histórico de compras e acompanhar seus pedidos.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Botão de login modernizado
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            Get.toNamed(PageRoutes.login);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.colorBottonCompra,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.login_rounded),
                              const SizedBox(width: 8),
                              Text(
                                "Fazer Login",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  //color: CustomColors.colorBottonCompra,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (isLoadingProdutos)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (item.isEmpty)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Ícone ilustrativo
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.search_off_rounded,
                          size: 70,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Título da mensagem
                      const Text(
                        'Nenhum pedido encontrado',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 14),

                      // Mensagem descritiva
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Não encontramos pedidos para o período "$diasFiltroPedidos".\nTente alterar o filtro para buscar em outros períodos.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Botão para filtrar
                      SizedBox(
                        width: 180,
                        height: 45,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showListaFiltro(context);
                          },
                          icon: const Icon(
                            Icons.filter_list_alt,
                            size: 20,
                          ),
                          label: const Text(
                            "Alterar filtro",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.colorBottonCompra,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
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
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: item.length,
                    itemBuilder: (context, index) {
                      final pedido = item[index];
                      return _buildOrderCard(context, pedido);
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget para construir o card de pedido
  Widget _buildOrderCard(BuildContext context, PedidoModel pedido) {
    Color statusColor = _getStatusColor(pedido.status);
    String statusText = pedidosControler.converRetornaStatus(pedido.status);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.toNamed(
            PageRoutes.pagePedidosDetalhe,
            arguments: {
              "idPedido": pedido.id,
              "nomeCliente": pedido.nome,
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Data do pedido
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        Util.convertirDataParaDataExtenso(pedido.dataemicao),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  // Status
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: statusColor.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 10),

              // Número do pedido
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.receipt_long,
                        size: 18,
                        color: CustomColors.colorBottonCompra,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Pedido #${pedido.id}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  // Seta para direita
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),

              // Observações do pedido (se existirem)
              if (pedido.obs.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.comment,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          pedido.obs,
                          style: TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.normal,
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Função auxiliar para determinar a cor do status
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

  Future<dynamic> showListaFiltro(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Barra indicadora de modal
              Container(
                margin: const EdgeInsets.only(top: 8),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Cabeçalho do modal
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.filter_list_alt,
                      color: CustomColors.colorBottonCompra,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Filtrar por período",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Opções de filtro
              _buildFilterOption(
                title: 'Últimos 30 dias',
                icon: Icons.date_range,
                isSelected: diasFiltroPedidos == 'Últimos 30 dias',
                onTap: () {
                  setState(() {
                    diasFiltroPedidos = 'Últimos 30 dias';
                    dias = 30;
                    getAllPedidos();
                  });
                  Navigator.pop(context);
                },
              ),

              _buildFilterOption(
                title: 'Últimos 6 meses',
                icon: Icons.calendar_month,
                isSelected: diasFiltroPedidos == 'Últimos 6 meses',
                onTap: () {
                  setState(() {
                    diasFiltroPedidos = 'Últimos 6 meses';
                    dias = 180;
                    getAllPedidos();
                  });
                  Navigator.pop(context);
                },
              ),

              _buildFilterOption(
                title: 'Últimos 12 meses',
                icon: Icons.calendar_today,
                isSelected: diasFiltroPedidos == 'Últimos 12 meses',
                onTap: () {
                  setState(() {
                    diasFiltroPedidos = 'Últimos 12 meses';
                    dias = 365;
                    getAllPedidos();
                  });
                  Navigator.pop(context);
                },
              ),

              _buildFilterOption(
                title: 'Todos os pedidos',
                icon: Icons.history,
                isSelected: diasFiltroPedidos == 'Todos os pedidos',
                onTap: () {
                  setState(() {
                    diasFiltroPedidos = 'Todos os pedidos';
                    dias = 5000;
                    getAllPedidos();
                  });
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // Widget para opções de filtro
  Widget _buildFilterOption({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? CustomColors.colorBottonCompra : Colors.grey,
        size: 20,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? CustomColors.colorBottonCompra : Colors.black87,
        ),
      ),
      trailing: isSelected
          ? const Icon(
              Icons.check_circle,
              color: CustomColors.colorBottonCompra,
              size: 20,
            )
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      dense: true,
    );
  }
}
