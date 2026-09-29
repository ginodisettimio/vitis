import 'package:flutter/material.dart';

class SeeAllTextButton extends StatelessWidget {
  final String route;

  const SeeAllTextButton({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
          onPressed: () {
            Navigator.pushNamed(context, route);
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Ver todo',
            style: theme.primaryTextTheme.bodySmall
          ),
        );
  }
}