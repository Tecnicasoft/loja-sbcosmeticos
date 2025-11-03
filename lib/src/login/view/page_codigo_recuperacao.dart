import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/login/controller/controller_page_cadastro.dart';
import 'package:petshop_template/src/routes/app_pages.dart';
import 'package:petshop_template/src/shared/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageCodigoRecuperacao extends StatefulWidget {
  const PageCodigoRecuperacao({super.key});

  @override
  State<PageCodigoRecuperacao> createState() => _PageCodigoRecuperacaoState();
}

class _PageCodigoRecuperacaoState extends State<PageCodigoRecuperacao> {
  final _formKey = GlobalKey<FormState>();
  final _codigoController = TextEditingController();
  bool _isLoading = false;
  final CadastroController cadastroController = CadastroController();
  String emailRecebido = "";

  @override
  void dispose() {
    _codigoController.dispose();
    super.dispose();
  }

  dynamic argumentData = Get.arguments;

  @override
  void initState() {
    super.initState();
    if (argumentData != null) {
      emailRecebido = argumentData.toString();
    }
  }

  void _recuperarSenha() async {
    String response = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String codigoDigitado = _codigoController.text;
    String codigoRecebido =
        prefs.getString('codigoClienteSenhaRecupera').toString();
    String guidClienteRecebido =
        prefs.getString('GuidClienteSenhaRecupera').toString();

    if (codigoDigitado == codigoRecebido) {
      setState(() {
        _isLoading = true;
      });
      response = await cadastroController.enviaEmailSenhaRecuperadaNova(
          emailRecebido, guidClienteRecebido);
      if (response == 'OK') {
        Util.callMessageSnackBar(
            'Nova Senha Enviada para o Email Informado, utilize-a para acessar o sistema',
            duracaoMensagem: 5);
        Get.offNamed(PageRoutes.baseRoute, arguments: {'index': 3});
      }
    } else {
      Util.callMessageSnackBar('Código de Recuperação Inválido');
    }
    setState(() {
      _isLoading = false;
    });
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
                              Icons.mark_email_read_outlined,
                              size: 80,
                              color: CustomColors.colorFundoPrimario
                                  .withOpacity(0.7),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Verificação de Código',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Digite o código de recuperação que foi enviado para:',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              emailRecebido,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.colorFundoPrimario,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Campo para o código de verificação
                      _buildCodeTextField(
                        controller: _codigoController,
                        label: 'Código de Recuperação',
                        prefixIcon: Icons.lock_open_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o código de recuperação';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Texto explicativo
                      Text(
                        'Verifique também sua pasta de spam ou lixo eletrônico caso não encontre o código em sua caixa de entrada.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Botão de verificação
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
                              : const Icon(Icons.check_circle_outline,
                                  color: Colors.white),
                          label: Text(
                            _isLoading ? 'Verificando...' : 'Verificar Código',
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

                      // Link para voltar à tela anterior
                      Center(
                        child: TextButton.icon(
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 18,
                            color: CustomColors.colorFundoPrimario,
                          ),
                          label: const Text(
                            'Voltar',
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
                            'Verificando código...',
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

  // Widget para criar campo de texto para código
  Widget _buildCodeTextField({
    TextEditingController? controller,
    required String label,
    IconData? prefixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 8,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(6),
      ],
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
