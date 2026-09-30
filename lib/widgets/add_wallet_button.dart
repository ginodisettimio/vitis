import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:vitis/utils/app_theme.dart';

class AddWalletButton extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/addwallet");
      },
      borderRadius: BorderRadius.circular(24),
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          radius: Radius.circular(12),
          color: AppTheme.primary,
          strokeWidth: 1.5,
          dashPattern: [6, 4],
        ),
        child: SizedBox(
          height: 60,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: AppTheme.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Agregar billetera',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
