import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/produtos/component/component_textbox_pesquisar.dart';
import 'package:petshop_template/src/produtos/controller/controller_page_list_produtos.dart';
import 'package:petshop_template/src/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

PageProdutosController pageProdutosController = Get.find();

class PagePesquisarProdutos extends StatefulWidget {
  const PagePesquisarProdutos({super.key});

  @override
  State<PagePesquisarProdutos> createState() => _PagePesquisarProdutosState();
}

class _PagePesquisarProdutosState extends State<PagePesquisarProdutos> {
  dynamic argumentData = Get.arguments;
  String tipo = '';
  List<String> ultimasPesquisas = [];
  final PageProdutosController produtosController = Get.find();

  @override
  void initState() {
    super.initState();
    if (argumentData != null) {
      tipo = argumentData['idCategoria'].toString();
    }

    // Carregar as últimas pesquisas do SharedPreferences
    _carregarUltimasPesquisas();
  }

  // Carregar as últimas pesquisas salvas
  Future<void> _carregarUltimasPesquisas() async {
    final prefs = await SharedPreferences.getInstance();
    final pesquisas = prefs.getStringList('ultimas_pesquisas') ?? [];

    setState(() {
      ultimasPesquisas = pesquisas;
    });
  }

  // Salvar uma nova pesquisa no histórico
  Future<void> _salvarPesquisa(String termo) async {
    if (termo.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();

    // Recuperar a lista atual
    List<String> pesquisas = prefs.getStringList('ultimas_pesquisas') ?? [];

    // Remover o termo se já existir (para não duplicar)
    pesquisas.remove(termo);

    // Adicionar o novo termo no início da lista
    pesquisas.insert(0, termo);

    // Limitar a lista às últimas 10 pesquisas
    if (pesquisas.length > 10) {
      pesquisas = pesquisas.sublist(0, 10);
    }

    // Salvar a lista atualizada
    await prefs.setStringList('ultimas_pesquisas', pesquisas);

    // Atualizar a lista na interface
    setState(() {
      ultimasPesquisas = pesquisas;
    });
  }

  // Realizar a pesquisa com um termo selecionado do histórico
  void _pesquisarTermo(String termo) {
    produtosController.txtPesquisar.text = termo;
    Get.offNamed(
      PageRoutes.produtosCategoriasPesquisar,
      arguments: {
        "idCategoria": 0,
        "index": 0,
        "nomeCategoria": termo,
        "qrcode": "0"
      },
    );

    // Salvar a pesquisa no histórico quando selecionada
    _salvarPesquisa(termo);
  }

  // Remover um termo do histórico
  Future<void> _removerPesquisa(String termo) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> pesquisas = prefs.getStringList('ultimas_pesquisas') ?? [];
    pesquisas.remove(termo);
    await prefs.setStringList('ultimas_pesquisas', pesquisas);

    setState(() {
      ultimasPesquisas = pesquisas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.colorFundoPrimario,
        title: WidgetSearchWithCallback(
            pesquisar: true,
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                _salvarPesquisa(value);
              }
            }),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Botão de escanear código de barras
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    var result = await BarcodeScanner.scan();
                    if (result.rawContent == "") {
                      return;
                    }

                    // Salvar o código de barras escaneado no histórico
                    if (result.rawContent.isNotEmpty) {
                      _salvarPesquisa(result.rawContent);
                    }

                    Get.offAndToNamed(
                      PageRoutes.produtosCategoriasPesquisar,
                      arguments: {
                        "idCategoria": 0,
                        "index": 0,
                        "nomeCategoria": result.rawContent,
                        "qrcode": "1"
                      },
                    );
                  },
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
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Escanear Código de Barras'),
                ),
              ),
            ),

            // Título para a seção de pesquisas recentes
            if (ultimasPesquisas.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Pesquisas recentes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

            // Lista de pesquisas recentes
            Expanded(
              child: ListView.builder(
                itemCount: ultimasPesquisas.length,
                itemBuilder: (context, index) {
                  final termo = ultimasPesquisas[index];
                  return ListTile(
                    leading: const Icon(Icons.history, color: Colors.grey),
                    title: Text(termo),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => _removerPesquisa(termo),
                    ),
                    onTap: () => _pesquisarTermo(termo),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
