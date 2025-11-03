import 'package:get/get.dart';
import 'package:petshop_template/src/login/controller/controller_page_cadastro.dart';
import 'package:petshop_template/src/login/controller/controller_page_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

CadastroController cadastroController = CadastroController();

class MenuAppController extends GetxController {
  Future<void> logoffUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LoginController loginController = LoginController();

    if (prefs.getString('tempUser') == 'true') {
      return;
    }

    //prefs.setString('isLoggedInUser', 'false');
    //prefs.setString('tempUser', 'true');
    loginController.verificaLoginUsuario(true);

    //Get.offAllNamed('/login');
    //Get.offAllNamed(PageRoutes.baseRoute, arguments: {'index': 0});

    //Get.reset();
  }

  Future<void> cancelarConta() async {
    await cadastroController.alteraCadastroClienteCancelamentoConta();
    await logoffUser();
  }

  Future<String> retornaNomeUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //String nomeUsuario = prefs.getString('nomeUsuario').toString();
    String nomeUsuario = prefs.getString('nomeCompletoCliente').toString();

    return nomeUsuario.toString();
  }

  Future<bool> temUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tempUser = prefs.getString('tempUser');
    if (tempUser == 'true') {
      return true;
    }
    return false;
  }
}
