import 'package:flutter/material.dart';
import 'package:petshop_template/src/config/custom_colors.dart';

class QuantityWidget extends StatelessWidget {
  final int value;
  final String suffixText;
  final Function(int quantity) result;
  final bool isRemovable;

  const QuantityWidget({
    super.key,
    required this.value,
    required this.suffixText,
    required this.result,
    this.isRemovable = false,
  });

  @override
  Widget build(BuildContext context) {
    var qtd = value;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Controle de quantidade
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botão de Remover/Diminuir
              _QuantityButton(
                color: !isRemovable || value > 1
                    ? Colors.grey.shade400
                    : Colors.red.shade400,
                icon: !isRemovable || value > 1
                    ? Icons.remove
                    : Icons.delete_forever,
                onPressed: () {
                  if (qtd == 1 && !isRemovable) {
                    return;
                  }
                  qtd--;
                  result(qtd);
                },
              ),

              // Valor da quantidade
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$value$suffixText',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Botão de Adicionar
              _QuantityButton(
                color: CustomColors.colorBottonCompra,
                icon: Icons.add,
                onPressed: () {
                  qtd++;
                  result(qtd);
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Botão de Excluir
        TextButton.icon(
          onPressed: () {
            qtd = 0;
            result(qtd);
          },
          icon: const Icon(
            Icons.delete_outline,
            size: 16,
            color: Colors.red,
          ),
          label: const Text(
            'Excluir',
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: Size.zero,
          ),
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Container(
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
}
