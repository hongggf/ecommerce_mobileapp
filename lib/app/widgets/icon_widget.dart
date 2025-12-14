import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color iconColor;
  final Color backgroundColor;
  final double padding;
  final VoidCallback? onTap;

  const IconWidget({
    super.key,
    required this.icon,
    this.size = 24,
    this.iconColor = Colors.white,
    this.backgroundColor = Colors.white,
    this.padding = 8,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: size,
        color: iconColor,
      ),
    );
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size + padding),
        child: content,
      );
    }
    return content;
  }
}