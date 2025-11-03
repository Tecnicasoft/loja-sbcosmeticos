import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/login/controller/controller_page_cadastro.dart';
import 'package:petshop_template/src/login/controller/controller_page_login.dart';
import 'package:petshop_template/src/login/models/model_cep.dart';
import 'package:petshop_template/src/login/models/model_cliente.dart';
import 'package:petshop_template/src/shared/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageCadastro extends StatefulWidget {
  const PageCadastro({super.key});

  @override
  State<PageCadastro> createState() => _PageCadastroState();
}

class _PageCadastroState extends State<PageCadastro> {
  Cep cep = Cep();
  final CadastroController cadastroController = CadastroController();
  final LoginController loginController = LoginController();
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _cepController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _enderecoNumeroController = TextEditingController();
  final _enderecoComplementoController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();

  final _sexoController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final FocusNode _cepFocusNode =
      FocusNode(); // Adicionado FocusNode para o campo CEP

  bool isEdit = false;
  var cpfInicial = '';
  var emailInicial = '';
  var idTelefone = 0;
  bool isLoading = false;
  bool isCepLoading = false;
  bool isSubmitting = false;
  String previousCep = ''; // Variável para armazenar o valor anterior do CEP
  bool ignoreNextCepSearch =
      false; // Flag para ignorar a próxima pesquisa de CEP

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _enderecoController.dispose();
    _enderecoNumeroController.dispose();
    _enderecoComplementoController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _sexoController.dispose();
    _dataNascimentoController.dispose();
    _cepFocusNode.dispose(); // Dispose do FocusNode
    isEdit = false;
    cpfInicial = '';
    emailInicial = '';
    idTelefone = 0;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null) {
      if (args['isEdit'] == true) {
        isEdit = true;
        cpfInicial = '';
        idTelefone = 0;
        _carregarDados();
      }
    }

    // Listener para pesquisar CEP apenas quando atingir 9 dígitos e o valor for alterado
    _cepController.addListener(() async {
      if (_cepController.text != previousCep &&
          _cepController.text.length == 9 &&
          !isCepLoading) {
        previousCep = _cepController.text; // Atualiza o valor anterior do CEP
        setState(() {
          isCepLoading = true; // Bloqueia o campo durante a pesquisa
        });
        await _pesquisarCEP();
      }
    });
  }

  Future<void> _carregarDados() async {
    setState(() {
      isLoading = true;
      ignoreNextCepSearch = true; // Ignora a próxima pesquisa de CEP
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var idCliente = prefs.getString('idUsuario').toString();

    try {
      var cliente = await cadastroController.consultaCliente(idCliente);
      _nomeController.text = cliente.nome;
      _cpfController.text = Util.formatCpf(cliente.cpf);
      _telefoneController.text = Util.formatTelefone(cliente.telefone);
      _emailController.text = cliente.email;
      _cepController.text = Util.formatCep(cliente.cep);
      _enderecoController.text = cliente.endereco;
      _enderecoNumeroController.text = cliente.numero;
      _enderecoComplementoController.text = cliente.complemento;
      _bairroController.text = cliente.bairro;
      _cidadeController.text = cliente.cidade;
      _estadoController.text = cliente.estado;
      _sexoController.text = cliente.sexo;
      _dataNascimentoController.text = cliente.dataNascimento;
      cep = Cep(idmunicipio: cliente.cidadeId);
      cpfInicial = cliente.cpf;
      emailInicial = cliente.email;
      idTelefone = cliente.idTelefone;
      previousCep =
          _cepController.text; // Define o CEP atual como o CEP anterior
    } catch (e) {
      Util.callMessageSnackBar(e.toString());
      return;
    }

    setState(() {
      isLoading = false;
      // Mantém a flag para evitar que o CEP seja pesquisado ao inicializar os campos
    });
  }

  Future<void> _cadastrar() async {
    setState(() {
      isSubmitting = true;
    });
    var retorno = '';

    // Define valores padrão para campos opcionais quando estiverem vazios
    String dataNascimento = _dataNascimentoController.text.isEmpty
        ? "01/01/1990"
        : _dataNascimentoController.text;

    String sexo =
        _sexoController.text.isEmpty ? "Masculino" : _sexoController.text;

    final cliente = Cliente(
        nome: _nomeController.text,
        cpf: _cpfController.text.replaceAll(".", "").replaceAll("-", ""),
        telefone: _telefoneController.text
            .replaceAll("(", "")
            .replaceAll(")", "")
            .replaceAll("-", "")
            .replaceAll(" ", ""),
        email: _emailController.text,
        senha: _senhaController.text,
        cep: _cepController.text.replaceAll("-", ""),
        endereco: _enderecoController.text,
        numero: _enderecoNumeroController.text,
        complemento: _enderecoComplementoController.text,
        bairro: _bairroController.text,
        cidade: cep.idmunicipio.toString(),
        cpfInicial: cpfInicial,
        emailInicial: emailInicial,
        idTelefone: idTelefone,
        sexo: sexo,
        dataNascimento: dataNascimento);

    try {
      retorno = await cadastroController.cadastroCliente(cliente, isEdit);

      if (retorno == 'OK') {
        if (!isEdit) {
          loginController.userController.text = cliente.email;
          loginController.passwordController.text = cliente.senha;
          await loginController.verificaLoginUsuario(false);
        }

        if (isEdit) {
          //Get.offAllNamed(PageRoutes.pageMenu);
          Get.back();
        }
      } else {
        throw Exception(retorno);
      }

      setState(() {
        isSubmitting = false;
      });
    } catch (e) {
      Util.callMessageSnackBar(retorno);
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  Future<void> _pesquisarCEP() async {
    // Se a flag estiver ativa, ignora esta pesquisa de CEP e reseta a flag
    if (ignoreNextCepSearch) {
      setState(() {
        ignoreNextCepSearch = false;
        isCepLoading = false;
      });
      return;
    }

    setState(() {
      isCepLoading = true;
    });
    try {
      //await Future.delayed(const Duration(seconds: 1));
      cep = await cadastroController.consultaCep(_cepController.text);
      _enderecoController.text = cep.logradouro;
      _bairroController.text = cep.bairro;
      _cidadeController.text = cep.municipio;
      _estadoController.text = cep.uf;
    } catch (e) {
      Util.callMessageSnackBar(e.toString());
    } finally {
      setState(() {
        isCepLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.colorFundoPrimario,
        title: Text(isEdit ? 'Atualizar Cadastro' : 'Novo Cadastro',
            style: const TextStyle(
                color: CustomColors.colorBottonCompra,
                fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  // Cabeçalho da página
                  if (!isEdit)
                    Column(
                      children: [
                        Icon(
                          Icons.person_add_rounded,
                          size: 64,
                          color:
                              CustomColors.colorFundoPrimario.withOpacity(0.7),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Crie sua conta',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Preencha seus dados para criar um cadastro',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),

                  // Seção de dados pessoais
                  _buildSectionHeader('Dados Pessoais', Icons.person_outline),
                  const SizedBox(height: 16),

                  // Nome
                  _buildTextField(
                    controller: _nomeController,
                    label: 'Nome Completo',
                    prefixIcon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu nome completo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email
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
                  const SizedBox(height: 16),

                  // CPF e Telefone - alterado para layout vertical em vez de horizontal
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
                            selection:
                                TextSelection.collapsed(offset: newText.length),
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
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _telefoneController,
                    label: 'Telefone (WhatsApp)',
                    prefixIcon: Icons.phone_android,
                    keyboardType: TextInputType.phone,
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
                            if (i == 0) {
                              newText += '(';
                            } else if (i == 2) {
                              newText += ')';
                            } else if (i == 7) {
                              newText += '-';
                            }
                            newText += text[i];
                          }
                          return newValue.copyWith(
                            text: newText,
                            selection:
                                TextSelection.collapsed(offset: newText.length),
                          );
                        },
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu telefone';
                      }
                      if (value.length != 14) {
                        return 'Telefone deve ter 11 dígitos';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Data de Nascimento e Sexo na mesma linha
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _dataNascimentoController,
                          label: 'Data de Nascimento',
                          prefixIcon: Icons.calendar_today,
                          keyboardType: TextInputType.datetime,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            TextInputFormatter.withFunction(
                              (oldValue, newValue) {
                                final text = newValue.text;
                                if (text.length > 8) {
                                  return oldValue;
                                }
                                String newText = '';
                                for (int i = 0; i < text.length; i++) {
                                  if (i == 2 || i == 4) {
                                    newText += '/';
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
                          // Campo é opcional, não precisa de validação
                          hint: 'Opcional',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDropdownField(
                          controller: _sexoController,
                          label: 'Sexo',
                          prefixIcon: Icons.people_outline,
                          items: const [
                            DropdownMenuItem(
                                value: 'Masculino', child: Text('Masculino')),
                            DropdownMenuItem(
                                value: 'Feminino', child: Text('Feminino')),
                          ],
                          onChanged: (value) {
                            _sexoController.text = value.toString();
                          },
                          // Campo é opcional, não precisa de validação
                        ),
                      ),
                    ],
                  ),

                  // Senha (apenas se não estiver editando)
                  if (!isEdit) ...[
                    const SizedBox(height: 24),
                    _buildSectionHeader('Acesso', Icons.lock_outline),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _senhaController,
                      label: 'Senha',
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira sua senha';
                        }
                        if (value.length < 6) {
                          return 'A senha deve ter pelo menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Confirmar Senha',
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, repita sua senha';
                        }
                        if (value != _senhaController.text) {
                          return 'As senhas não coincidem';
                        }
                        return null;
                      },
                    ),
                  ],

                  const SizedBox(height: 24),
                  _buildSectionHeader('Endereço', Icons.home_outlined),
                  const SizedBox(height: 16),

                  // Campo CEP com botão de pesquisa
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _cepController,
                          label: 'CEP',
                          prefixIcon: Icons.location_on_outlined,
                          focusNode: _cepFocusNode,
                          enabled: !isCepLoading,
                          hint: '00000-000',
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            TextInputFormatter.withFunction(
                              (oldValue, newValue) {
                                final text = newValue.text;
                                if (text.length > 8) {
                                  return oldValue;
                                }
                                String newText = '';
                                for (int i = 0; i < text.length; i++) {
                                  if (i == 5) {
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
                              return 'Por favor, insira seu CEP';
                            }
                            if (value.length != 9) {
                              return 'CEP deve ter 8 dígitos';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (_cepController.text.length == 9) {
                            _pesquisarCEP();
                          } else {
                            Util.callMessageSnackBar('Digite um CEP válido');
                          }
                        },
                        icon: const Icon(Icons.search),
                        label: const Text('Buscar CEP'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.colorFundoPrimario,
                          foregroundColor: CustomColors.colorBottonCompra,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Endereço
                  _buildTextField(
                    controller: _enderecoController,
                    label: 'Endereço (endereço de entrega)',
                    prefixIcon: Icons.home,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu endereço';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Número e Complemento na mesma linha
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildTextField(
                          controller: _enderecoNumeroController,
                          label: 'Número',
                          prefixIcon: Icons.tag,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o número';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: _buildTextField(
                          controller: _enderecoComplementoController,
                          label: 'Complemento',
                          prefixIcon: Icons.more_horiz,
                          hint: 'Opcional',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Bairro
                  _buildTextField(
                    controller: _bairroController,
                    label: 'Bairro',
                    prefixIcon: Icons.location_city,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o bairro';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Cidade e Estado na mesma linha
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildTextField(
                          controller: _cidadeController,
                          label: 'Cidade',
                          prefixIcon: Icons.location_city,
                          readOnly: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Utilize o campo CEP';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: _buildTextField(
                          controller: _estadoController,
                          label: 'UF',
                          prefixIcon: Icons.map_outlined,
                          readOnly: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Botão de Cadastro/Alteração
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _cadastrar();
                        }
                      },
                      icon: Icon(
                        isEdit ? Icons.check : Icons.person_add,
                        color: Colors.white,
                      ),
                      label: Text(
                        isEdit ? 'Atualizar Cadastro' : 'Finalizar Cadastro',
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
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Overlays de carregamento
          if (isCepLoading)
            Positioned.fill(
              child: GestureDetector(
                onTap:
                    () {}, // Intercepta toques para impedir interações com a tela de fundo
                behavior: HitTestBehavior.opaque,
                child: Container(
                  color: Colors.black
                      .withOpacity(0.1), // Fundo translúcido para toda a tela
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
                            'Pesquisando CEP...',
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
          if (isSubmitting)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: CustomColors.colorBottonCompra,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Enviando dados, por favor aguarde...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: CustomColors.colorBottonCompra,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Carregando dados, por favor aguarde...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Widget para criar cabeçalhos de seção
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: CustomColors.colorFundoPrimario,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Divider(
            color: Colors.grey[400],
            thickness: 1,
          ),
        ),
      ],
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
    bool readOnly = false,
    bool enabled = true,
    String? hint,
    FocusNode? focusNode,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      readOnly: readOnly,
      enabled: enabled,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
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
        fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }

  // Widget para criar campos dropdown padronizados
  Widget _buildDropdownField({
    TextEditingController? controller,
    required String label,
    IconData? prefixIcon,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: controller != null && controller.text.isNotEmpty
          ? controller.text
          : null,
      validator: validator,
      onChanged: onChanged,
      items: items,
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
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }
}
