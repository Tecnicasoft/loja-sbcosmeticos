import 'package:flutter/material.dart';
import 'package:petshop_template/src/config/custom_colors.dart';

class WidgetCategoriaFull extends StatelessWidget {
  const WidgetCategoriaFull({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onPress,
    required this.isDescricao,
    required this.isDescricaoDetalhes,
  });

  final String category;
  final bool isSelected;
  final VoidCallback onPress;
  final bool isDescricao;
  final String isDescricaoDetalhes;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
          elevation: 2,
          shadowColor: CustomColors.colorIcons,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              width: 0.1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: TextStyle(
                        color: CustomColors.colorBottonCompra,
                        fontWeight: FontWeight.bold,
                        fontSize: isDescricao ? 20 : 20,
                      ),
                    ),
                    isDescricaoDetalhes.isNotEmpty
                        ? Text(
                            isDescricaoDetalhes,
                            style: TextStyle(
                                color: CustomColors.colorBottonCompra
                                    .withOpacity(0.9),
                                fontSize: 13,
                                fontWeight: FontWeight.normal),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
