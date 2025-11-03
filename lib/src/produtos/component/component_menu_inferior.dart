import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/routes/app_pages.dart';

class MenuInferior extends StatefulWidget {
  const MenuInferior({super.key});

  @override
  State<MenuInferior> createState() => _MenuInferiorState();
}

class _MenuInferiorState extends State<MenuInferior> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: CustomColors.colorFundoPrimario,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: CustomColors.colorIcons,
            ),
            label: const Text(
              'Voltar',
              style: TextStyle(
                color: CustomColors.colorIcons,
                fontSize: 14,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Get.toNamed(PageRoutes.baseRoute, arguments: {
                "index": 1,
              });
            },
            icon: const Icon(
              Icons.list_alt_rounded,
              color: CustomColors.colorIcons,
            ),
            label: const Text(
              'Categorias',
              style: TextStyle(
                color: CustomColors.colorIcons,
                fontSize: 14,
              ),
            ),
          ),
          // TextButton.icon(
          //   onPressed: () {
          //     Get.toNamed(PageRoutes.baseRoute, arguments: {
          //       "index": 2,
          //     });
          //   },
          //   icon: const Icon(
          //     Icons.shopping_cart_outlined,
          //     color: CustomColors.colorBottonCompra,
          //   ),
          //   label: const Text(
          //     'Carrinho',
          //     style: TextStyle(
          //       color: CustomColors.colorBottonCompra,
          //       fontSize: 14,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
