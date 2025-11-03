import 'package:flutter/material.dart';
import 'package:petshop_template/src/config/custom_colors.dart';

class WidgetCustomCategoryTile extends StatelessWidget {
  const WidgetCustomCategoryTile({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onPress,
  });

  final String category;
  final bool isSelected;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPress,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            height: 30,
            //width: 90,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? CustomColors.colorBottonCompra
                  : CustomColors.colorBottonCompra.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                category,
                overflow: TextOverflow.clip,
                maxLines: 2,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
