import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/login/controller/controller_page_cadastro.dart';
import 'package:petshop_template/src/routes/app_pages.dart';
import 'package:petshop_template/src/shared/util.dart';

class PageRecuperarSenha extends StatefulWidget {
  const PageRecuperarSenha({super.key});

  @override
  State<PageRecuperarSenha> createState() => _PageRecuperarSenhaState();
}

class _PageRecuperarSenhaState extends State<PageRecuperarSenha> {
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final CadastroController cadastroController = CadastroController();
  bool _isLoading = false;

  Future<void> _recuperarSenha() async {
    setState(() {
      _isLoading = true;
    });
    final String cpf = _cpfController.text;
    final String email = _emailController.text;
    String response = "";
    //SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      response =
          await cadastroController.verificaEmailCpfCadastrado(cpf, email);

      if (response == 'OK') {
        Get.offNamed(PageRoutes.pageCodigoRecuperacaoState, arguments: email);
      }

      if (response == 'NOTOK') {
        Util.callMessageSnackBar('CPF ou Email não encontrados');
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      Util.callMessageSnackBar(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.colorFundoPrimario,
        title: const Text('Recuperação de Senha',
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
                            const SizedBox(height: 24),
                            const Text(
                              'Esqueceu sua senha?',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Informe seu CPF e e-mail para receber um código de recuperação',
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

                      // Campo CPF
                      _buildTextField(
                        controller: _cpfController,
                        label: 'CPF',
                        prefixIcon: Icons.badge_outlined,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          TextInputFormatter.withFunction(
                            (oldValue, newValue) {
                              final text = newValue.text;
                              if (text.length > 11) {
                                return oldValue;
                              }
                              String newText = '';
                              for (int i = 0; i < text.length; i++) {
                                if (i == 3 || i == 6) {
                                  newText += '.';
                                } else if (i == 9) {
                                  newText += '-';
                                }
                                newText += text[i];
                              }
                              return newValue.copyWith(
                                text: newText,
                                selection: TextSelection.collapsed(
                                    offset: newText.length),
                              );
                            },
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu CPF';
                          }
                          if (value.length != 14) {
                            return 'CPF deve ter 11 dígitos';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Campo Email
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu email';
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Por favor, insira um email válido';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 40),

                      // Botão de recuperação
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    _recuperarSenha();
                                  }
                                },
                          icon: _isLoading
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
                              : const Icon(Icons.email_outlined,
                                  color: Colors.white),
                          label: Text(
                            _isLoading
                                ? 'Processando...'
                                : 'Enviar código de recuperação',
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

                      const SizedBox(height: 24),

                      // Link para voltar à tela de login
                      Center(
                        child: TextButton.icon(
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 18,
                            color: CustomColors.colorFundoPrimario,
                          ),
                          label: const Text(
                            'Voltar para o login',
                            style: TextStyle(
                              color: CustomColors.colorFundoPrimario,
                              fontWeight: FontWeight.w500,
                            ),
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
          if (_isLoading)
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
                            'Verificando dados...',
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

  // Widget para criar campos de texto padronizados
  Widget _buildTextField({
    TextEditingController? controller,
    required String label,
    IconData? prefixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
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
