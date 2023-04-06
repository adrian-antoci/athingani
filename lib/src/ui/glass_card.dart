import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

///
///
///
class GlassCardWidget extends StatelessWidget {
  final Widget child;

  const GlassCardWidget({required this.child, super.key});

  static const double _cardMargin = 30;
  static const double _borderRadius = 40;
  static const double _blur = 20;
  static const String _background = 'assets/background.jpeg';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_background),
          fit: BoxFit.cover,
        ),
      ),
      child: GlassmorphicContainer(
        height: double.infinity,
        width: double.infinity,
        borderRadius: _borderRadius,
        blur: _blur,
        alignment: Alignment.bottomCenter,
        border: 0,
        linearGradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
          const Color(0xFFffffff).withOpacity(0.1),
          const Color(0xFFFFFFFF).withOpacity(0.05),
        ], stops: const [
          0.1,
          1,
        ]),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFffffff).withOpacity(0.5),
            const Color(0xFFFFFFFF).withOpacity(0.5),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(_cardMargin / 3),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: const BorderRadius.all(
              Radius.circular(_borderRadius),
            ),
          ),
          width: double.infinity,
          height: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_borderRadius),
            child: child,
          ),
        ),
      ),
    );
  }
}
