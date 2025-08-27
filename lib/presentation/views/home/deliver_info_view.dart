import 'package:cached_network_image/cached_network_image.dart';
import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/common/location_info_view.dart';
import 'package:carting/presentation/widgets/w_info_container.dart';
import 'package:carting/presentation/widgets/w_scale_animation.dart';
import 'package:flutter/material.dart';

import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/data/models/advertisement_model.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class DeliverInfoView extends StatelessWidget {
  const DeliverInfoView({super.key, required this.model, this.isMe = true});
  final AdvertisementModel model;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.cargoTransport)),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              Text(
                'E’lon vaqti: ${model.shipmentDate ?? AppLocalizations.of(context)!.unknown}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: context.color.darkText,
                ),
              ),
              if (model.status == 'ACTIVE' && isMe)
                BlocBuilder<AdvertisementBloc, AdvertisementState>(
                  builder: (context, state) {
                    return WButton(
                      onTap: () {
                        final bloc = context.read<AdvertisementBloc>();
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          useRootNavigator: true,
                          builder: (context) => Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 4,
                                width: 64,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: const Color(0xFFB7BFC6),
                                ),
                                margin: const EdgeInsets.all(12),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 24,
                                  horizontal: 16,
                                ),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: context.color.contColor,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.cancelAnnouncement,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: context.color.darkText,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: WButton(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            text: AppLocalizations.of(
                                              context,
                                            )!.no,
                                            textColor: darkText,
                                            color: const Color(0xFFF3F3F3),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: WButton(
                                            onTap: () {
                                              Navigator.pop(context);
                                              bloc.add(
                                                DeactivetEvent(id: model.id),
                                              );
                                              Navigator.pop(context);
                                            },
                                            text: AppLocalizations.of(
                                              context,
                                            )!.yes,
                                            textColor: darkText,
                                            color: const Color(0xFFF3F3F3),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      text: AppLocalizations.of(context)!.deactivate,
                      textColor: red,
                      isLoading: state.statusCreate.isInProgress,
                      color: red.withValues(alpha: .2),
                    );
                  },
                ),
            ],
          ),
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
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.color.contColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  if (model.fromLocation != null)
                    ListTile(
                      title: Text(
                        AppLocalizations.of(context)!.from,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: context.color.darkText,
                        ),
                      ),
                      subtitle: Text(
                        model.fromLocation?.name ??
                            AppLocalizations.of(context)!.unknown,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      trailing: WScaleAnimation(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LocationInfoView(
                                point1: model.fromLocation,
                                point2: model.toLocation,
                                isFirst: true,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: green,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: AppIcons.location.svg(
                            height: 24,
                            width: 24,
                            color: white,
                          ),
                        ),
                      ),
                    ),
                  if (model.fromLocation != null && model.toLocation != null)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(height: 1),
                    ),
                  if (model.toLocation != null)
                    ListTile(
                      title: Text(
                        AppLocalizations.of(context)!.to,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: context.color.darkText,
                        ),
                      ),
                      subtitle: Text(
                        model.toLocation?.name ??
                            AppLocalizations.of(context)!.unknown,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      trailing: WScaleAnimation(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LocationInfoView(
                                point1: model.fromLocation,
                                point2: model.toLocation,
                                isFirst: false,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: green,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: AppIcons.location.svg(
                            height: 24,
                            width: 24,
                            color: white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              spacing: 12,
              children: [
                if (model.details?.loadWeight != null)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: context.color.contColor,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.loadWeight,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: context.color.darkText,
                            ),
                          ),
                          Text(
                            "${model.details?.loadWeight?.amount ?? AppLocalizations.of(context)!.unknown} ${model.details?.loadWeight?.name ?? ""}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (model.details?.passengerCount != null)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: context.color.contColor,
                        borderRadius: BorderRadius.circular(24),
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
                      decoration: BoxDecoration(
                        color: context.color.contColor,
                        borderRadius: BorderRadius.circular(24),
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
                // Expanded(
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(
                //       vertical: 12,
                //       horizontal: 16,
                //     ),
                //     decoration: BoxDecoration(
                //       color: context.color.contColor,
                //       borderRadius: BorderRadius.circular(24),
                //     ),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           AppLocalizations.of(context)!.departureDate,
                //           style: TextStyle(
                //             fontSize: 12,
                //             fontWeight: FontWeight.w400,
                //             color: context.color.darkText,
                //           ),
                //         ),
                //         Row(
                //           children: [
                //             AppIcons.calendar.svg(),
                //             const SizedBox(width: 4),
                //             Text(
                //               model.shipmentDate ??
                //                   AppLocalizations.of(context)!.unknown,
                //               style: const TextStyle(
                //                 fontSize: 16,
                //                 fontWeight: FontWeight.w400,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),

            // const SizedBox(height: 8),
            // DecoratedBox(
            //   decoration: BoxDecoration(
            //     color: context.color.contColor,
            //     borderRadius: BorderRadius.circular(24),
            //   ),
            //   child: ListTile(
            //     title: Text(AppLocalizations.of(context)!.additionalInfo),
            //     minVerticalPadding: 0,
            //     titleTextStyle: TextStyle(
            //       fontSize: 12,
            //       fontWeight: FontWeight.w400,
            //       color: context.color.darkText,
            //     ),
            //     subtitleTextStyle: const TextStyle(
            //       fontSize: 16,
            //       fontWeight: FontWeight.w400,
            //       color: dark,
            //     ),
            //     subtitle: Text(
            //       AppLocalizations.of(context)!.cargoType,
            //       maxLines: 1,
            //       overflow: TextOverflow.ellipsis,
            //     ),
            //     trailing: AppIcons.arrowForward.svg(),
            //   ),
            // ),

            // const SizedBox(height: 8),
            // DecoratedBox(
            //   decoration: BoxDecoration(
            //     color: context.color.contColor,
            //     borderRadius: BorderRadius.circular(24),
            //   ),
            //   child: ListTile(
            //     title: Text(AppLocalizations.of(context)!.transportType),
            //     subtitle: Text(model.transportName ??
            //         AppLocalizations.of(context)!.unknown),
            //     minVerticalPadding: 0,
            //     titleTextStyle: TextStyle(
            //       fontSize: 12,
            //       fontWeight: FontWeight.w400,
            //       color: context.color.darkText,
            //     ),
            //     subtitleTextStyle: const TextStyle(
            //       fontSize: 16,
            //       fontWeight: FontWeight.w400,
            //       color: dark,
            //     ),
            //     trailing: model.transportIcon != null
            //         ? CachedNetworkImage(imageUrl: model.transportIcon!)
            //         : null,
            //   ),
            // ),
            const SizedBox(height: 16),
            Text(
              '${AppLocalizations.of(context)!.cargoType}:',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 8),
            const Wrap(
              spacing: 16,
              children: [
                WInfoContainer(text: "Qurilish materiallari"),
                WInfoContainer(text: "Maishiy texnika"),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${AppLocalizations.of(context)!.loadWeight}:',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 8),
            const Row(
              spacing: 16,
              children: [
                WInfoContainer(text: "160 kg"),
                WInfoContainer(text: "45 m3"),
                WInfoContainer(text: "560 litr"),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${AppLocalizations.of(context)!.shipment_date_time}:',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 8),
            const Row(
              spacing: 16,
              children: [
                WInfoContainer(text: "Ertaga 21 mart", icon: AppIcons.calendar),
                WInfoContainer(text: "09:00 - 17:00", icon: AppIcons.clock),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${AppLocalizations.of(context)!.transportType}:',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: context.color.grey.withValues(alpha: .5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${AppLocalizations.of(context)!.payment_type}:',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 8),
            WInfoContainer(
              text: AppLocalizations.of(context)!.cash,
              icon: AppIcons.cash,
              iconCollor: false,
            ),
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
