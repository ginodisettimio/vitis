import 'package:flutter/material.dart';
import 'package:vitis/widgets/avatars/avatar_box.dart';

class ProfileHeader extends StatelessWidget {
  final Widget avatar;
  final String name;
  final String email;
  final IconData actionIcon;
  final VoidCallback? onActionTap;

  const ProfileHeader({
    super.key,
    required this.avatar,
    required this.name,
    required this.email,
    this.actionIcon = Icons.edit_square,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      color: theme.cardTheme.color ?? colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Row(
        children: [
          AvatarBox(child: avatar),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Material(
            color: colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: onActionTap,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(actionIcon, color: colorScheme.primary, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
