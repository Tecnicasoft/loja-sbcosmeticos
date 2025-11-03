import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/produtos/controller/controller_page_list_produtos.dart';
import 'package:petshop_template/src/routes/app_pages.dart';

PageProdutosController pageProdutosController = Get.find();

class WidgetTextBoxPesquisarProduto extends StatefulWidget {
  const WidgetTextBoxPesquisarProduto({super.key, required this.pesquisar});

  final bool pesquisar;

  @override
  State<WidgetTextBoxPesquisarProduto> createState() =>
      _WidgetTextBoxPesquisarProdutoState();
}

class _WidgetTextBoxPesquisarProdutoState
    extends State<WidgetTextBoxPesquisarProduto> {
  //String textoPesquisa = "";
  String nomeLoja = ConfigApp.nomeLoja;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 35,
                child: TextFormField(
                  controller: pageProdutosController.txtPesquisar,
                  onFieldSubmitted: (value) {
                    Get.offNamed(
                      PageRoutes.produtosCategoriasPesquisar,
                      arguments: {
                        "idCategoria": 0,
                        "index": 0,
                        "nomeCategoria": value,
                        "qrcode": "0"
                      },
                    );
                  },
                  onTap: () {
                    if (!widget.pesquisar) {
                      Get.offAndToNamed(PageRoutes.produtosPesquisar);
                    } else {}
                  },
                  autofocus: true,
                  readOnly: widget.pesquisar ? false : true,
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
                        Radius.circular(5),
                      ),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    contentPadding:
                        const EdgeInsets.only(left: 0, bottom: 0, top: 0),
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
            // IconButton(
            //   onPressed: () async {
            //     var result = await BarcodeScanner.scan();
            //     if (result.rawContent == "") {
            //       return;
            //     }
            //     Get.offAndToNamed(
            //       PageRoutes.produtosCategoriasPesquisar,
            //       arguments: {
            //         "idCategoria": 0,
            //         "index": 0,
            //         "nomeCategoria": result.rawContent,
            //         "qrcode": "1"
            //       },
            //     );
            //   },
            //   icon: const Icon(
            //     Icons.qr_code_scanner_sharp,
            //     color: CustomColors.colorIcons,
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}

// Novo componente personalizado que recebe um callback para submissão
class WidgetSearchWithCallback extends StatefulWidget {
  const WidgetSearchWithCallback({
    super.key,
    required this.pesquisar,
    required this.onSubmitted,
  });

  final bool pesquisar;
  final Function(String) onSubmitted;

  @override
  State<WidgetSearchWithCallback> createState() =>
      _WidgetSearchWithCallbackState();
}

class _WidgetSearchWithCallbackState extends State<WidgetSearchWithCallback> {
  String nomeLoja = ConfigApp.nomeLoja;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 35,
                child: TextFormField(
                  controller: pageProdutosController.txtPesquisar,
                  onFieldSubmitted: (value) {
                    // Chamar o callback quando o usuário submeter a pesquisa
                    widget.onSubmitted(value);

                    // Navegar para a página de resultados
                    Get.offNamed(
                      PageRoutes.produtosCategoriasPesquisar,
                      arguments: {
                        "idCategoria": 0,
                        "index": 0,
                        "nomeCategoria": value,
                        "qrcode": "0"
                      },
                    );
                  },
                  onTap: () {
                    if (!widget.pesquisar) {
                      Get.offAndToNamed(PageRoutes.produtosPesquisar);
                    }
                  },
                  autofocus: true,
                  readOnly: widget.pesquisar ? false : true,
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
                        Radius.circular(5),
                      ),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    contentPadding:
                        const EdgeInsets.only(left: 0, bottom: 0, top: 0),
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
          ],
        ),
      ],
    );
  }
}
