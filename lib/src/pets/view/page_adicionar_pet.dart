import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/pets/controller/controller_pets.dart';
import 'package:petshop_template/src/pets/models/model_cor.dart';
import 'package:petshop_template/src/pets/models/model_especie.dart';
import 'package:petshop_template/src/pets/models/model_pet.dart';
import 'package:petshop_template/src/pets/models/model_porte.dart';
import 'package:petshop_template/src/pets/models/model_raca.dart';
import 'package:petshop_template/src/shared/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageAdicionarPet extends StatefulWidget {
  final Pet? pet;
  final int? idCliente;

  const PageAdicionarPet({
    super.key,
    this.pet,
    this.idCliente,
  });

  @override
  State<PageAdicionarPet> createState() => _PageAdicionarPetState();
}

class _PageAdicionarPetState extends State<PageAdicionarPet> {
  final PetsController petsController = Get.put(PetsController());
  final _formKey = GlobalKey<FormState>();

  // Controladores dos campos
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController dataNascimentoController =
      TextEditingController();

  // Variáveis para os dropdowns
  String? sexoSelecionado;
  Especie? especieSelecionada;
  Raca? racaSelecionada;
  Cor? corSelecionada;
  Porte? porteSelecionado;

  // Listas para os combos
  List<Especie> especies = [];
  List<Raca> racas = [];
  List<Raca> racasFiltradas = [];
  List<Cor> cores = [];
  List<Porte> portes = [];

  // Estados de loading
  bool isLoading = false;
  bool isLoadingEspecies = false;
  bool isLoadingRacas = false;
  bool isLoadingCores = false;
  bool isLoadingPortes = false;

  // Opções de sexo
  final List<String> opcoesSexo = ['Macho', 'Fêmea'];
  bool get isEdicao => widget.pet != null;

