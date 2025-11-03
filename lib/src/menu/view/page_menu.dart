import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/menu/controller/controller_page_menu.dart';
import 'package:petshop_template/src/routes/app_pages.dart';
import 'package:petshop_template/src/shared/util.dart';

MenuAppController get controller => Get.find<MenuAppController>();

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String nomeUsuario = '';
  bool isUserLoggedIn = false;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getUserName() async {
    if (!await Util.verificaSemUsuarioAvulsoEstaLogado()) {
      String nomeUsuarioretorno = await controller.retornaNomeUsuario();
      setState(() {
        nomeUsuario = nomeUsuarioretorno;
        isUserLoggedIn = true;
      });
    }
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
                  children: [
                    const Icon(
                      Icons.menu,
                      color: CustomColors.colorBottonCompra,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Menu",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.colorBottonCompra,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Conteúdo principal
            Expanded(
              child: Container(
                color: Colors.grey.shade50,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isUserLoggedIn) ...[
                        // Informações do usuário
                        Container(
                          margin: const EdgeInsets.only(bottom: 16, top: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: CustomColors.colorBottonCompra
                                      .withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: CustomColors.colorBottonCompra,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Olá,",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      nomeUsuario,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Título da seção
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 12, top: 8),
                          child: Text(
                            "Conta",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        _buildMenuOption(
                          icon: Icons.person_outline,
                          title: "Meus dados",
                          onTap: () {
                            Get.toNamed(PageRoutes.pageCadastro,
                                arguments: {'isEdit': true});
                          },
                        ),
                        // _buildMenuOption(
                        //   icon: Icons.pets,
                        //   title: "Meus Pets",
                        //   onTap: () {
                        //     Get.toNamed(PageRoutes.pagePets);
                        //   },
                        // ),
                        _buildMenuOption(
                          icon: Icons.lock_outline,
                          title: "Alterar senha",
                          onTap: () {
                            Get.toNamed(PageRoutes.pageAlterarSenha);
                          },
                        ),
                        _buildMenuOption(
                          icon: Icons.cancel,
                          title: "Cancelar Conta",
                          iconColor: Colors.red,
                          titleColor: Colors.red,
                          onTap: () {
                            showAlertDialogCancelarConta(context);
                          },
                        ),
                        _buildMenuOption(
                          icon: Icons.logout,
                          title: "Sair",
                          iconColor: Colors.red,
                          titleColor: Colors.red,
                          onTap: () {
                            showAlertDialog(context);
                          },
                        ),
                      ] else ...[
                        // Usuário não logado
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 24),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: CustomColors.colorBottonCompra
                                      .withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person_outline,
                                  color: CustomColors.colorBottonCompra,
                                  size: 40,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Faça login para acessar sua conta",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Acesse seus pedidos e dados pessoais",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  if (!await Util
                                      .verificaSemUsuarioAvulsoEstaLogado()) {
                                    return;
                                  }
                                  Get.toNamed(PageRoutes.login);
                                },
                                icon: const Icon(Icons.login),
                                label: const Text(
                                  'Fazer Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      CustomColors.colorBottonCompra,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            if (isProcessing) showLoaderDialog(context)
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = Colors.black87,
    Color titleColor = Colors.black87,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: titleColor,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Sair",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text("Você realmente deseja sair?"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[800],
          ),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();
            showLoaderDialog(context);
            await controller.logoffUser();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.colorBottonCompra,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Confirmar'),
        ),
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogCancelarConta(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: const Text(
        "Cancelar conta",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text(
          "Ao solicitar a exclusão da sua conta, todos os seus dados pessoais, como endereço e telefone, serão removidos do nosso sistema. Caso você não tenha realizado nenhuma compra, sua conta será completamente excluída. Caso você tenha realizado compras, seus registros de compra contendo nome e CPF serão mantidos de forma segura para cumprir obrigações legais de emissão e armazenamento de notas fiscais para fins fiscais e de auditoria. Esses dados não estarão vinculados à sua conta desativada ou a qualquer nova conta que você possa criar. Mantemos apenas os dados estritamente necessários para essas obrigações legais."),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[800],
          ),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();
            showLoaderDialog(context);
            await controller.cancelarConta();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.colorBottonCompra,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Confirmar'),
        ),
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    content: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(CustomColors.colorBottonCompra),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Realizando o logoff",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Aguarde um momento...",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
