import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class WShimmer extends StatelessWidget {
  const WShimmer({super.key, this.width, this.height, this.radius});

  final double? width;
  final double? height;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.color.grey.withValues(alpha: .5),
      highlightColor: context.color.grey.withValues(alpha: .8),
      child: Container(
        height: height ?? double.infinity,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 16),
          color: context.color.white,
        ),
      ),
    );
  }
}
