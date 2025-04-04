import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:flutter/material.dart';

class WTitle extends StatelessWidget {
  const WTitle({
    super.key,
    required this.title,
    this.color,
  });
  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color ?? context.color.contColor,
        border: Border.all(color: context.color.contGrey),
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: context.color.darkText,
        ),
      ),
    );
  }
}
