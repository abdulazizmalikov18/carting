import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/widgets/custom_snackbar.dart';
import 'package:carting/utils/caller.dart';
import 'package:flex_dropdown/flex_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/data/models/fuels_info_model.dart';
import 'package:carting/presentation/widgets/w_shimmer.dart';
import 'package:carting/utils/my_function.dart';

class WSelectionFuels extends StatefulWidget {
  const WSelectionFuels({
    super.key,
    required this.onTap,
  });
  final Function(FuelsInfoModel model) onTap;

  @override
  State<WSelectionFuels> createState() => _WSelectionFuelsState();
}

class _WSelectionFuelsState extends State<WSelectionFuels> {
  final OverlayPortalController _controller = OverlayPortalController();
  MenuPosition position = MenuPosition.bottomStart;
  bool dismissOnTapOutside = true;
  bool useButtonSize = true;
  int selIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvertisementBloc, AdvertisementState>(
      builder: (context, state) {
        if (state.statusFuels.isInProgress) {
          return const WShimmer(
            height: 80,
            width: double.infinity,
          );
        }
        if (state.fuelsModel.isNotEmpty) {
          return RawFlexDropDown(
            controller: _controller,
            menuPosition: position,
            dismissOnTapOutside: dismissOnTapOutside,
            buttonBuilder: (context, onTap) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: context.color.contColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: wboxShadow2,
                ),
                child: ListTile(
                  onTap: onTap,
                  title:  Text(AppLocalizations.of(context)!.company_list),
                  subtitle: Text(state.fuelsModel[selIndex].companyName),
                  minVerticalPadding: 0,
                  titleTextStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: context.color.darkText,
                  ),
                  subtitleTextStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: dark,
                  ),
                  trailing: AppIcons.arrowBottom.svg(
                    color: context.color.darkText,
                  ),
                ),
              );
            },
            menuBuilder: (context, width) {
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: MenuWidget(
                  width: useButtonSize ? width : 400,
                  fuelsModel: state.fuelsModel,
                  onItemTap: (index) {
                    selIndex = index;
                    widget.onTap(state.fuelsModel[selIndex]);
                    _controller.hide();
                    setState(() {});
                  },
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    super.key,
    this.width,
    required this.onItemTap,
    required this.fuelsModel,
  });

  final double? width;
  final Function(int index) onItemTap;
  final List<FuelsInfoModel> fuelsModel;

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
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            onItemTap(index);
          },
          child: SizedBox(
            height: 72,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        fuelsModel[index].companyName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "1 litr: ${MyFunction.priceFormat(fuelsModel[index].price)} so‘m",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        "Yetkazib berish narxi: : ${MyFunction.priceFormat(fuelsModel[index].deliveryPrice)} so‘m",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (fuelsModel[index].callPhone.isNotEmpty) {
                      await Caller.makePhoneCall(fuelsModel[index].callPhone);
                    } else {
                      CustomSnackbar.show(
                        context,
                        'Telefon raqam kiritilmagan',
                      );
                    }
                  },
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: green,
                    child: AppIcons.phone.svg(),
                  ),
                ),
              ],
            ),
          ),
        ),
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemCount: fuelsModel.length,
      ),
    );
  }
}
