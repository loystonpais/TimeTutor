import 'package:flutter/material.dart';

class InfoBar extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? color;

  const InfoBar({
    super.key,
    required this.child,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = theme.colorScheme.surface;

    final baseColor = color ?? theme.primaryColor;

    // Calculate blended background colors
    final baseBlend = Color.alphaBlend(
      baseColor.withAlpha(isDark ? 0x1A : 0x0D),
      surfaceColor,
    );

    final gradientColors = [
      Color.alphaBlend(baseColor.withAlpha(0x99), surfaceColor),
      Color.alphaBlend(baseColor.withAlpha(0x4D), surfaceColor),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 6,
        shadowColor: Colors.black.withAlpha(isDark ? 0x66 : 0x33),
        color: baseBlend,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          splashFactory: InkSparkle.splashFactory,
          splashColor: baseColor.withAlpha(0x33),
          highlightColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              backgroundBlendMode:
                  isDark ? BlendMode.softLight : BlendMode.multiply,
            ),
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: Color.alphaBlend(
                  theme.colorScheme.onSurface.withAlpha(0xCC),
                  baseBlend,
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
