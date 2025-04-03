import 'package:cached_network_image/cached_network_image.dart';
import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/assets/images.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/data/models/advertisement_model.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/announcements/widgets/offer_bottom_sheet.dart';
import 'package:carting/presentation/views/common/comments_view.dart';
import 'package:carting/presentation/views/common/location_info_view.dart';
import 'package:carting/presentation/widgets/custom_snackbar.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_info_container.dart';
import 'package:carting/utils/calculate_distance.dart';
import 'package:carting/utils/caller.dart';
import 'package:carting/utils/my_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnnouncementInfoView extends StatelessWidget {
  const AnnouncementInfoView({
    super.key,
    required this.model,
    required this.isMe,
    this.isMyCar = false,
    this.isComments = false,
    this.isOnlyCar = false,
  });
  final AdvertisementModel model;
  final bool isMe;
  final bool isMyCar;
  final bool isComments;
  final bool isOnlyCar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ID ${model.id}"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: AppIcons.share.svg(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          color: context.color.contColor,
          boxShadow: wboxShadow2,
        ),
        child: isMe
            ? Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: WButton(
                      onTap: () {},
                      color: greyBack,
                      textColor: greyText,
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppIcons.editCir.svg(color: greyText),
                          Text(AppLocalizations.of(context)!.edit),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: WButton(
                      onTap: () {
                        final bloc = context.read<AdvertisementBloc>();
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Column(
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
                                  spacing: 24,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .confirm_delete,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Row(
                                      spacing: 16,
                                      children: [
                                        Expanded(
                                          child: WButton(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            textColor: greyText,
                                            color: greyBack,
                                            text: AppLocalizations.of(context)!
                                                .no,
                                          ),
                                        ),
                                        Expanded(
                                          child: BlocBuilder<AdvertisementBloc,
                                              AdvertisementState>(
                                            bloc: bloc,
                                            builder: (context, state) {
                                              return WButton(
                                                onTap: () {
                                                  bloc.add(
                                                    DeleteAdvertisementEvent(
                                                      id: model.id,
                                                      onSucces: () {
                                                        Navigator.of(context)
                                                          ..pop()
                                                          ..pop(true);
                                                      },
                                                    ),
                                                  );
                                                },
                                                textColor: greyText,
                                                color: greyBack,
                                                text: AppLocalizations.of(
                                                        context)!
                                                    .yes,
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox()
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      color: const Color(0xFFFEEDEC),
                      textColor: red,
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppIcons.trash.svg(color: red),
                          Text(AppLocalizations.of(context)!.delete),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16,
                children: [
                  WButton(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) => const OfferBottomSheet(),
                      );
                    },
                    text: "Taklif yuborish",
                    color: greyBack,
                    textColor: greyText,
                  ),
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: WButton(
                          onTap: () async {
                            if (model.createdByTgLink != null) {
                              await Caller.launchTelegram(
                                  model.createdByTgLink!);
                            } else {
                              CustomSnackbar.show(
                                context,
                                AppLocalizations.of(context)!.unknown,
                              );
                            }
                          },
                          color: blue,
                          child: Row(
                            spacing: 8,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppIcons.telegram.svg(),
                              const Text("Telegram"),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: WButton(
                          onTap: () async {
                            if (model.createdByPhone != null) {
                              await Caller.makePhoneCall(model.createdByPhone!);
                            } else {
                              CustomSnackbar.show(
                                context,
                                AppLocalizations.of(context)!.unknown,
                              );
                            }
                          },
                          child: Row(
                            spacing: 8,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppIcons.phone.svg(),
                              Text(AppLocalizations.of(context)!.connection),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isMe) ...[
              WButton(
                onTap: () {},
                color: model.status == 'ACTIVE'
                    ? green.withValues(alpha: .2)
                    : red.withValues(alpha: .2),
                textColor: model.status == 'ACTIVE' ? green : red,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                text: model.status == 'ACTIVE'
                    ? AppLocalizations.of(context)!.active
                    : AppLocalizations.of(context)!.notActive,
                child: model.status == 'ACTIVE'
                    ? Row(
                        children: [
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.active,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          AppIcons.editCir.svg(),
                        ],
                      )
                    : null,
              ),
              const SizedBox(height: 24),
            ],
            if (isComments) ...[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: context.color.grey.withValues(alpha: .5),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentsView(
                        comments: model.comments ?? [],
                        id: model.id,
                      ),
                    ));
                  },
                  leading: AppIcons.message.svg(color: greyText),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(AppLocalizations.of(context)!.comments),
                      ),
                      if (model.comments != null)
                        SizedBox(
                          width: 72,
                          height: 24,
                          child: Stack(
                            children: [
                              const CircleAvatar(
                                radius: 12,
                                backgroundImage: AssetImage(AppImages.avatar_1),
                              ),
                              const Positioned(
                                left: 16,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundImage:
                                      AssetImage(AppImages.avatar_2),
                                ),
                              ),
                              const Positioned(
                                left: 32,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundImage:
                                      AssetImage(AppImages.avatar_3),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: white,
                                  child: Text(
                                    model.comments!.length.toString(),
                                    style: const TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  trailing: AppIcons.arrowForward.svg(),
                ),
              ),
            ],
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: context.color.grey.withValues(alpha: .5),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 16,
                children: [
                  if (model.fromLocation != null && model.toLocation != null)
                    Row(
                      spacing: 8,
                      children: [
                        AppIcons.columLocation.svg(),
                        Expanded(
                          child: Column(
                            spacing: 8,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (model.fromLocation?.name ??
                                    AppLocalizations.of(context)!.unknown),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: context.color.white,
                                ),
                              ),
                              Text(
                                (model.toLocation?.name ??
                                    AppLocalizations.of(context)!.unknown),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: context.color.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${calculateDistance(
                            model.fromLocation?.lat ?? 0,
                            model.fromLocation?.lng ?? 0,
                            model.toLocation?.lat ?? 0,
                            model.toLocation?.lng ?? 0,
                          ).toInt()} km',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: context.color.darkText,
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      spacing: 8,
                      children: [
                        AppIcons.location.svg(height: 20),
                        if (model.fromLocation != null)
                          Text(
                            (model.fromLocation?.name ??
                                AppLocalizations.of(context)!.unknown),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: context.color.white,
                            ),
                          ),
                        if (model.toLocation != null)
                          Text(
                            (model.toLocation?.name ??
                                AppLocalizations.of(context)!.unknown),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: context.color.white,
                            ),
                          ),
                      ],
                    ),
                  WButton(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LocationInfoView(
                          point1: model.fromLocation,
                          point2: model.toLocation,
                          isFirst: true,
                        ),
                      ));
                    },
                    text: "Karta orqali ko’rish",
                    color: greyBack,
                    textColor: greyText,
                    height: 48,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (model.details?.transportNumber != null) ...[
              Text(
                '${AppLocalizations.of(context)!.transport_number}:',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              WInfoContainer(text: model.details?.transportNumber ?? ""),
              const SizedBox(height: 8),
            ],
            if (model.details?.madeAt != null) ...[
              Text(
                '${AppLocalizations.of(context)!.manufacture_year}:',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              WInfoContainer(text: model.details?.madeAt ?? ""),
              const SizedBox(height: 8),
            ],
            if (model.details?.techPassportSeria != null) ...[
              Text(
                '${AppLocalizations.of(context)!.tech_passport}:',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                spacing: 16,
                children: [
                  WInfoContainer(text: model.details?.techPassportSeria ?? ""),
                  WInfoContainer(text: model.details?.techPassportNum ?? ""),
                ],
              ),
              const SizedBox(height: 8),
            ],
            if (!isMyCar &&
                !isOnlyCar &&
                (model.details?.loadTypeList ?? []).isNotEmpty) ...[
              Text(
                '${AppLocalizations.of(context)!.cargoType}:',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: List.generate(
                  model.details!.loadTypeList!.length,
                  (index) => WInfoContainer(
                    text: MyFunction.getLoadTypeName(index, context),
                  ),
                ),
              ),
            ],
            if (model.details!.kg != null ||
                model.details!.m3 != null ||
                model.details!.litr != null) ...[
              const SizedBox(height: 16),
              Text(
                '${AppLocalizations.of(context)!.loadWeight}:',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  if (model.details!.kg != null)
                    WInfoContainer(text: "${model.details!.kg} kg"),
                  if (model.details!.m3 != null)
                    WInfoContainer(text: "${model.details!.m3} m3"),
                  if (model.details!.litr != null)
                    WInfoContainer(text: "${model.details!.litr} litr"),
                ],
              ),
            ],
            const SizedBox(height: 16),
            if (!isMyCar && !isOnlyCar) ...[
              Text(
                '${AppLocalizations.of(context)!.shipment_date_time}:',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                spacing: 16,
                children: [
                  WInfoContainer(
                    text: MyFunction.formatDate2(
                      DateTime.tryParse(model.shipmentDate ?? "") ??
                          DateTime.now(),
                    ),
                    icon: AppIcons.calendar,
                  ),
                  WInfoContainer(
                    text: MyFunction.formattedTime(
                          DateTime.tryParse(model.details?.fromDate ?? "") ??
                              DateTime.now(),
                        ) +
                        (model.details?.toDate != null
                            ? " - ${MyFunction.formattedTime(DateTime.tryParse(model.details?.toDate ?? "") ?? DateTime.now())}"
                            : ""),
                    icon: AppIcons.clock,
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            if (model.details?.passengerCount != null) ...[
              Text(
                '${AppLocalizations.of(context)!.passengerCount}:',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              WInfoContainer(
                text: "${model.details?.passengerCount ?? "0"} kishi",
              ),
              const SizedBox(height: 16),
            ],
            if (model.details?.transportCount != null) ...[
              Text(
                '${AppLocalizations.of(context)!.transportCount}:',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              WInfoContainer(
                text: "${model.details?.transportCount ?? "0"}",
              ),
              const SizedBox(height: 16),
            ],
            Text(
              '${AppLocalizations.of(context)!.transportType}:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: context.color.grey.withValues(alpha: .5),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      model.transportName ??
                          AppLocalizations.of(context)!.unknown,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  CachedNetworkImage(
                    imageUrl: model.transportIcon ?? "",
                    height: 48,
                    errorWidget: (context, url, error) => const SizedBox(),
                  )
                ],
              ),
            ),
            if (model.payType.isNotEmpty && !isMyCar && !isOnlyCar) ...[
              const SizedBox(height: 16),
              Text(
                '${AppLocalizations.of(context)!.payment_type}:',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              WInfoContainer(
                text: model.payType == 'CASH'
                    ? AppLocalizations.of(context)!.cash
                    : AppLocalizations.of(context)!.card,
                icon: model.payType == 'CASH' ? AppIcons.cash : AppIcons.card,
                iconCollor: false,
              ),
            ],
            if (model.price != null && !isMyCar && !isOnlyCar) ...[
              const SizedBox(height: 16),
              Text(
                '${AppLocalizations.of(context)!.price}:',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              WInfoContainer(
                text: (model.price ?? 0) == 0
                    ? AppLocalizations.of(context)!.price_offer
                    : MyFunction.priceFormat(model.price ?? 0),
              ),
            ],
            if (model.images != null) ...[
              const SizedBox(height: 16),
              Text(
                '${AppLocalizations.of(context)!.cargoImages}:',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children: List.generate(
                  model.images!.length,
                  (index) => GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Stack(
                          children: [
                            Center(
                              child: SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: InteractiveViewer(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://api.carting.uz/uploads/files/${model.images![index]}',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: AppIcons.close.svg(color: white),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      height: (MediaQuery.sizeOf(context).width - 56) / 3,
                      width: (MediaQuery.sizeOf(context).width - 56) / 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            'https://api.carting.uz/uploads/files/${model.images![index]}',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              model.note,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
