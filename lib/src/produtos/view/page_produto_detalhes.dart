import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/carrinho/controller/controller_page_carrinho.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/produtos/component/component_textbox_pesquisar_click.dart';
import 'package:petshop_template/src/produtos/controller/controller_page_list_produtos.dart';
import 'package:petshop_template/src/produtos/models/model_fotos.dart';
import 'package:petshop_template/src/produtos/models/model_produtos.dart';
import 'package:petshop_template/src/services/service_utils.dart';
import 'package:petshop_template/src/shared/util.dart';

const List<String> listQuantidade = <String>[
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10'
];
String dropdownValue = listQuantidade.first;
bool colocandoNocarrinho = false;

class PageProdutoDetalhes extends StatefulWidget {
  const PageProdutoDetalhes({super.key});

  @override
  State<PageProdutoDetalhes> createState() => _PageProdutoDetalhesState();
}

class _PageProdutoDetalhesState extends State<PageProdutoDetalhes> {
  final ProdutosModel produto = Get.find();
  final PageProdutosController pageProdutosController = Get.find();
  final CarrinhoControler carrinhoControler = Get.find();
  //final CarouselController buttonCarouselController = CarouselController();
  final cs.CarouselSliderController buttonCarouselController =
      cs.CarouselSliderController();

  List<FotoModel> fotos = [];
  int _currentIndex = 1;

  @override
  void initState() {
    carregaFotos(produto.id.toString());
    super.initState();
    //dropdownValue = list.first;
  }

  @override
  void dispose() {
    super.dispose();
    dropdownValue = listQuantidade.first;
  }

  Future<void> carregaFotos(String find) async {
    try {
      fotos = await pageProdutosController.getFotosProdutos(find);
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      Util.callMessageSnackBar('Erro ao carregar o produto categorias');
    }
  }

  @override
  Widget build(BuildContext context) {
    UtilsServices utilsServices = UtilsServices();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Barra de Pesquisa
            const TextBoxPesquisarFixo(true),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: cs.CarouselSlider(
                  options: cs.CarouselOptions(
                    disableCenter: true,
                    enableInfiniteScroll: false,
                    viewportFraction: 1.0,
                    scrollDirection: Axis.horizontal,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    autoPlay: false,
                    autoPlayInterval: const Duration(seconds: 3),
                    initialPage: 0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index + 1;
                      });
                    },
                  ),
                  carouselController: buttonCarouselController,
                  items: fotos
                      .map((item) => Center(
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    backgroundColor: Colors.black,
                                    insetPadding: EdgeInsets.zero,
                                    child: Stack(
                                      children: [
                                        SizedBox.expand(
                                          child: InteractiveViewer(
                                            child: Image.network(
                                              item.foto,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 20,
                                          right: 20,
                                          child: IconButton(
                                            icon: const Icon(Icons.close,
                                                color: Colors.white, size: 32),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Image.network(
                                item.foto,
                                fit: BoxFit.contain,
                                width: 1000,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),

            //create circle current position corrousel
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: fotos.map((url) {
                int index = fotos.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index + 1
                        ? CustomColors.colorFundoShadow
                        : CustomColors.colorFundoPrimario,
                  ),
                );
              }).toList(),
            ),

            //Container com a descricao e o preco
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          produto.descricao,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.textoBottao),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          produto.codigo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.textoBottao),
                        ),
                      ),
                      if (produto.promoAtiva == 1)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                utilsServices.toFixed(produto.valorBruto, 2),
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
                                              double.parse(
                                                  produto.valorPorDesconto)),
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
                              utilsServices.toFixed(produto.valorFinal, 2),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      //Botao Quantidade
                      const DropdownButtonExample(),

                      // Campo de texto para descrição detalhada do produto

                      //Botao Adicionar ao carrinho
                      ElevatedButton.icon(
                        onPressed: colocandoNocarrinho
                            ? null
                            : () async {
                                setState(() {
                                  colocandoNocarrinho = true;
                                });

                                await carrinhoControler.addItemCarrinho(
                                    produto, double.parse(dropdownValue));

                                setState(() {
                                  colocandoNocarrinho = false;
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: CustomColors.colorFundoShadow,
                        ),
                        label: !colocandoNocarrinho
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

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Scrollbar(
                          thickness: 8,
                          thumbVisibility: false,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                produto.utilidade,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: CustomColors.colorBottonCompra,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  //String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Quantidade: "),
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 30,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            underline: Container(
              height: 0,
              color: Colors.grey,
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value!;
              });
            },
            items: listQuantidade.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
