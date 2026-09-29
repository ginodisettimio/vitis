import 'package:flutter/material.dart';
import 'package:vitis/utils/app_theme.dart';

class SeeAllTextButton extends StatelessWidget {
  final String route;

  const SeeAllTextButton({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: AppTheme.primary,
      ),
      child: const Text(
        'Ver todo',
        style: TextStyle(
          color: AppTheme.primary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
