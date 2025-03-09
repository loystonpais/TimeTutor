import 'package:flutter/material.dart';

class InfoBar extends StatelessWidget {
  final String infoText;
  final VoidCallback onTap;
  final Color color;

  const InfoBar({
    super.key,
    required this.infoText,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Using primary and secondary colors from the theme
    final Color primaryDark = Theme.of(context).primaryColorDark;
    final Color secondary = Theme.of(context).colorScheme.secondary;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.2),
        color: color.withOpacity(0.3),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: secondary.withOpacity(0.4),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // Adding a gradient that blends two colors
              gradient: LinearGradient(
                colors: [
                  primaryDark.withOpacity(0.8),
                  secondary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              // Using overlay blend mode to mix the gradient and any background color
              backgroundBlendMode: BlendMode.overlay,
            ),
            child: Text(
              infoText,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ),
    );
  }
}
