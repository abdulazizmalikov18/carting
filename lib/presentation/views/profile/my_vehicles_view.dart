import 'package:carting/assets/assets/icons.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:flutter/material.dart';

class MyVehiclesView extends StatefulWidget {
  const MyVehiclesView({super.key});

  @override
  State<MyVehiclesView> createState() => _MyVehiclesViewState();
}

class _MyVehiclesViewState extends State<MyVehiclesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mening transportlarim')),
      body: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Transportlaringiz shu yerda\nbo‘ladi. Ularni qo‘shing',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: context.color.darkText,
            ),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WButton(
                onTap: () {},
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  spacing: 8,
                  children: [
                    AppIcons.addCircle.svg(),
                    const Text("Transport qo‘shish"),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
