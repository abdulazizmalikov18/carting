import 'package:carting/assets/assets/icons.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/auto_repair/auto_repair_view.dart';
import 'package:flutter/material.dart';

class TypeOfServiceView extends StatefulWidget {
  const TypeOfServiceView({super.key});

  @override
  State<TypeOfServiceView> createState() => _TypeOfServiceViewState();
}

class _TypeOfServiceViewState extends State<TypeOfServiceView> {
  late List<TypeOfService> list;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    list = [
      TypeOfService(
        icon: AppIcons.shipping.svg(height: 40, width: 40),
        text: AppLocalizations.of(context)!.shipping,
        screen: const SizedBox(),
        serviceId: 1,
      ),
      TypeOfService(
        icon: AppIcons.transportationOfPassengers.svg(height: 40, width: 40),
        text: AppLocalizations.of(context)!.passengerTransport,
        screen: const SizedBox(),
        serviceId: 2,
      ),
      TypeOfService(
        icon: AppIcons.specialTechnique.svg(height: 40, width: 40),
        text: AppLocalizations.of(context)!.specialTechServices,
        screen: const SizedBox(),
        serviceId: 3,
      ),
      TypeOfService(
        icon: AppIcons.transportRental.svg(height: 40, width: 40),
        text: AppLocalizations.of(context)!.carRental,
        screen: const SizedBox(),
        serviceId: 4,
      ),
      TypeOfService(
        icon: AppIcons.autoRepair.svg(),
        text: AppLocalizations.of(context)!.autoRepair,
        screen: const AutoRepairView(),
        serviceId: 5,
      ),
      TypeOfService(
        icon: AppIcons.transportationTransfer.svg(),
        text: AppLocalizations.of(context)!.transportTransfer,
        screen: const SizedBox(),
        serviceId: 6,
      ),
      TypeOfService(
        icon: AppIcons.inTheWarehouseStorage.svg(),
        text: AppLocalizations.of(context)!.warehouseStorage,
        screen: const SizedBox(),
        serviceId: 7,
      ),
      TypeOfService(
        icon: AppIcons.fuelDeliver.svg(),
        text: AppLocalizations.of(context)!.fuelDelivery,
        screen: const SizedBox(),
        serviceId: 8,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.serviceType)),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          mainAxisExtent: 120,
        ),
        itemCount: list.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => list[index].screen));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: context.color.contColor,
            ),
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: MediaQuery.sizeOf(context).width / 8,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                list[index].icon,
                const SizedBox(height: 4),
                Text(
                  list[index].text,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TypeOfService {
  final Widget icon;
  final String text;
  final Widget screen;
  final int serviceId;

  TypeOfService({
    required this.icon,
    required this.text,
    required this.screen,
    required this.serviceId,
  });
}

class TyperIteam {
  final Widget icon;
  final String text;
  final String subTitle;
  final Widget screen;

  TyperIteam({
    required this.icon,
    required this.text,
    required this.subTitle,
    required this.screen,
  });
}
