import 'package:carting/assets/assets/icons.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:flutter/material.dart';

class WInfoContainer extends StatelessWidget {
  const WInfoContainer({
    super.key,
    required this.text,
    this.icon,
    this.padding,
    this.iconCollor = true, this.iconLast,
  });
  final String text;
  final String? icon;
  final bool iconCollor;
  final EdgeInsetsGeometry? padding;
  final Widget? iconLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: context.color.grey.withValues(alpha: .5),
      ),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          if (icon != null)
            icon!.svg(
              height: 24,
              color: iconCollor ? context.color.iconGrey : null,
            ),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: context.color.iconGrey,
            ),
          ),
          
        ],
      ),
    );
  }
}
