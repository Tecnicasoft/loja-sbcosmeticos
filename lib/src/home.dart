import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/carrinho/models/model_carrinho_details.dart';
import 'package:petshop_template/src/carrinho/view/page_carrinho.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/empresas/view/page_lojas.dart';
import 'package:petshop_template/src/menu/view/page_menu.dart';
import 'package:petshop_template/src/pedidos/view/page_pedidos.dart';
import 'package:petshop_template/src/pets/view/page_pets.dart';
import 'package:petshop_template/src/produtos/view/page_categorias.dart';
import 'package:petshop_template/src/produtos/view/page_produtos_promo.dart';
import 'package:shared_preferences/shared_preferences.dart';

int _index = 0;
CarrinhoDetails carrinhoDetailsControler = Get.put(CarrinhoDetails());

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  dynamic argumentData = Get.arguments;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    if (argumentData != null) {
      _index = int.parse(argumentData['index'].toString());
    }
    carregaQtdItensCarrinho();
    verificaPrimeiraCompraClientePopUpAviso();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> verificaPrimeiraCompraClientePopUpAviso() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String clientePrimeiraCompra =
        prefs.getString('clienteJaFezCompra').toString();
    String valorPorcentagemDescontoPrimeiraCompra =
        prefs.getString('valorPorcentagemDescontoPrimeiraCompra').toString();
    if (clientePrimeiraCompra == 'False') {
      await prefs.setString('clienteJaFezCompra', 'true');
      Get.dialog(
        Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: CustomColors.colorFundoPrimario,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Icon(Icons.celebration,
                      color: CustomColors.colorIcons, size: 48),
                ),
                const SizedBox(height: 16),
                Text(
                  'Seu Presente de Boas-Vindas!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.colorIcons,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Você ganhou $valorPorcentagemDescontoPrimeiraCompra% de desconto especial para sua primeira compra! Ele será aplicado automaticamente no seu carrinho. Aproveite!',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.colorFundoPrimario,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      'Entendi',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  Future<void> carregaQtdItensCarrinho() async {
    carrinhoDetailsControler.qtd =
        int.parse(await carrinhoControler.getQtdItensCarrinho());
  }

  final List<Widget> _widgetOptions = <Widget>[
    const PageProdutosPromo(),
    const PageCategorias(),
    const PagePedidos(),
    const PageLojas(),
    const PagePets(),
    const MenuPage(), // Menu agora é o último item
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho com imagem logo (opcional - descomente se quiser usar)
            // Container(
            //   height: 60,
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.grey.withOpacity(0.1),
            //         spreadRadius: 1,
            //         blurRadius: 3,
            //         offset: const Offset(0, 2),
            //       ),
            //     ],
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Image.asset('assets/images/Logo600x600.png'),
            //   ),
            // ),

            // Conteúdo principal
            Expanded(
              child: _widgetOptions.elementAt(_index),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar moderno
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, -1),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _index,
            backgroundColor: CustomColors.colorFundoPrimario,
            selectedItemColor: CustomColors.colorIcons,
            unselectedItemColor: CustomColors.colorIcons.withOpacity(0.7),
            selectedFontSize: 12,
            unselectedFontSize: 12,
            elevation: 0,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                label: 'Início',
                activeIcon: _buildActiveIcon(Icons.home),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.list_alt_rounded),
                label: 'Categorias',
                activeIcon: _buildActiveIcon(Icons.list_alt_rounded),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.shopping_bag_outlined),
                label: 'Pedidos',
                activeIcon: _buildActiveIcon(Icons.shopping_bag),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.storefront_outlined),
                label: 'Lojas',
                activeIcon: _buildActiveIcon(Icons.storefront),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.pets_outlined),
                label: 'Meus Pets',
                activeIcon: _buildActiveIcon(Icons.pets),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.menu),
                label: 'Menu',
                activeIcon: _buildActiveIcon(Icons.menu_open),
              ),
            ],
            onTap: (int index) {
              setState(() {
                _index = index;
                _animationController.forward(from: 0.0);
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActiveIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: CustomColors.colorIcons.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: CustomColors.colorIcons,
      ),
    );
  }
}
