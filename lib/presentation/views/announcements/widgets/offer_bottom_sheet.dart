import 'package:cached_network_image/cached_network_image.dart';
import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/data/models/advertisement_model.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/widgets/car_number_iteam.dart';
import 'package:carting/presentation/widgets/custom_text_field.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_scale_animation.dart';
import 'package:carting/presentation/widgets/w_shimmer.dart';
import 'package:flex_dropdown/flex_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class OfferBottomSheet extends StatefulWidget {
  const OfferBottomSheet({
    super.key,
    required this.model,
    required this.bloc,
    required this.isOnlyCars,
  });
  final AdvertisementModel model;
  final AdvertisementBloc bloc;
  final bool isOnlyCars;

  @override
  State<OfferBottomSheet> createState() => _OfferBottomSheetState();
}

class _OfferBottomSheetState extends State<OfferBottomSheet> {
  String selectedCar = "01 A 111 AA"; // Default car number
  final TextEditingController priceController = TextEditingController();
  int carId = 0;
  final OverlayPortalController _controller = OverlayPortalController();
  bool dismissOnTapOutside = true;
  bool useButtonSize = true;

  @override
  void initState() {
    if (widget.isOnlyCars) {
      if (widget.bloc.state.advertisementMyCars.isEmpty) {
        widget.bloc.add(GetAdvertisementsMyCarsEvent());
      }
    } else {
      if (widget.bloc.state.advertisementRECEIVE.isEmpty) {
        widget.bloc.add(GetAdvertisementsReceiveEvent());
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        spacing: 12,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 64,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFC2C2C2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.color.scaffoldBackground,
              boxShadow: wboxShadow2,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 24, height: 24),
                    Expanded(
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              "ID ${widget.model.id}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              AppLocalizations.of(context)!.sendProposalForAd,
                              style: TextStyle(
                                color: context.color.darkText,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    WScaleAnimation(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: AppIcons.close.svg(height: 24, width: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                BlocBuilder<AdvertisementBloc, AdvertisementState>(
                  bloc: widget.bloc,
                  builder: (context, state) {
                    if (state.statusMyCars.isInProgress) {
                      return const WShimmer(height: 80, width: double.infinity);
                    }
                    if (state.advertisementMyCars.isEmpty) {
                      return const SizedBox();
                    }
                    return RawFlexDropDown(
                      controller: _controller,
                      menuPosition: MenuPosition.topStart,
                      dismissOnTapOutside: dismissOnTapOutside,
                      buttonBuilder: (context, onTap) => GestureDetector(
                        onTap: onTap,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 4, 16, 4),
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: context.color.contColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CachedNetworkImage(
                                imageUrl:
                                    state
                                        .advertisementMyCars[carId]
                                        .transportIcon ??
                                    "",
                                height: 48,
                                width: 86,
                              ),
                              CarNumberIteam(
                                carNumberFirst:
                                    state
                                        .advertisementMyCars[carId]
                                        .details
                                        ?.transportNumber
                                        .toString()
                                        .substring(0, 2) ??
                                    "01",
                                carNumberSecond:
                                    state
                                        .advertisementMyCars[carId]
                                        .details
                                        ?.transportNumber
                                        .toString()
                                        .substring(2) ??
                                    "A 111 AA",
                              ),
                              AppIcons.arrowBottom.svg(),
                            ],
                          ),
                        ),
                      ),
                      menuBuilder: (context, width) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Container(
                          width: useButtonSize ? width : 300,
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
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                carId = index;
                                _controller.hide();
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(
                                  12,
                                  4,
                                  16,
                                  4,
                                ),
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: context.color.contColor,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl:
                                          state
                                              .advertisementMyCars[index]
                                              .transportIcon ??
                                          "",
                                      height: 48,
                                      width: 86,
                                    ),
                                    CarNumberIteam(
                                      carNumberFirst:
                                          state
                                              .advertisementMyCars[index]
                                              .details
                                              ?.transportNumber
                                              .toString()
                                              .substring(0, 2) ??
                                          "01",
                                      carNumberSecond:
                                          state
                                              .advertisementMyCars[index]
                                              .details
                                              ?.transportNumber
                                              .toString()
                                              .substring(2) ??
                                          "A 111 AA",
                                    ),
                                    carId == index
                                        ? AppIcons.checkboxRadio.svg()
                                        : AppIcons.checkboxRadioDis.svg(),
                                  ],
                                ),
                              ),
                            ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(),
                            itemCount: state.advertisementMyCars.length,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  title: "Narx taklif qiling!",
                  hintText: "0",
                  height: 48,
                  borderRadius: 16,
                  suffixIcon: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: context.color.contColor,
                    ),
                    child: Text(
                      "UZS",
                      style: TextStyle(
                        color: context.color.darkText,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  fillColor: context.color.scaffoldBackground,
                ),
                const SizedBox(height: 16),
                BlocBuilder<AdvertisementBloc, AdvertisementState>(
                  bloc: widget.bloc,
                  builder: (context, state) {
                    return WButton(
                      isDisabled: state.advertisementMyCars.isEmpty,
                      onTap: () {
                        widget.bloc.add(
                          SendOffersEvent(
                            advertisementId: widget.model.id,
                            fromAdvertisementId:
                                state.advertisementMyCars[carId].id,
                            fromMyAdvertisement: true,
                            sum: int.tryParse(priceController.text) ?? 0,
                            onSuccess: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        );
                      },
                      text: AppLocalizations.of(context)!.sendProposal,
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
