import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/data/models/services_filtr_model.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/common/w_select_servis_iteam.dart';
import 'package:carting/presentation/widgets/custom_text_field.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_claendar.dart';
import 'package:carting/presentation/widgets/w_scale_animation.dart';
import 'package:carting/utils/enum_filtr.dart';
import 'package:carting/utils/my_function.dart';
import 'package:flutter/material.dart';

class FilterView extends StatefulWidget {
  const FilterView({
    super.key,
    required this.filterType,
    required this.list,
    this.servicesList = const [],
    this.dateTime,
    this.dateTime2,
    this.fromPrice,
    this.toPrice,
    required this.onSaved,
  });
  final FilterType filterType;
  final List<bool> list;
  final List<ServicesFiltrModel> servicesList;
  final DateTime? dateTime;
  final DateTime? dateTime2;
  final int? fromPrice;
  final int? toPrice;
  final Function(
    DateTime? dateTime,
    DateTime? dateTime2,
    int? fromPrice,
    int? toPrice,
  )
  onSaved;

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  late List<bool> listActive;
  late List<ServicesFiltrModel> servicesList;
  late TextEditingController dateTime;
  late TextEditingController dateTime2;
  late TextEditingController fromPrice;
  late TextEditingController toPrice;
  List<String> list = ["Polirovka", "Keramika", "Bo’yoq", "Myatina"];
  int servisIndex = 0;

