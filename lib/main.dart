import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/carrinho/controller/controller_page_carrinho.dart';
import 'package:petshop_template/src/carrinho/models/model_carrinho.dart';
import 'package:petshop_template/src/carrinho/models/model_carrinho_details.dart';
import 'package:petshop_template/src/login/controller/controller_page_login.dart';
import 'package:petshop_template/src/login/models/model_cep.dart';
import 'package:petshop_template/src/menu/controller/controller_page_menu.dart';
import 'package:petshop_template/src/pedidos/controller/controller_page_pedidos.dart';
import 'package:petshop_template/src/produtos/controller/controller_page_list_produtos.dart';
import 'package:petshop_template/src/produtos/models/model_produtos.dart';
import 'package:petshop_template/src/routes/app_pages.dart';
import 'package:petshop_template/src/shared/util.dart';
//import 'package:shared_preferences/shared_preferences.dart';

String pageInit = PageRoutes.baseRoute;
LoginController loginController = Get.put(LoginController());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.delayed(const Duration(seconds: 3));

  await verificaSemUsuarioEstaLogado();
  await dotenv.load();
  //await GetStorage.init();
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.setString('clienteJaFezCompra', 'true');

  Get.put<ProdutosModel>(ProdutosModel());
  Get.put<CarrinhoModel>(CarrinhoModel());
  Get.put<PageProdutosController>(PageProdutosController());
  Get.put<PedidosControler>(PedidosControler());
  Get.put<CarrinhoControler>(CarrinhoControler());
  Get.put<MenuAppController>(MenuAppController());
  Get.put(CarrinhoDetails());
  Get.put(Cep);

  //WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

CarrinhoControler carrinhoControler = Get.put(CarrinhoControler());

Future verificaSemUsuarioEstaLogado() async {
  bool isLoggedInUser = await Util.verificaSemUsuarioEstaLogado();
  if (!isLoggedInUser) {
    await loginController.verificaLoginUsuario(true);
  }
  await Util.verificaOuCriaToken();
}

Future<void> carregaQuantidadeItensCarrinho() async {
  carrinhoDetailsControler.qtd =
      int.parse(await carrinhoControler.getQtdItensCarrinho());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      carregaQuantidadeItensCarrinho();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Vendas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: false,
      ),
      initialRoute: pageInit,
      getPages: AppPages.pages,
    );
  }
}
