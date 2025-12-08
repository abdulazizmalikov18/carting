import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/widgets/cargo_type_item.dart';
import 'package:carting/utils/my_function.dart';
import 'package:flex_dropdown/flex_dropdown.dart';
import 'package:flutter/widgets.dart';

class LoadTypeIteam extends StatefulWidget {
  const LoadTypeIteam({super.key, required this.list, required this.onItemTap});
  final List<CargoTypeValu> list;
  final Function(List<CargoTypeValu>) onItemTap;

  @override
  State<LoadTypeIteam> createState() => _LoadTypeIteamState();
}

class _LoadTypeIteamState extends State<LoadTypeIteam> {
  final OverlayPortalController overlayPortalController =
      OverlayPortalController();
  MenuPosition position = MenuPosition.bottomStart;
  bool dismissOnTapOutside = true;
  @override
  Widget build(BuildContext context) {
    return RawFlexDropDown(
      controller: overlayPortalController,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                "${AppLocalizations.of(context)!.cargoType}:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: context.color.white,
                ),
              ),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: Text(
                      MyFunction.listText(widget.list).isEmpty
                          ? AppLocalizations.of(context)!.cargoType
                          : MyFunction.listText(widget.list),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: MyFunction.listText(widget.list).isEmpty
                            ? context.color.darkText
                            : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AppIcons.arrowBottom.svg(color: context.color.iron),
                ],
              ),
            ],
          ),
        ),
      ),
      menuBuilder: (context, width) => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: CargoTypeItem(
          width: width,
          list: widget.list,
          onItemTap: (listValue) {
            widget.onItemTap(listValue);
          },
        ),
      ),
    );
  }
}
