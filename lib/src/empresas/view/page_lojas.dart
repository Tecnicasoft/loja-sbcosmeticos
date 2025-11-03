import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petshop_template/src/config/custom_colors.dart';
import 'package:petshop_template/src/empresas/controller/controller_page_empresas.dart';
import 'package:petshop_template/src/empresas/models/model_empresas.dart';
import 'package:petshop_template/src/empresas/models/model_empresas_format.dart';
import 'package:petshop_template/src/shared/util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

EmpresaControler pageEmpresasController = EmpresaControler();

class PageLojas extends StatefulWidget {
  const PageLojas({super.key});

  @override
  State<PageLojas> createState() => _PageLojasState();
}

class _PageLojasState extends State<PageLojas> {
  List<EmpresaFormat> empresaFormat = [];
  bool isLoading = true;
  List<Empresa> empresa = [];

  @override
  void initState() {
    super.initState();
    // Carregar os endereços das lojas
    _loadEnderecos();
  }

  Future<String> getTelefoneEmpresa(int idLoja) async {
    empresa = await pageEmpresasController.getAllEmpresas(idLoja);
    return empresa.firstWhere((e) => e.id == idLoja).telefone;
  }

  _openWhatsApp(int idLoja) async {
    String telefone = await getTelefoneEmpresa(idLoja);

    // const link = WhatsAppUnilink(
    //   phoneNumber: telefone, //'+5584988020815',
    //   text: "Hola, me gustaría obtener más información sobre sus productos.",
    // );

    const sufixo = '+55';

    final link = WhatsAppUnilink(
      phoneNumber: '$sufixo$telefone',
      text: null,
    );

    // Convert the WhatsAppUnilink instance to a Uri.
    // The "launch" method is part of "url_launcher".
    await launchUrl(link.asUri(), mode: LaunchMode.externalApplication);
  }

  Future<void> _loadEnderecos() async {
    try {
      empresaFormat = await pageEmpresasController.getEmpresasFormat();
      setState(() {
        isLoading = true;
      });
    } catch (e) {
      Util.callMessageSnackBar('Erro ao carregar endereços');
      setState(() {
        isLoading = false;
        //voltar para a tela anterior
        Get.back();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho
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
                      Icons.storefront,
                      color: CustomColors.colorBottonCompra,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Nossas Lojas",
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

            // Conteúdo principal - Lista de lojas
            Expanded(
              child: Container(
                color: Colors.grey.shade50,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: empresaFormat.length,
                  itemBuilder: (context, index) {
                    final loja = empresaFormat[index];
                    return _buildLojaCard(context, loja);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLojaCard(BuildContext context, EmpresaFormat loja) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem da loja (se disponível)
          // ClipRRect(
          //   borderRadius: const BorderRadius.only(
          //     topLeft: Radius.circular(12),
          //     topRight: Radius.circular(12),
          //   ),
          //   child: Image.asset(
          //     loja['imagem'],
          //     height: 150,
          //     width: double.infinity,
          //     fit: BoxFit.cover,
          //     errorBuilder: (context, error, stackTrace) {
          //       return Container(
          //         height: 150,
          //         color: Colors.grey.shade200,
          //         child: const Center(
          //           child: Icon(
          //             Icons.store,
          //             size: 50,
          //             color: CustomColors.colorBottonCompra,
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),

          // Informações da loja
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome da loja
                Text(
                  loja.nome,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.colorBottonCompra,
                  ),
                ),
                const SizedBox(height: 8),

                // Endereço
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loja.enderecoLinha1,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            loja.enderecoLinha2,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Telefone
                Row(
                  children: [
                    const Icon(
                      Icons.phone_outlined,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      loja.telefone,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Horário de funcionamento
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     const Icon(
                //       Icons.access_time,
                //       size: 18,
                //       color: Colors.grey,
                //     ),
                //     const SizedBox(width: 8),
                //     Expanded(
                //       child: Text(
                //         loja['horario'],
                //         style: const TextStyle(
                //           fontSize: 14,
                //           color: Colors.black87,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                const SizedBox(height: 16),

                // Botões de ação
                Row(
                  children: [
                    // Botão de WhatsApp
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          // final String whatsappNumber =
                          //     loja.telefone.replaceAll(RegExp(r'[^0-9]'), '');
                          // final Uri whatsappUri =
                          //     Uri.parse('https://wa.me/$whatsappNumber');

                          // if (await canLaunchUrl(whatsappUri)) {
                          //   await launchUrl(whatsappUri,
                          //       mode: LaunchMode.externalApplication);
                          // } else {
                          //   Util.callMessageSnackBar(
                          //       'Não foi possível abrir o WhatsApp.');
                          // }
                          _openWhatsApp(loja.id);
                        },
                        icon: Image.asset(
                          'assets/images/Whatsapp.png',
                          width: 25,
                          height: 25,
                        ),
                        label: const Text('WhatsApp'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width: 8), // Espaçamento entre WhatsApp e Ligar

                    // Botão de Ligar
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final Uri phoneUri = Uri(
                            scheme: 'tel',
                            path:
                                loja.telefone.replaceAll(RegExp(r'[^0-9]'), ''),
                          );
                          if (await canLaunchUrl(phoneUri)) {
                            await launchUrl(phoneUri);
                          }
                        },
                        icon: const Icon(Icons.phone),
                        label: const Text('Ligar'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: CustomColors.colorBottonCompra,
                          side: const BorderSide(
                              color: CustomColors.colorBottonCompra),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                    // Botão de mapa
                  ],
                ),
                const SizedBox(height: 8), // Espaçamento entre botões e mapa
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // Construir o endereço completo para busca
                          final String enderecoCompleto =
                              "${loja.enderecoLinha1}, ${loja.enderecoLinha2}";
                          final String enderecoLimpo = enderecoCompleto.trim();

                          try {
                            // Codifica o endereço para URL
                            final String encodedAddress =
                                Uri.encodeComponent(enderecoLimpo);

                            // Abre apenas a localização no mapa sem iniciar navegação
                            // Usa 'q=' para buscar a localização (não usa 'daddr=' que traça rota)
                            final Uri mapIntent = Uri.parse(
                                'https://maps.google.com/?q=$encodedAddress');

                            // URI geo alternativa para Android (apenas exibe a localização)
                            final Uri geoUri =
                                Uri.parse('geo:0,0?q=$encodedAddress');

                            // Tenta abrir no Android usando o método geo
                            if (await canLaunchUrl(geoUri)) {
                              await launchUrl(geoUri);
                            }
                            // Se não funcionar, tenta a URL web do Google Maps
                            else if (await canLaunchUrl(mapIntent)) {
                              await launchUrl(mapIntent,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              // Último recurso - versão de pesquisa do Google Maps
                              final fallbackUri = Uri.parse(
                                  'https://www.google.com/maps/search/?api=1&query=$encodedAddress');
                              if (await canLaunchUrl(fallbackUri)) {
                                await launchUrl(fallbackUri,
                                    mode: LaunchMode.externalApplication);
                              } else {
                                Util.callMessageSnackBar(
                                    'Não foi possível abrir o mapa. Verifique se você tem o Google Maps instalado.');
                              }
                            }
                          } catch (e) {
                            Util.callMessageSnackBar(
                                'Erro ao abrir o mapa: ${e.toString()}');
                          }
                        },
                        icon: const Icon(Icons.map),
                        label: const Text('Ver no Mapa'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.colorBottonCompra,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
