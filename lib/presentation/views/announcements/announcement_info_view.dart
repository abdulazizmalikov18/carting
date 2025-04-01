import 'package:cached_network_image/cached_network_image.dart';
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

class AnnouncementInfoView extends StatelessWidget {
  const AnnouncementInfoView({
    super.key,
    required this.model,
    required this.isMe,
    this.isComments = false,
  });
  final AdvertisementModel model;
  final bool isMe;
  final bool isComments;

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
        child: Column(
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
                        await Caller.launchTelegram(model.createdByTgLink!);
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
                        const Text("Bog‘lanish"),
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
                        const SizedBox(
                          width: 72,
                          height: 24,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundImage: AssetImage(AppImages.avatar_1),
                              ),
                              Positioned(
                                left: 16,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundImage:
                                      AssetImage(AppImages.avatar_2),
                                ),
                              ),
                              Positioned(
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
                                    "+86",
                                    style: TextStyle(
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
            Row(
              spacing: 12,
              children: [
                // if (model.details?.loadWeight != null)
                //   Expanded(
                //     child: Container(
                //       padding: const EdgeInsets.symmetric(
                //         vertical: 12,
                //         horizontal: 16,
                //       ),
                //       decoration: BoxDecoration(
                //         color: context.color.contColor,
                //         borderRadius: BorderRadius.circular(24),
                //       ),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             AppLocalizations.of(context)!.loadWeight,
                //             style: TextStyle(
                //               fontSize: 12,
                //               fontWeight: FontWeight.w400,
                //               color: context.color.darkText,
                //             ),
                //           ),
                //           Text(
                //             "${model.details?.loadWeight?.amount ?? AppLocalizations.of(context)!.unknown} ${model.details?.loadWeight?.name ?? ""}",
                //             style: const TextStyle(
                //               fontSize: 16,
                //               fontWeight: FontWeight.w400,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),

                if (model.details?.passengerCount != null)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      margin: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: context.color.grey.withValues(alpha: .5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.passengerCount,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: context.color.darkText,
                            ),
                          ),
                          Text(
                            "${model.details?.passengerCount ?? "0"} kishi",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (model.details?.transportCount != null)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      margin: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: context.color.grey.withValues(alpha: .5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.transportCount,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: context.color.darkText,
                            ),
                          ),
                          Text(
                            "${model.details?.transportCount ?? "0"}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: dark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Yuk turi:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            const Wrap(
              spacing: 16,
              children: [
                WInfoContainer(text: "Qurilish materiallari"),
                WInfoContainer(text: "Maishiy texnika"),
              ],
            ),
            if (model.details!.kg != null ||
                model.details!.m3 != null ||
                model.details!.kg != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Yuk vazni:',
                style: TextStyle(
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
                  if (model.details!.kg != null)
                    WInfoContainer(text: "${model.details!.kg} litr"),
                ],
              ),
            ],
            const SizedBox(height: 16),
            const Text(
              'Jo‘natish sanasi va vaqti:',
              style: TextStyle(
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
                    DateTime.tryParse(model.shipmentDate ?? "") ??
                        DateTime.now(),
                  ),
                  icon: AppIcons.clock,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Transport turi:',
              style: TextStyle(
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
                    imageUrl: model.transportIcon!,
                    height: 48,
                  )
                ],
              ),
            ),
            if (model.payType.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'To‘lov turi:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              WInfoContainer(
                text: model.payType == 'CASH' ? "Naqd" : 'Karta',
                icon: model.payType == 'CASH' ? AppIcons.cash : AppIcons.card,
                iconCollor: false,
              ),
            ],
            if (model.price != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Narx:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              WInfoContainer(
                text: (model.price ?? 0) == 0
                    ? "Narx taklifi"
                    : MyFunction.priceFormat(model.price ?? 0),
              ),
            ],
            if (model.images != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Yuk rasmlari:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children: List.generate(
                  model.images!.length,
                  (index) => Container(
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
            ],
            const SizedBox(height: 16),
            const Text(
              'Maishiy texnika. Ehtiyotkorlik bilan tashish kerak. Yuklash va tushirishda haydovchi yordam berishi lozim.',
              style: TextStyle(
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