  // Formatador para data DD/MM/AAAA
  final dateFormatter = TextInputFormatter.withFunction((oldValue, newValue) {
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.length >= 3) {
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    }
    if (text.length >= 6) {
      text = '${text.substring(0, 5)}/${text.substring(5)}';
    }
    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  });

  @override
  void initState() {
    super.initState();
    if (isEdicao) {
      _carregaPetParaEdicao();
    } else {
      _carregarCombos();
    }
  }

  Future<void> _carregaPetParaEdicao() async {
    if (isEdicao) {
      Pet pet = widget.pet!;

      nomeController.text = pet.nome;
      dataNascimentoController.text =
          _formatarData(pet.dataNascimento, '/', '-');
      sexoSelecionado = pet.sexo;

      // Carregar as listas antes de selecionar os itens
      await _carregarCombos();

      try {
        especieSelecionada = especies.firstWhere((e) => e.id == pet.idEspecie);
        racaSelecionada = racas.firstWhere((r) => r.id == pet.idRaca);
        corSelecionada = cores.firstWhere((c) => c.id == pet.idCor);
        porteSelecionado = portes.firstWhere((p) => p.id == pet.idPorte);
      } catch (e) {
        //erro
        Util.callMessageSnackBar('Erro ao carregar dados do pet: $e');
      }
      setState(() {});
    }
  }

  Future<void> _carregarCombos() async {
    await Future.wait([
      _carregarEspecies(),
      _carregarRacas(),
      _carregarCores(),
      _carregarPortes(),
    ]);
  }

  Future<void> _carregarEspecies() async {
    try {
      setState(() => isLoadingEspecies = true);
      especies = await petsController.getEspecies();
    } catch (e) {
      Util.callMessageSnackBar('Erro ao carregar espécies: $e');
    } finally {
      setState(() => isLoadingEspecies = false);
    }
  }

  Future<void> _carregarRacas() async {
    try {
      setState(() => isLoadingRacas = true);
      racas = await petsController.getRacas();
      setState(() {});
    } catch (e) {
      Util.callMessageSnackBar('Erro ao carregar raças: $e');
    } finally {
      setState(() => isLoadingRacas = false);
    }
  }

  Future<void> _carregarCores() async {
    try {
      setState(() => isLoadingCores = true);
      cores = await petsController.getCores();
    } catch (e) {
      Util.callMessageSnackBar('Erro ao carregar cores: $e');
    } finally {
      setState(() => isLoadingCores = false);
    }
  }

  Future<void> _carregarPortes() async {
    try {
      setState(() => isLoadingPortes = true);
      portes = await petsController.getPortes();
    } catch (e) {
      Util.callMessageSnackBar('Erro ao carregar portes: $e');
    } finally {
      setState(() => isLoadingPortes = false);
    }
  }

  String _formatarData(String data, String formato, String split) {
    try {
      if (data.isNotEmpty && data.contains(split)) {
        List<String> partes = data.split(split);
        if (partes.length >= 3) {
          return '${partes[2]}$formato${partes[1]}$formato${partes[0]}';
        }
      }
      return data;
    } catch (e) {
      return data;
    }
  }

  // String _formatarDataParaExibicao(String data) {
  //   try {
  //     if (data.isNotEmpty && data.contains('-')) {
  //       List<String> partes = data.split('-');
  //       if (partes.length >= 3) {
  //         return '${partes[2]}/${partes[1]}/${partes[0]}';
  //       }
  //     }
  //     return data;
  //   } catch (e) {
  //     return data;
  //   }
  // }

  Future<void> _salvarPet() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => isLoading = true);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      var idCliente = prefs.getString('guidCliente').toString();

      Pet petParaSalvar = Pet(
        id: widget.pet?.id ?? 0,
        guid: idCliente,
        nome: nomeController.text.trim(),
        dataNascimento: _formatarData(dataNascimentoController.text, '-', '/'),
        sexo: sexoSelecionado ?? '',
        idEspecie: especieSelecionada?.id ?? 0,
        idRaca: racaSelecionada?.id ?? 0,
        idCor: corSelecionada?.id ?? 0,
        idPorte: porteSelecionado?.id ?? 0,
      );

      bool sucesso;
      if (isEdicao) {
        sucesso = await petsController.atualizarPet(petParaSalvar);
      } else {
        sucesso = await petsController.salvarPet(petParaSalvar);
      }

      if (sucesso) {
        Util.callMessageSnackBar(isEdicao
            ? 'Pet atualizado com sucesso!'
            : 'Pet salvo com sucesso!');
        Navigator.pop(context, true); // Retorna true indicando sucesso
      } else {
        Util.callMessageSnackBar('Erro ao salvar pet');
      }
    } catch (e) {
      Util.callMessageSnackBar('Erro ao salvar pet: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.colorFundo,
        title: Text(
          isEdicao ? 'Editar Pet' : 'Adicionar Pet',
          style: const TextStyle(
            color: CustomColors.colorBottonCompra,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: CustomColors.colorBottonCompra,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo Nome
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Pet *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.pets),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'O nome é obrigatório';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Campo Data de Nascimento
              TextFormField(
                controller: dataNascimentoController,
                keyboardType: TextInputType.number,
                inputFormatters: [dateFormatter],
                decoration: InputDecoration(
                  labelText: 'Data de Nascimento *',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today),
                  hintText: 'DD/MM/AAAA',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'A data de nascimento é obrigatória';
                  }

                  // Valida o formato DD/MM/YYYY
                  if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value)) {
                    return 'Digite a data no formato DD/MM/AAAA';
                  }

                  // Valida se é uma data válida
                  try {
                    List<String> partes = value.split('/');
                    int dia = int.parse(partes[0]);
                    int mes = int.parse(partes[1]);
                    int ano = int.parse(partes[2]);

                    DateTime data = DateTime(ano, mes, dia);
                    DateTime hoje = DateTime.now();

                    if (data.isAfter(hoje)) {
                      return 'A data não pode ser futura';
                    }

                    if (ano < 1900) {
                      return 'Ano deve ser maior que 1900';
                    }
                  } catch (e) {
                    return 'Data inválida';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Dropdown Sexo
              DropdownButtonFormField<String>(
                value: sexoSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Sexo *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.pets),
                ),
                items: opcoesSexo.map((String sexo) {
                  return DropdownMenuItem<String>(
                    value: sexo,
                    child: Text(sexo),
                  );
                }).toList(),
                onChanged: (String? valor) {
                  setState(() {
                    sexoSelecionado = valor;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O sexo é obrigatório';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Dropdown Espécie
              DropdownButtonFormField<Especie>(
                value: especieSelecionada,
                decoration: InputDecoration(
                  labelText: 'Espécie *',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.category),
                  suffixIcon: isLoadingEspecies
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                ),
                items: especies.map((Especie especie) {
                  return DropdownMenuItem<Especie>(
                    value: especie,
                    child: Text(especie.nome),
                  );
                }).toList(),
                onChanged: (Especie? especie) {
                  setState(() {
                    especieSelecionada = especie;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'A espécie é obrigatória';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Dropdown Raça
              DropdownButtonFormField<Raca>(
                value: racaSelecionada,
                decoration: InputDecoration(
                  labelText: 'Raça *',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.pets),
                  suffixIcon: isLoadingRacas
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                ),
                items: racas.map((Raca raca) {
                  return DropdownMenuItem<Raca>(
                    value: raca,
                    child: Text(raca.nome),
                  );
                }).toList(),
                onChanged: (Raca? raca) {
                  setState(() {
                    racaSelecionada = raca;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'A raça é obrigatória';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Dropdown Cor
              DropdownButtonFormField<Cor>(
                value: corSelecionada,
                decoration: InputDecoration(
                  labelText: 'Cor *',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.color_lens),
                  suffixIcon: isLoadingCores
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                ),
                items: cores.map((Cor cor) {
                  return DropdownMenuItem<Cor>(
                    value: cor,
                    child: Text(cor.nome),
                  );
                }).toList(),
                onChanged: (Cor? cor) {
                  setState(() {
                    corSelecionada = cor;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'A cor é obrigatória';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Dropdown Porte
              DropdownButtonFormField<Porte>(
                value: porteSelecionado,
                decoration: InputDecoration(
                  labelText: 'Porte *',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.straighten),
                  suffixIcon: isLoadingPortes
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                ),
                items: portes.map((Porte porte) {
                  return DropdownMenuItem<Porte>(
                    value: porte,
                    child: Text(porte.nome),
                  );
                }).toList(),
                onChanged: (Porte? porte) {
                  setState(() {
                    porteSelecionado = porte;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'O porte é obrigatório';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Botão Salvar
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _salvarPet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.colorBottonCompra,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          isEdicao ? 'Atualizar Pet' : 'Salvar Pet',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
