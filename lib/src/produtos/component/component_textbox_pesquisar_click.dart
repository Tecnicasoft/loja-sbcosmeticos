import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/carrinho/controller/controller_page_carrinho.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/produtos/component/component_textbox_pesquisar.dart';
import 'package:petshop_template/src/routes/app_pages.dart';

class TextBoxPesquisarFixo extends StatefulWidget {
  final bool verButton;

  const TextBoxPesquisarFixo(this.verButton, {super.key});
  //const TextBoxPesquisarFixo({super.key});

  //final bool buttonBack;

  @override
  State<TextBoxPesquisarFixo> createState() => _TextBoxPesquisarFixoState();
}

class _TextBoxPesquisarFixoState extends State<TextBoxPesquisarFixo> {
  bool ocultarButoonBack = false;
  String nomeLoja = ConfigApp.nomeLoja;

  @override
  void initState() {
    super.initState();
    ocultarButoonBack = widget.verButton;
  }

  @override
  Widget build(BuildContext context) {
    //buttonBackVar = arguments['buttonBack'];
    return Container(
      height: 60,
      color: CustomColors.colorFundoPrimario,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                ocultarButoonBack
                    ? IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: CustomColors.colorIcons,
                        ),
                      )
                    : const SizedBox(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 35,
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(5),
                        shadowColor: CustomColors.colorFundo,
                        child: TextFormField(
                          controller: pageProdutosController.txtPesquisar,
                          readOnly: true,
                          onTap: () {
                            Get.toNamed(PageRoutes.produtosPesquisar,
                                arguments: {
                                  "tipo": "fixo",
                                });
                          },
                          // onFieldSubmitted: (value) {
                          //   carregaListaProdutosPromo(value);
                          // },
                          textInputAction: TextInputAction.search,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Pesquisar $nomeLoja',
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 0, bottom: 0, top: 0),
                            prefixIcon: const Icon(
                              Icons.search,
                              fill: 1,
                              color: CustomColors.colorIcons,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // IconButton(
                //   onPressed: () async {
                //     var result = await BarcodeScanner.scan();
                //     pageProdutosController.txtPesquisar.text =
                //         result.rawContent;
                //   },
                //   icon: const Icon(
                //     Icons.qr_code_scanner_sharp,
                //     color: CustomColors.colorIcons,
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 20, 5),
                  child: Obx(
                    () => GestureDetector(
                      onTap: () {
                        Get.toNamed(PageRoutes.carrinho);
                      },
                      child: badges.Badge(
                        ignorePointer: false,
                        position: badges.BadgePosition.topEnd(
                          top: 0,
                          end: 0,
                        ),
                        badgeContent: Text(
                          carrinhoDetailsControler.qtd.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                carrinhoDetailsControler.qtd > 9 ? 10 : 16,
                          ),
                        ),
                        badgeAnimation: const badges.BadgeAnimation.slide(
                          animationDuration: Duration(milliseconds: 2800),
                        ),
                        badgeStyle: const badges.BadgeStyle(
                          badgeColor: CustomColors.colorBottonCompra,
                          shape: badges.BadgeShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            Get.toNamed(PageRoutes.carrinho);
                          },
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                            size: 35,
                            color: CustomColors.colorIcons,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
