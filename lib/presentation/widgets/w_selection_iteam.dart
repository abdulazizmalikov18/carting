import 'package:cached_network_image/cached_network_image.dart';
import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/data/models/transportation_types_model.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/widgets/w_shimmer.dart';
import 'package:flex_dropdown/flex_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class WSelectionItam extends StatefulWidget {
  const WSelectionItam({super.key, required this.onTap, this.selectedIndex});
  final Function(int index) onTap;
  final int? selectedIndex;

  @override
  State<WSelectionItam> createState() => _WSelectionItamState();
}

class _WSelectionItamState extends State<WSelectionItam> {
  final OverlayPortalController _controller = OverlayPortalController();
  MenuPosition position = MenuPosition.bottomStart;
  bool dismissOnTapOutside = true;
  bool useButtonSize = true;
  int selIndex = 0;
  bool isFirst = false;

  @override
  void initState() {
    selIndex = widget.selectedIndex ?? 0;
    isFirst = widget.selectedIndex != null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvertisementBloc, AdvertisementState>(
      builder: (context, state) {
        if (state.statusTrTypes.isInProgress) {
          return const WShimmer(height: 80, width: double.infinity);
        }
        if (state.transportationTypes.isNotEmpty) {
          if (isFirst) {
            selIndex = state.transportationTypes.indexWhere(
              (element) => element.id == widget.selectedIndex,
            );
            isFirst = false;
          }
          return RawFlexDropDown(
            controller: _controller,
            menuPosition: position,
            dismissOnTapOutside: dismissOnTapOutside,
            buttonBuilder: (context, onTap) => Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.color.contColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: wboxShadow2,
              ),
              child: GestureDetector(
                onTap: onTap,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.transportType}:",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: context.color.white,
                              ),
                            ),
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              text: TextSpan(
                                text:
                                    "${state.transportationTypes[selIndex].name}, ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: context.color.white,
                                ),
                                children: [
                                  TextSpan(
                                    text: state
                                        .transportationTypes[selIndex]
                                        .volume,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: context.color.darkText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CachedNetworkImage(
                      imageUrl: state.transportationTypes[selIndex].icon,
                      height: 48,
                      width: 86,
                      errorWidget: (context, url, error) => const SizedBox(),
                    ),
                    AppIcons.arrowBottom.svg(color: context.color.darkText),
                  ],
                ),
              ),
            ),
            menuBuilder: (context, width) {
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: _MenuWidget(
                  width: useButtonSize ? width : 300,
                  transportationTypes: state.transportationTypes,
                  carId: selIndex,
                  onItemTap: (index) {
                    selIndex = index;
                    widget.onTap(selIndex);
                    _controller.hide();
                    setState(() {});
                  },
                ),
              );
            },
          );
        }
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.color.contColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: wboxShadow2,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.transportType}:",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: context.color.white,
                        ),
                      ),
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        text: TextSpan(
                          text: "Transport topilmadi?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: context.color.white,
                          ),
                          // children: [
                          //   TextSpan(
                          //     text:
                          //         "state.transportationTypes[selIndex].volume",
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.w400,
                          //       color: context.color.darkText,
                          //     ),
                          //   ),
                          // ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CachedNetworkImage(
                imageUrl: "state.transportationTypes[selIndex].icon",
                height: 48,
                width: 86,
                errorWidget: (context, url, error) => const SizedBox(),
              ),
              AppIcons.arrowBottom.svg(color: context.color.darkText),
            ],
          ),
        );
      },
    );
  }
}

class _MenuWidget extends StatelessWidget {
  const _MenuWidget({
    this.width,
    required this.onItemTap,
    required this.transportationTypes,
    required this.carId,
  });

  final double? width;
  final Function(int index) onItemTap;
  final int carId;
  final List<TransportationTypesModel> transportationTypes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            onItemTap(index);
          },
          child: SizedBox(
            height: 72,
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl: transportationTypes[index].icon,
                  height: 72,
                  width: 82,
                  errorWidget: (context, url, error) => const SizedBox(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        transportationTypes[index].name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        transportationTypes[index].volume,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: context.color.darkText,
                        ),
                      ),
                    ],
                  ),
                ),
                carId == index
                    ? AppIcons.checkboxRadio.svg()
                    : AppIcons.checkboxRadioDis.svg(),
              ],
            ),
          ),
        ),
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemCount: transportationTypes.length,
      ),
    );
  }
}