  @override
  void initState() {
    listActive = widget.list;
    servicesList = widget.servicesList;
    dateTime = TextEditingController(
      text: widget.dateTime == null
          ? ''
          : MyFunction.dateFormat(widget.dateTime!),
    );
    dateTime2 = TextEditingController(
      text: widget.dateTime2 == null
          ? ''
          : MyFunction.dateFormat(widget.dateTime2!),
    );
    fromPrice = TextEditingController(
      text: widget.fromPrice == null ? '' : widget.fromPrice.toString(),
    );
    toPrice = TextEditingController(
      text: widget.toPrice == null ? '' : widget.toPrice.toString(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.filter),
        actions: [
          TextButton(
            onPressed: () {
              listActive = [true, true, true, true, true];
              servisIndex = 0;
              for (var i = 0; i < servicesList.length; i++) {
                servicesList[i].isActive = true;
              }
              dateTime.clear();
              dateTime2.clear();
              fromPrice.clear();
              toPrice.clear();
              setState(() {});
            },
            child: Text(
              AppLocalizations.of(context)!.clear,
              style: const TextStyle(color: red),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: WButton(
          margin: const EdgeInsets.all(16),
          text: AppLocalizations.of(context)!.save,
          onTap: () {
            widget.onSaved(
              dateTime.text.isEmpty
                  ? null
                  : MyFunction.stringToDate(dateTime.text),
              dateTime2.text.isEmpty
                  ? null
                  : MyFunction.stringToDate(dateTime2.text),
              int.tryParse(fromPrice.text),
              int.tryParse(toPrice.text),
            );
            Navigator.of(context).pop(true);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Builder(
              builder: (context) {
                switch (widget.filterType) {
                  case FilterType.workshopServices:
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: context.color.contColor,
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.services,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: context.color.darkText,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: List.generate(
                              list.length,
                              (index) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: context.color.contGrey,
                                  boxShadow: [
                                    BoxShadow(
                                      color: green.withValues(alpha: .32),
                                      blurRadius: 16,
                                      spreadRadius: -24,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 16,
                                ),
                                child: Text(
                                  list[index],
                                  style: const TextStyle(
                                    color: white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  case FilterType.services:
                    return Column(
                      children: [
                        WselectServisIteam(
                          onTap: (index, servisId) {
                            servisIndex = index;
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: context.color.contColor,
                          ),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Reyting",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: context.color.darkText,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: List.generate(
                                  5,
                                  (index) => WScaleAnimation(
                                    onTap: () {
                                      listActive[index] = !listActive[index];
                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: listActive[index]
                                            ? green
                                            : context.color.scaffoldBackground,
                                        boxShadow: listActive[index]
                                            ? [
                                                BoxShadow(
                                                  color: green.withValues(
                                                    alpha: .32,
                                                  ),
                                                  blurRadius: 16,
                                                  spreadRadius: -24,
                                                  offset: const Offset(0, 8),
                                                ),
                                              ]
                                            : [],
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 14,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AppIcons.star.svg(
                                            color: listActive[index]
                                                ? white
                                                : context.color.white,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            (index + 1).toString(),
                                            style: TextStyle(
                                              color: listActive[index]
                                                  ? white
                                                  : context.color.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  case FilterType.searchAd:
                    return Column(
                      children: [
                        _servicesListIteam(context),
                        const SizedBox(height: 12),
                        _fromToDate(context),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: context.color.contColor,
                          ),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.price,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: context.color.darkText,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                spacing: 12,
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      controller: fromPrice,
                                      height: 48,
                                      borderRadius: 16,
                                      fillColor: context.color.contColor,
                                      hintText: '0',
                                      keyboardType: TextInputType.number,
                                      prefixIcon: Text(
                                        AppLocalizations.of(context)!.from_in,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: context.color.darkText,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: CustomTextField(
                                      controller: toPrice,
                                      height: 48,
                                      borderRadius: 16,
                                      fillColor: context.color.contColor,
                                      hintText: '0',
                                      keyboardType: TextInputType.number,
                                      prefixIcon: Text(
                                        AppLocalizations.of(context)!.to_in,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: context.color.darkText,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  case FilterType.searchTransport:
                    return Column(
                      children: [
                        _servicesListIteam(context),
                        const SizedBox(height: 12),
                        _fromToDate(context),
                      ],
                    );
                  default:
                    return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Container _servicesListIteam(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: context.color.contColor,
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.services,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: context.color.darkText,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(
              servicesList.length,
              (index) => GestureDetector(
                onTap: () {
                  servicesList[index].isActive = !servicesList[index].isActive;
                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: servicesList[index].isActive
                        ? green
                        : context.color.scaffoldBackground,
                    boxShadow: servicesList[index].isActive
                        ? [
                            BoxShadow(
                              color: green.withValues(alpha: .32),
                              blurRadius: 16,
                              spreadRadius: -24,
                              offset: const Offset(0, 8),
                            ),
                          ]
                        : [],
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ),
                  child: Text(
                    servicesList[index].name,
                    style: TextStyle(
                      color: servicesList[index].isActive
                          ? white
                          : context.color.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _fromToDate(BuildContext context) {
    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: context.color.contColor,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: CustomTextField(
              controller: dateTime,
              height: 48,
              borderRadius: 16,
              fillColor: context.color.contColor,
              hintText: '00.00.0000',
              maxLines: 1,
              expands: false,
              contentPadding: const EdgeInsets.only(
                left: 0,
                top: 12,
                right: 12,
              ),
              title:
                  '${AppLocalizations.of(context)!.date} (${AppLocalizations.of(context)!.from_in})',
              readOnly: true,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => WClaendar(
                    selectedDate: MyFunction.stringToDate(dateTime.text),
                  ),
                ).then((value) {
                  if (value != null) {
                    dateTime.text = MyFunction.dateFormat(value);
                  }
                });
              },
              keyboardType: TextInputType.datetime,
              prefixIcon: AppIcons.calendar.svg(),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: context.color.contColor,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: CustomTextField(
              controller: dateTime2,
              height: 48,
              borderRadius: 16,
              readOnly: true,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => WClaendar(
                    selectedDate: MyFunction.stringToDate(dateTime2.text),
                  ),
                ).then((value) {
                  if (value != null) {
                    dateTime2.text = MyFunction.dateFormat(value);
                  }
                });
              },
              fillColor: context.color.contColor,
              hintText: '00.00.0000',
              maxLines: 1,
              contentPadding: const EdgeInsets.only(
                left: 0,
                top: 12,
                right: 12,
              ),
              expands: false,
              title:
                  '${AppLocalizations.of(context)!.date} (${AppLocalizations.of(context)!.to_in})',
              keyboardType: TextInputType.datetime,
              prefixIcon: AppIcons.calendar.svg(),
            ),
          ),
        ),
      ],
    );
  }
}
