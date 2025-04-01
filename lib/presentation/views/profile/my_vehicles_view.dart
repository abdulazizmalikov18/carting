import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/presentation/views/profile/add_car_view.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                onTap: () {
                  final bloc = context.read<AdvertisementBloc>();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: bloc,
                      child: const AddCarView(),
                    ),
                  ));
                },
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
