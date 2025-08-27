import 'package:carting/assets/colors/colors.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:flutter/material.dart';

class BottomContainer extends StatelessWidget {
  const BottomContainer({super.key, required this.child, required this.bottom});

  final Widget child;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottom > 0 ? 12 : 32),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        color: context.color.contColor,
        boxShadow: wboxShadow2,
      ),
      child: child,
    );
  }
}
