import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/login/controller/controller_page_login.dart';
import 'package:petshop_template/src/routes/app_pages.dart';

LoginController loginController = Get.put(LoginController());

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //const LoginPage({Key? key}) : super(key: key);
  bool _senhaVisivel = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backgroundCover(context),
          _imageCover(),
          _boxForm(context),

          // Column(children: [

          // ]),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loginController.isLoading = false;
    loginController.userController.text = '';
    loginController.passwordController.text = '';
  }

  Widget _backgroundCover(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
    );
  }

  // Widget _textoInferior() {
  Widget _imageCover() {
    return SafeArea(
      child: Container(
          alignment: Alignment.topCenter,
          child: Image.asset(
            'assets/images/Logo600x600.png',
            width: 200,
            height: 200,
          )),
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.28, left: 30, right: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0.0, 5.0),
            spreadRadius: 3.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: CustomColors.colorFundoPrimario,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                width: double.infinity,
                child: const Text(
                  "Faça login utilizando seu Email e Senha",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: CustomColors.colorIcons,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 25, 25, 10),
                child: TextField(
                  controller: loginController.userController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 20),
                child: TextField(
                  controller: loginController.passwordController,
                  obscureText: !_senhaVisivel,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Senha",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _senhaVisivel ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _senhaVisivel = !_senhaVisivel;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: loginController.isLoading
                    ? const Center(
                        child: SizedBox(
                        height: 48,
                        child: CircularProgressIndicator(),
                      ))
                    : SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              loginController.isLoading = true;
                            });
                            await loginController.verificaLoginUsuario(false);
                            setState(() {
                              loginController.isLoading = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.colorFundoPrimario,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Entrar",
                            style: TextStyle(
                              color: CustomColors.textoBottao,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
              ),
              TextButton(
                onPressed: () {
                  Get.toNamed(PageRoutes.pageRecuperacaoSenha);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: Text(
                  "Recuperar senha",
                  style: TextStyle(
                    color: CustomColors.textoBottao,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "OU",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 15, 25, 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.toNamed(PageRoutes.pageCadastro);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: CustomColors.colorFundoPrimario),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Faça seu Cadastro",
                      style: TextStyle(
                        color: CustomColors.colorFundoPrimario,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: Text(
                  "Voltar",
                  style: TextStyle(
                    color: CustomColors.textoBottao,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
