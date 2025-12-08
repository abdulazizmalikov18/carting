import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:flutter/material.dart';

class LoadWeightIteam extends StatelessWidget {
  const LoadWeightIteam({
    super.key,
    required this.controllerKg,
    required this.controllerm3,
    required this.controllerLitr,
    required this.onUpdateButtonState,
    required this.selectedUnit,
  });
  final TextEditingController controllerKg;
  final TextEditingController controllerm3;
  final TextEditingController controllerLitr;
  final Function() onUpdateButtonState;
  final ValueNotifier<String> selectedUnit;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.color.contColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: wboxShadow2,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Row(
            spacing: 24,
            children: [
              Expanded(
                child: Text(
                  "${AppLocalizations.of(context)!.loadWeight}:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: context.color.white,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  "${AppLocalizations.of(context)!.cargoVolume}:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: context.color.white,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  "${AppLocalizations.of(context)!.cargoCapacity}:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: context.color.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 24,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    spacing: 4,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controllerKg,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.length <= 1) {
                              onUpdateButtonState();
                            }
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            hintText: '0',
                            hintStyle: TextStyle(color: context.color.darkText),
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Builder(
                        builder: (context) => GestureDetector(
                          onTap: () async {
                            final RenderBox button =
                                context.findRenderObject() as RenderBox;
                            final RenderBox overlay =
                                Overlay.of(context).context.findRenderObject()
                                    as RenderBox;

                            final RelativeRect position = RelativeRect.fromRect(
                              Rect.fromPoints(
                                button.localToGlobal(
                                  Offset(0, button.size.height),
                                  ancestor: overlay,
                                ),
                                button.localToGlobal(
                                  button.size.bottomRight(Offset.zero),
                                  ancestor: overlay,
                                ),
                              ),
                              Offset.zero & overlay.size,
                            );

                            String? selected = await showMenu<String>(
                              context: context,
                              position: position,
                              color: white,
                              shadowColor: black.withValues(alpha: .3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              items:
                                  [
                                    AppLocalizations.of(context)!.unit_kg,
                                    AppLocalizations.of(context)!.unit_tn,
                                  ].map((choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      height: 40,
                                      child: Row(
                                        children: [
                                          Text(
                                            choice,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          const Spacer(),
                                          SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: choice == selectedUnit.value
                                                ? AppIcons.checkboxRadio.svg()
                                                : AppIcons.checkboxRadioDis
                                                      .svg(),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                            );

                            if (selected != null) {
                              selectedUnit.value = selected;
                            }
                          },
                          child: ValueListenableBuilder(
                            valueListenable: selectedUnit,
                            builder: (context, value, child) => Row(
                              children: [
                                Text(
                                  selectedUnit.value,
                                  style: TextStyle(
                                    color: context.color.darkText,
                                  ),
                                ),
                                AppIcons.arrowBottom.svg(
                                  color: context.color.iron,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(width: 24),
                Expanded(
                  child: Row(
                    spacing: 4,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controllerm3,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.length <= 1) {
                              onUpdateButtonState();
                            }
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            hintText: '0',
                            hintStyle: TextStyle(color: context.color.darkText),
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.unit_m3,
                        style: TextStyle(color: context.color.darkText),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(width: 24),
                Expanded(
                  child: Row(
                    spacing: 4,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controllerLitr,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.length <= 1) {
                              onUpdateButtonState();
                            }
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            hintText: '0',
                            hintStyle: TextStyle(color: context.color.darkText),
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Text(
                        'litr',
                        style: TextStyle(color: context.color.darkText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
