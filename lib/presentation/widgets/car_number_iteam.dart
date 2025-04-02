import 'package:carting/assets/assets/images.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:flutter/material.dart';

class CarNumberIteam extends StatelessWidget {
  const CarNumberIteam({
    super.key,
    required this.carNumberFirst,
    required this.carNumberSecond,
  });
  final String carNumberFirst;
  final String carNumberSecond;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.color.white),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Text(
                carNumberFirst,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'BebasNeue',
                ),
              ),
            ),
            VerticalDivider(
              color: context.color.white,
              thickness: 1,
              width: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Text(
                carNumberSecond,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'BebasNeue',
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImages.uzb.imgAsset(height: 12, width: 12),
                const Text(
                  "UZ",
                  style: TextStyle(
                    fontSize: 6,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'BebasNeue',
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
