import 'package:carting/assets/assets/icons.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/orders/type_of_service_view.dart';
import 'package:flex_dropdown/flex_dropdown.dart';
import 'package:flutter/material.dart';

class WselectServisIteam extends StatefulWidget {
  const WselectServisIteam({
    super.key,
    required this.onTap,
    this.isCar = false,
  });
  final Function(int index, int serviceId) onTap;
  final bool isCar;

  @override
  State<WselectServisIteam> createState() => _WselectServisIteamState();
}

class _WselectServisIteamState extends State<WselectServisIteam> {
  final OverlayPortalController _controller = OverlayPortalController();
  MenuPosition position = MenuPosition.bottomStart;
  bool dismissOnTapOutside = true;
  bool useButtonSize = true;
  int selIndex = 0;

  late List<TypeOfService> listServis;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listServis = widget.isCar
        ? [
            // TypeOfService(
            //   icon: AppIcons.delivery.svg(height: 40, width: 40),
            //   text: AppLocalizations.of(context)!.delivery,
            //   screen: const SizedBox(),
            //   serviceId: 9,
            // ),
            TypeOfService(
              icon: AppIcons.shipping.svg(height: 40, width: 40),
              text: AppLocalizations.of(context)!.shipping,
              screen: const SizedBox(),
              serviceId: 1,
            ),
            TypeOfService(
              icon: AppIcons.transportationOfPassengers
                  .svg(height: 40, width: 40),
              text: AppLocalizations.of(context)!.passengerTransport,
              screen: const SizedBox(),
              serviceId: 2,
            ),
            // TypeOfService(
            //   icon: AppIcons.specialTechnique.svg(height: 40, width: 40),
            //   text: AppLocalizations.of(context)!.specialTechServices,
            //   screen: const SizedBox(),
            //   serviceId: 3,
            // ),
            // TypeOfService(
            //   icon: AppIcons.transportationTransfer.svg(),
            //   text: AppLocalizations.of(context)!.transportTransfer,
            //   screen: const SizedBox(),
            //   serviceId: 6,
            // ),
          ]
        : [
            TypeOfService(
              icon: AppIcons.delivery.svg(height: 40, width: 40),
              text: AppLocalizations.of(context)!.delivery,
              screen: const SizedBox(),
              serviceId: 9,
            ),
            TypeOfService(
              icon: AppIcons.transportRental.svg(height: 40, width: 40),
              text: AppLocalizations.of(context)!.peregonService,
              screen: const SizedBox(),
              serviceId: 10,
            ),
            TypeOfService(
              icon: AppIcons.shipping.svg(height: 40, width: 40),
              text: AppLocalizations.of(context)!.shipping,
              screen: const SizedBox(),
              serviceId: 1,
            ),
            TypeOfService(
              icon: AppIcons.fuelDeliver.svg(),
              text: AppLocalizations.of(context)!.fuelDelivery,
              screen: const SizedBox(),
              serviceId: 8,
            ),
            TypeOfService(
              icon: AppIcons.transportationOfPassengers
                  .svg(height: 40, width: 40),
              text: AppLocalizations.of(context)!.passengerTransport,
              screen: const SizedBox(),
              serviceId: 2,
            ),
            TypeOfService(
              icon: AppIcons.car_3.svg(),
              text: AppLocalizations.of(context)!.carRental,
              screen: const SizedBox(),
              serviceId: 4,
            ),
            TypeOfService(
              icon: AppIcons.specialTechnique.svg(height: 40, width: 40),
              text: AppLocalizations.of(context)!.specialTechServices,
              screen: const SizedBox(),
              serviceId: 3,
            ),
            TypeOfService(
              icon: AppIcons.autoRepair.svg(),
              text: AppLocalizations.of(context)!.autoRepair,
              screen: const SizedBox(),
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
          ];
  }

  @override
  Widget build(BuildContext context) {
    return RawFlexDropDown(
      controller: _controller,
      menuPosition: position,
      dismissOnTapOutside: dismissOnTapOutside,
      buttonBuilder: (context, onTap) {
        return Container(
          decoration: BoxDecoration(
            color: context.color.contColor,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: GestureDetector(
            onTap: onTap,
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.serviceType,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: context.color.darkText,
                  ),
                ),
                Row(
                  children: [
                    if (!widget.isCar)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: listServis[selIndex].icon,
                      ),
                    Expanded(
                      child: Text(
                        listServis[selIndex].text,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    AppIcons.arrowBottom.svg(color: context.color.darkText),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      menuBuilder: (context, width) {
        return Padding(
          padding: const EdgeInsets.only(top: 4),
          child: MenuWidget(
            width: useButtonSize ? width : 300,
            transportationTypes: listServis,
            isCar: widget.isCar,
            onItemTap: (index) {
              selIndex = index;
              widget.onTap(selIndex,listServis[index].serviceId);
              _controller.hide();
              setState(() {});
            },
          ),
        );
      },
    );
  }
}

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    super.key,
    this.width,
    required this.onItemTap,
    required this.transportationTypes,
    required this.isCar,
  });

  final double? width;
  final Function(int index) onItemTap;
  final List<TypeOfService> transportationTypes;
  final bool isCar;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(maxHeight: 250),
      decoration: BoxDecoration(
        color: context.color.contColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 32,
            offset: Offset(0, 20),
            spreadRadius: -8,
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            onItemTap(index);
          },
          contentPadding: EdgeInsets.only(left: isCar ? 0 : 16, right: 12),
          title: Text(transportationTypes[index].text),
          leading: isCar ? null : transportationTypes[index].icon,
          minVerticalPadding: 0,
          trailing: AppIcons.arrowForward.svg(color: context.color.iron),
        ),
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemCount: transportationTypes.length,
      ),
    );
  }
}
