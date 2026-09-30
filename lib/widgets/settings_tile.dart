import 'package:flutter/material.dart';

class SettingsTile extends StatefulWidget {
  final Widget icon;
  final String title;
  final String? trailingText;
  final IconData? trailingIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    this.trailingIcon = Icons.chevron_right_rounded,
    this.backgroundColor,
    this.foregroundColor,
    this.onTap,
  });

  @override
  State<SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onTap == null) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardShape = theme.cardTheme.shape as RoundedRectangleBorder?;
    final borderRadius =
        cardShape?.borderRadius as BorderRadius? ?? BorderRadius.circular(16);

    final Color background = widget.backgroundColor ??
        theme.cardTheme.color ??
        theme.colorScheme.surface;
    final Color titleColor =
        widget.foregroundColor ?? theme.colorScheme.onSurface;
    final Color secondaryColor =
        theme.textTheme.bodyMedium?.color ?? Colors.grey;

    // Si se pasa un color personalizado, el borde toma ese tono.
    final BorderSide border = widget.foregroundColor != null
        ? BorderSide(color: widget.foregroundColor!.withValues(alpha: 0.2))
        : cardShape?.side ?? BorderSide.none;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            color: background,
            borderRadius: borderRadius,
            border: Border.fromBorderSide(border),
            boxShadow: widget.backgroundColor == null
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              SizedBox(width: 24, child: Center(child: widget.icon)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: titleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (widget.trailingText != null) ...[
                Text(
                  widget.trailingText!,
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                ),
                const SizedBox(width: 8),
              ],
              if (widget.trailingIcon != null)
                Icon(
                  widget.trailingIcon,
                  color: secondaryColor.withValues(alpha: 0.6),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
