import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/pets/controller/controller_pets.dart';
import 'package:petshop_template/src/pets/models/model_pet.dart';
import 'package:petshop_template/src/pets/view/page_adicionar_pet.dart';
import 'package:petshop_template/src/routes/app_pages.dart';
import 'package:petshop_template/src/shared/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PagePets extends StatefulWidget {
  final int? idCliente;

  const PagePets({super.key, this.idCliente});

  @override
  State<PagePets> createState() => _PagePetsState();
}

class _PagePetsState extends State<PagePets> {
  final PetsController petsController = Get.put(PetsController());
  List<Pet> pets = [];
  bool isLoading = false;
  bool usuarioTempLogodo = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarPets();
  }

  Future<void> _carregarPets() async {
    await verificaUsuarioTemp().then(
      (onValue) {
        if (onValue == true) {
          //Util.callMessageSnackBar(
          //  'Por favor, faça o login para acessar seus pedidos.');
          setState(() {
            isLoading = false;
            usuarioTempLogodo = true;
          });
          return;
        }
      },
    );

    try {
      setState(() {
        isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var idCliente = prefs.getString('guidCliente').toString();

      List<Pet> listaPets;
      listaPets = await petsController.getPetsByCliente(idCliente);

      setState(() {
        pets = listaPets;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Util.callMessageSnackBar('Erro ao carregar pets: $e');
    }
  }

  Future<bool> verificaUsuarioTemp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tempUser = prefs.getString('tempUser');
    if (tempUser == 'true') {
      usuarioTempLogodo = true;
      return true;
    }
    usuarioTempLogodo = false;
    return false;
  }

  // Future<void> _excluirPet(Pet pet) async {
  //   // Confirmação antes de excluir
  //   bool confirmar = await showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text('Confirmar Exclusão'),
  //             content: Text('Deseja realmente excluir o pet "${pet.nome}"?'),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.of(context).pop(false),
  //                 child: const Text('Cancelar'),
  //               ),
  //               TextButton(
  //                 onPressed: () => Navigator.of(context).pop(true),
  //                 child: const Text('Excluir',
  //                     style: TextStyle(color: Colors.red)),
  //               ),
  //             ],
  //           );
  //         },
  //       ) ??
  //       false;

  //   if (confirmar) {
  //     try {
  //       bool sucesso = await petsController.excluirPet(pet.id);
  //       if (sucesso) {
  //         Util.callMessageSnackBar('Pet excluído com sucesso!');
  //         _carregarPets(); // Recarregar lista
  //       } else {
  //         Util.callMessageSnackBar('Erro ao excluir pet');
  //       }
  //     } catch (e) {
  //       Util.callMessageSnackBar('Erro ao excluir pet: $e');
  //     }
  //   }
  // }

  void _navegarParaAdicionar() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageAdicionarPet(idCliente: widget.idCliente),
      ),
    );

    if (resultado == true) {
      _carregarPets(); // Recarregar lista se houve alteração
    }
  }

  void _navegarParaEditar(Pet pet) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageAdicionarPet(
          pet: pet,
          idCliente: pet.id,
        ),
      ),
    );

    if (resultado == true) {
      _carregarPets(); // Recarregar lista se houve alteração
    }
  }

  Future<void> _selecionarFoto(Pet pet) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 190,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                pet.nome,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFotoOption(
                    icon: Icons.camera_alt,
                    label: 'Câmera',
                    onTap: () => _abrirCamera(pet),
                  ),
                  _buildFotoOption(
                    icon: Icons.photo_library,
                    label: 'Galeria',
                    onTap: () => _abrirGaleria(pet),
                  ),
                  if (pet.foto != null)
                    _buildFotoOption(
                      icon: Icons.delete,
                      label: 'Remover',
                      color: Colors.red,
                      onTap: () => _removerFoto(pet),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFotoOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: (color ?? CustomColors.colorBottonCompra).withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color:
                    (color ?? CustomColors.colorBottonCompra).withOpacity(0.3),
              ),
            ),
            child: Icon(
              icon,
              color: color ?? CustomColors.colorBottonCompra,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color ?? CustomColors.colorBottonCompra,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _abrirCamera(Pet pet) async {
    Navigator.pop(context);

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        await _processarImagem(image, pet);
      }
    } catch (e) {
      Util.callMessageSnackBar('Erro ao abrir câmera: $e');
    }
  }

  Future<void> _abrirGaleria(Pet pet) async {
    Navigator.pop(context);

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        await _processarImagem(image, pet);
      }
    } catch (e) {
      Util.callMessageSnackBar('Erro ao abrir galeria: $e');
    }
  }

  Future<void> _processarImagem(XFile image, Pet pet) async {
    try {
      // Verifica o tamanho do arquivo (máximo 2MB)
      final file = File(image.path);
      final fileSize = await file.length();
      const maxSizeInBytes = 2 * 1024 * 1024; // 2MB em bytes

      if (fileSize > maxSizeInBytes) {
        Util.callMessageSnackBar('Imagem muito grande! Máximo permitido: 2MB');
        return;
      }

      // Mostra loading dialog
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (BuildContext context) {
      //     return const AlertDialog(
      //       content: Row(
      //         children: [
      //           CircularProgressIndicator(),
      //           SizedBox(width: 20),
      //           Text('Enviando foto...'),
      //         ],
      //       ),
      //     );
      //   },
      // );

      // Envia a foto para o servidor
      final sucesso = await petsController.enviarFotoPet(pet.id, image.path);

      // Fecha o loading dialog
      //Navigator.of(context).pop();

      if (sucesso) {
        // Atualiza o pet com a nova foto após sucesso no servidor
        pet.foto = image.path;

        // Força a atualização da UI
        setState(() {});

        //Util.callMessageSnackBar('Foto salva com sucesso!');
      } else {
        Util.callMessageSnackBar('Erro ao salvar foto no servidor');
      }
    } catch (e) {
      Util.callMessageSnackBar('Erro ao processar imagem: $e');
    }
  }

  Future<void> _removerFoto(Pet pet) async {
    Navigator.pop(context);

    bool confirmar = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Remover Foto'),
              content: Text('Deseja remover a foto de ${pet.nome}?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Remover',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirmar) {
      try {
        // Aqui seria feita a chamada para API para remover a foto
        await petsController.removerFotoPet(pet.id);

        setState(() {
          pet.foto = null;
        });

        //Util.callMessageSnackBar('Foto removida com sucesso!');
      } catch (e) {
        Util.callMessageSnackBar('Erro ao remover foto: $e');
      }
    }
  }

  /// Retorna o ImageProvider adequado baseado no tipo de foto
  ImageProvider _getImageProvider(String foto) {
    if (foto.startsWith('data:image')) {
      final parts = foto.split(',');
      if (parts.length >= 2) {
        final base64String = parts[1];
        try {
          final bytes = base64Decode(base64String);
          return MemoryImage(bytes);
        } catch (e) {
          return const NetworkImage(
              'https://via.placeholder.com/100x100/FF6B6B/FFFFFF?text=Erro');
        }
      } else {
        return const NetworkImage(
            'https://via.placeholder.com/100x100/FFA500/FFFFFF?text=Malformed');
      }
    } else if (foto.startsWith('http')) {
      return NetworkImage(foto);
    } else {
      return FileImage(File(foto));
    }
  }

  String _calcularIdade(String dataNascimento) {
    try {
      if (dataNascimento.isEmpty) return '';

      List<String> partes = dataNascimento.split('-');
      if (partes.length < 3) return '';

      DateTime nascimento = DateTime(
        int.parse(partes[0]), // ano
        int.parse(partes[1]), // mês
        int.parse(partes[2]), // dia
      );

      DateTime hoje = DateTime.now();
      int anos = hoje.year - nascimento.year;
      int meses = hoje.month - nascimento.month;
      int dias = hoje.day - nascimento.day;

      if (meses < 0 || (meses == 0 && hoje.day < nascimento.day)) {
        anos--;
        meses += 12;
      }

      if (hoje.day < nascimento.day) {
        meses--;
        // Calcular dias restantes do mês anterior
        DateTime ultimoDiaMesAnterior = DateTime(hoje.year, hoje.month, 0);
        dias = ultimoDiaMesAnterior.day - nascimento.day + hoje.day;
      }

      if (anos > 0) {
        return anos == 1 ? '1 ano' : '$anos anos';
      } else if (meses > 0) {
        return meses == 1 ? '1 mês' : '$meses meses';
      } else {
        return dias == 1 ? '1 dia' : '$dias dias';
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: CustomColors.colorFundoPrimario,
      //   title: Text(
      //     "Pets",
      //     style: const TextStyle(
      //       color: CustomColors.colorBottonCompra,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   actions: [
      //     if (!usuarioTempLogodo)
      //       Padding(
      //         padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),

      //         child: ElevatedButton.icon(
      //           onPressed: _navegarParaAdicionar,
      //           icon: const Icon(
      //             Icons.add,
      //             size: 18,
      //             color: Colors.white,
      //           ),
      //           label: const Text(
      //             'Adicionar Pet',
      //             style: TextStyle(
      //               color: Colors.white,
      //               fontWeight: FontWeight.w600,
      //               fontSize: 14,
      //             ),
      //           ),
      //           style: ElevatedButton.styleFrom(
      //             backgroundColor: CustomColors.colorBottonCompra,
      //             elevation: 2,
      //             shadowColor: CustomColors.colorBottonCompra.withOpacity(0.3),
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(20),
      //             ),
      //             padding:
      //                 const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      //           ),
      //         ),
      //       ),
      //   ],
      // ),
      body: SafeArea(
        child: Column(
          children: [
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.pets,
                            color: CustomColors.colorBottonCompra,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Meus Pets",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.colorBottonCompra,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!usuarioTempLogodo)
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ElevatedButton.icon(
                          onPressed: _navegarParaAdicionar,
                          icon: const Icon(
                            Icons.add,
                            size: 18,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Adicionar Pet',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.colorBottonCompra,
                            elevation: 2,
                            shadowColor:
                                CustomColors.colorBottonCompra.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 5),
                          ),
                        ),
                      ),
                  ],
                )),

            // Lista de pets

            if (usuarioTempLogodo == false)
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : pets.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.pets,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Nenhum pet encontrado',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: pets.length,
                            itemBuilder: (context, index) {
                              final pet = pets[index];
                              return GestureDetector(
                                onTap: () => _navegarParaEditar(pet),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.06),
                                        blurRadius: 20,
                                        offset: const Offset(0, 6),
                                        spreadRadius: 0,
                                      ),
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.02),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          // Avatar lateral com gradiente
                                          Container(
                                            width: 150,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  CustomColors
                                                      .colorBottonCompra,
                                                  CustomColors.colorBottonCompra
                                                      .withOpacity(0.8),
                                                ],
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // Avatar do pet
                                                  GestureDetector(
                                                    onTap: () =>
                                                        _selecionarFoto(pet),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: 130,
                                                          height: 130,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: pet.foto !=
                                                                    null
                                                                ? null
                                                                : Colors.white
                                                                    .withOpacity(
                                                                        0.2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            border: Border.all(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.3),
                                                              width: 2,
                                                            ),
                                                            image: pet.foto !=
                                                                    null
                                                                ? DecorationImage(
                                                                    image: _getImageProvider(
                                                                        pet.foto!),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : null,
                                                          ),
                                                          child:
                                                              pet.foto == null
                                                                  ? Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .add_a_photo,
                                                                          size:
                                                                              28,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                6),
                                                                        Text(
                                                                          'Foto',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : null,
                                                        ),
                                                        // Ícone de editar no canto inferior direito
                                                        if (pet.foto != null)
                                                          Positioned(
                                                            bottom: 10,
                                                            right: 10,
                                                            child: Container(
                                                              width: 24,
                                                              height: 24,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.7),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                              ),
                                                              child: const Icon(
                                                                Icons.edit,
                                                                size: 16,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          // Conteúdo principal
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  // Nome do pet
                                                  Text(
                                                    pet.nome,
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                      letterSpacing: -0.5,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),

                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // Idade do pet
                                                      if (pet.dataNascimento
                                                          .isNotEmpty)
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: CustomColors
                                                                .colorBottonCompra
                                                                .withOpacity(
                                                                    0.1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 12,
                                                              vertical: 6,
                                                            ),
                                                            child: Text(
                                                              _calcularIdade(pet
                                                                  .dataNascimento),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: CustomColors
                                                                    .colorBottonCompra,
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                      const SizedBox(height: 8),

                                                      // Informações organizadas verticalmente
                                                      if (pet.sexo.isNotEmpty)
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: pet.sexo
                                                                        .toLowerCase() ==
                                                                    'macho'
                                                                ? Colors.blue
                                                                    .withOpacity(
                                                                        0.2)
                                                                : Colors.pink
                                                                    .withOpacity(
                                                                        0.2),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 12,
                                                              vertical: 6,
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  pet.sexo.toLowerCase() ==
                                                                          'macho'
                                                                      ? Icons
                                                                          .male
                                                                      : Icons
                                                                          .female,
                                                                  size: 18,
                                                                  color: pet.sexo
                                                                              .toLowerCase() ==
                                                                          'macho'
                                                                      ? Colors.blue[
                                                                          600]
                                                                      : Colors.pink[
                                                                          600],
                                                                ),
                                                                const SizedBox(
                                                                    width: 8),
                                                                Text(
                                                                  pet.sexo,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                            .grey[
                                                                        700],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),

                                                  if (pet
                                                      .stringEspecie.isNotEmpty)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8),
                                                      child: _buildInfoRow(
                                                        Icons.category_rounded,
                                                        pet.stringEspecie,
                                                      ),
                                                    ),

                                                  if (pet.stringRaca.isNotEmpty)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8),
                                                      child: _buildInfoRow(
                                                        Icons.pets,
                                                        pet.stringRaca,
                                                      ),
                                                    ),

                                                  if (pet.stringCor.isNotEmpty)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8),
                                                      child: _buildInfoRow(
                                                        Icons.palette_rounded,
                                                        pet.stringCor,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),

            // Conteúdo principal
            if (usuarioTempLogodo == true)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Ícone ilustrativo
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color:
                              CustomColors.colorFundoPrimario.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.pets,
                          size: 70,
                          color: CustomColors.colorFundoPrimario,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Título da mensagem
                      const Text(
                        'Acesse seus pets',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      // Mensagem descritiva
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          'Faça login para visualizar e gerenciar os pets associados à sua conta.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Botão de login modernizado
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            Get.toNamed(PageRoutes.login);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.colorBottonCompra,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.login_rounded),
                              const SizedBox(width: 8),
                              Text(
                                "Fazer Login",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  //color: CustomColors.colorBottonCompra,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
