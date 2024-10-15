import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/assets/images.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:flutter/material.dart';

class AutoRepairView extends StatelessWidget {
  const AutoRepairView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Avto ta’mirlash")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                leading: AppImages.workshops.imgAsset(),
                contentPadding: EdgeInsets.zero,
                title: const Text("Ustaxonalar"),
                trailing: AppIcons.arrowForward.svg(),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                leading: AppImages.masters.imgAsset(),
                contentPadding: EdgeInsets.zero,
                title: const Text("Ustalar"),
                trailing: AppIcons.arrowForward.svg(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
