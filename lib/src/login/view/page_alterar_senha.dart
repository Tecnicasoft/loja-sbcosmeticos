import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/login/controller/controller_page_cadastro.dart';
import 'package:petshop_template/src/routes/app_pages.dart';
import 'package:petshop_template/src/shared/util.dart';

class PageAlterarSenha extends StatefulWidget {
  const PageAlterarSenha({super.key});

  @override
  State<PageAlterarSenha> createState() => _PageAlterarSenhaState();
}

class _PageAlterarSenhaState extends State<PageAlterarSenha> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final CadastroController cadastroController = CadastroController();
  bool isSubmitting = false;
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _alterarSenha() async {
    if (_formKey.currentState!.validate()) {
      var retorno = "";
      setState(() {
        isSubmitting = true;
      });
      try {
        retorno = await cadastroController.alteraSenhaCliente(
            _currentPasswordController.text, _newPasswordController.text);

        if (retorno == "OK") {
          Util.callMessageSnackBar("Senha alterada com sucesso");
          Get.offAllNamed(PageRoutes.baseRoute, arguments: {'index': 0});
          return;
        }

        throw Exception(retorno);
      } catch (e) {
        Util.callMessageSnackBar(retorno);
      }
    }
    setState(() {
      isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.colorFundoPrimario,
        title: const Text('Alterar Senha',
            style: TextStyle(
              color: CustomColors.colorBottonCompra,
              fontWeight: FontWeight.bold,
            )),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Cabeçalho com ícone e texto explicativo
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.lock_reset,
                              size: 80,
                              color: CustomColors.colorFundoPrimario
                                  .withOpacity(0.7),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Alteração de Senha',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Preencha os campos abaixo para definir sua nova senha',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Campo de senha atual
                      _buildPasswordField(
                        controller: _currentPasswordController,
                        label: 'Senha Atual',
                        prefixIcon: Icons.lock_outline,
                        showPassword: _showCurrentPassword,
                        onToggleVisibility: () {
                          setState(() {
                            _showCurrentPassword = !_showCurrentPassword;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira sua senha atual';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Campo de nova senha
                      _buildPasswordField(
                        controller: _newPasswordController,
                        label: 'Nova Senha',
                        prefixIcon: Icons.vpn_key_outlined,
                        showPassword: _showNewPassword,
                        onToggleVisibility: () {
                          setState(() {
                            _showNewPassword = !_showNewPassword;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira sua nova senha';
                          }
                          if (value.length < 6) {
                            return 'A senha deve ter pelo menos 6 caracteres';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Campo de confirmação de senha
                      _buildPasswordField(
                        controller: _confirmPasswordController,
                        label: 'Confirmar Nova Senha',
                        prefixIcon: Icons.verified_outlined,
                        showPassword: _showConfirmPassword,
                        onToggleVisibility: () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, confirme sua nova senha';
                          }
                          if (value != _newPasswordController.text) {
                            return 'As senhas não coincidem';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 40),

                      // Botão de alterar senha
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: isSubmitting
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    _alterarSenha();
                                  }
                                },
                          icon: isSubmitting
                              ? Container(
                                  width: 24,
                                  height: 24,
                                  padding: const EdgeInsets.all(2.0),
                                  child: const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Icon(Icons.save_outlined,
                                  color: Colors.white),
                          label: Text(
                            isSubmitting ? 'Atualizando...' : 'Alterar Senha',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.colorBottonCompra,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            disabledBackgroundColor:
                                CustomColors.colorBottonCompra.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Overlay de carregamento
          if (isSubmitting)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {}, // Intercepta toques para impedir interações
                behavior: HitTestBehavior.opaque,
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                CustomColors.colorFundoPrimario,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Alterando senha...',
                            style: TextStyle(
                              color: CustomColors.colorFundoPrimario,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Widget para criar campos de senha padronizados
  Widget _buildPasswordField({
    TextEditingController? controller,
    required String label,
    IconData? prefixIcon,
    required bool showPassword,
    required Function() onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !showPassword,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: IconButton(
          icon: Icon(
            showPassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: CustomColors.colorFundoPrimario),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }
}
