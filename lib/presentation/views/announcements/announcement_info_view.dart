import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/assets/images.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/data/models/advertisement_model.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/announcements/offers_view.dart';
import 'package:carting/presentation/views/announcements/widgets/car_offer_bottom_sheet.dart';
import 'package:carting/presentation/views/announcements/widgets/offer_bottom_sheet.dart';
import 'package:carting/presentation/views/common/comments_view.dart';
import 'package:carting/presentation/views/common/location_info_view.dart';
import 'package:carting/presentation/views/profile/edit_ads_view.dart';
import 'package:carting/presentation/widgets/custom_snackbar.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/presentation/widgets/w_info_container.dart';
import 'package:carting/presentation/widgets/w_scale_animation.dart';
import 'package:carting/presentation/widgets/w_shimmer.dart';
import 'package:carting/utils/calculate_distance.dart';
import 'package:carting/utils/caller.dart';
import 'package:carting/utils/log_service.dart';
import 'package:carting/utils/my_function.dart';
import 'package:flex_dropdown/flex_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:share_plus/share_plus.dart';

class AnnouncementInfoView extends StatefulWidget {
  const AnnouncementInfoView({
    super.key,
    required this.model,
    required this.isMe,
    this.isMyCar = false,
    this.isComments = false,
    this.isOnlyCar = false,
    this.isOffers = false,
    this.isNotification = false,
    this.isEdit = false,
    this.isOffersButton = true,
    this.isOffersFinish = false,
    this.offerId,
    this.onEdit,
  });
  final AdvertisementModel model;
  final bool isMe;
  final bool isMyCar;
  final bool isComments;
  final bool isOnlyCar;
  final bool isOffers;
  final bool isOffersButton;
  final bool isOffersFinish;
  final bool isNotification;
  final bool isEdit;
  final int? offerId;
  final VoidCallback? onEdit;

  @override
  State<AnnouncementInfoView> createState() => _AnnouncementInfoViewState();
}

class _AnnouncementInfoViewState extends State<AnnouncementInfoView> {
  final OverlayPortalController _controller = OverlayPortalController();
  @override
  void initState() {
    if (widget.isOffers) {
      context.read<AdvertisementBloc>().add(
        GetOffersEvent(advertisementId: widget.model.id),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Log.wtf(widget.model.images);
    return Scaffold(
      appBar: AppBar(
        title: Text("ID ${widget.model.id}"),
        actions: [
          IconButton(
            onPressed: () async {
              final shareText = widget.model.note;
              final shareUrl = Platform.isAndroid
                  ? "https://play.google.com/store/apps/details?id=uz.realsoft.carting"
                  : "https://apps.apple.com/uz/app/carting/id6742141732";

              await SharePlus.instance.share(
                ShareParams(title: "Carting", text: "$shareText\n\n$shareUrl"),
              );
            },
            icon: AppIcons.share.svg(color: context.color.white),
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
        child: widget.isMe
            ? Row(
                spacing: 16,
                children: [
                  if (widget.isMyCar)
                    Expanded(
                      child: WButton(
                        onTap: () {
                          final bloc = context.read<AdvertisementBloc>();
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: bloc,
                                    child: EditAdsView(model: widget.model),
                                  ),
                                ),
                              )
                              .then((value) {
                                if (value != null) {
                                  bloc.add(GetAdvertisementsMyCarsEvent());
                                }
                              });
                        },
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
                  if (widget.isEdit)
                    Expanded(
                      child: WButton(
                        onTap: () {
                          final bloc = context.read<AdvertisementBloc>();
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: bloc,
                                    child: EditAdsView(model: widget.model),
                                  ),
                                ),
                              )
                              .then((value) {
                                if (value != null) {
                                  if (widget.onEdit != null) {
                                    widget.onEdit!();
                                  }
                                }
                              });
                        },
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
                                      AppLocalizations.of(
                                        context,
                                      )!.confirm_delete,
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
                                            text: AppLocalizations.of(
                                              context,
                                            )!.no,
                                          ),
                                        ),
                                        Expanded(
                                          child:
                                              BlocBuilder<
                                                AdvertisementBloc,
                                                AdvertisementState
                                              >(
                                                bloc: bloc,
                                                builder: (context, state) {
                                                  return WButton(
                                                    onTap: () {
                                                      bloc.add(
                                                        DeleteAdvertisementEvent(
                                                          id: widget.model.id,
                                                          onSucces: () {
                                                            Navigator.of(
                                                                context,
                                                              )
                                                              ..pop()
                                                              ..pop(true);
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    textColor: greyText,
                                                    color: greyBack,
                                                    text: AppLocalizations.of(
                                                      context,
                                                    )!.yes,
                                                  );
                                                },
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(),
                                  ],
                                ),
                              ),
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
                  if (widget.isOffersFinish)
                    WButton(
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
                                    const Text(
                                      "Rostan ham yakunlashni xohlaysizmi?",
                                      style: TextStyle(
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
                                            text: AppLocalizations.of(
                                              context,
                                            )!.no,
                                          ),
                                        ),
                                        Expanded(
                                          child:
                                              BlocBuilder<
                                                AdvertisementBloc,
                                                AdvertisementState
                                              >(
                                                bloc: bloc,
                                                builder: (context, state) {
                                                  return WButton(
                                                    isLoading: state
                                                        .statusCreate
                                                        .isInProgress,
                                                    onTap: () {
                                                      bloc.add(
                                                        FinishOffersEvent(
                                                          id: widget.model.id,
                                                          onSuccess: () {
                                                            Navigator.of(
                                                                context,
                                                              )
                                                              ..pop()
                                                              ..pop(true);
                                                          },
                                                        ),
                                                      );
                                                    },
                                                    textColor: greyText,
                                                    color: greyBack,
                                                    text: AppLocalizations.of(
                                                      context,
                                                    )!.yes,
                                                  );
                                                },
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      text: 'Yakunlash',
                      color: red,
                    ),
                  if (widget.isOffersButton)
                    WButton(
                      onTap: () {
                        final bloc = context.read<AdvertisementBloc>();
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) => widget.isOnlyCar
                              ? CarOfferBottomSheet(
                                  model: widget.model,
                                  bloc: bloc,
                                  isOnlyCars: widget.isOnlyCar,
                                )
                              : OfferBottomSheet(
                                  model: widget.model,
                                  bloc: bloc,
                                  isOnlyCars: widget.isOnlyCar,
                                ),
                        ).then((value) {
                          if (value != null && context.mounted) {
                            CustomSnackbar.show(context, "Taklif yuorildi");
                          }
                        });
                      },
                      color: const Color(0xFFFDB022),
                      child: Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppIcons.messageOffer.svg(),
                          Text(AppLocalizations.of(context)!.sendProposal),
                        ],
                      ),
                    ),
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: WButton(
                          onTap: () async {
                            if (widget.model.createdByTgLink != null) {
                              await Caller.launchTelegram(
                                widget.model.createdByTgLink!,
                              );
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
                            if (widget.model.createdByPhone != null) {
                              await Caller.makePhoneCall(
                                widget.model.createdByPhone!,
                              );
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
            if (widget.isMe) ...[
              RawFlexDropDown(
                controller: _controller,
                menuPosition: MenuPosition.bottomStart,
                dismissOnTapOutside: true,
                buttonBuilder: (context, onTap) => WButton(
                  onTap: onTap,
                  color: widget.model.status == 'ACTIVE'
                      ? green.withValues(alpha: .2)
                      : red.withValues(alpha: .2),
                  textColor: widget.model.status == 'ACTIVE' ? green : red,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  text: widget.model.status == 'ACTIVE'
                      ? AppLocalizations.of(context)!.active
                      : AppLocalizations.of(context)!.notActive,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(switch (widget.model.status) {
                          "ACTIVE" => AppLocalizations.of(context)!.active,
                          "IN_ACTIVE" => AppLocalizations.of(
                            context,
                          )!.notActive,
                          "CLOSED" => AppLocalizations.of(context)!.closed,
                          "IN_PROCESS" => "Jarayonda",
                          String() => widget.model.status,
                        }, textAlign: TextAlign.center),
                      ),
                      AppIcons.arrowBottom.svg(
                        color: widget.model.status == 'ACTIVE' ? green : red,
                      ),
                    ],
                  ),
                ),
                menuBuilder: (context, width) => Container(
                  width: width,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(top: 4),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: [
                      if (widget.isMyCar)
                        WScaleAnimation(
                          onTap: () {
                            widget.model.status = 'IN_ACTIVE';
                            context.read<AdvertisementBloc>().add(
                              UpdateStatusEvent(
                                advertisementId: widget.model.id,
                                status: 'IN_ACTIVE',
                                onSuccess: () {
                                  _controller.hide();
                                  setState(() {});
                                },
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WButton(
                                onTap: () {},
                                height: 40,
                                text: "Band",
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                color: red.withValues(alpha: .1),
                                textColor: red,
                              ),
                              widget.model.status != 'ACTIVE'
                                  ? AppIcons.checkboxRadio.svg()
                                  : AppIcons.checkboxRadioDis.svg(),
                            ],
                          ),
                        ),
                      WScaleAnimation(
                        onTap: () {
                          widget.model.status = 'ACTIVE';
                          context.read<AdvertisementBloc>().add(
                            UpdateStatusEvent(
                              advertisementId: widget.model.id,
                              status: 'ACTIVE',
                              onSuccess: () {
                                _controller.hide();
                                setState(() {});
                              },
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WButton(
                              onTap: () {},
                              height: 40,
                              text: "Faol",
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              color: green.withValues(alpha: .1),
                              textColor: green,
                            ),
                            widget.model.status == 'ACTIVE'
                                ? AppIcons.checkboxRadio.svg()
                                : AppIcons.checkboxRadioDis.svg(),
                          ],
                        ),
                      ),
                      if (!widget.isMyCar)
                        WScaleAnimation(
                          onTap: () {
                            widget.model.status = 'CLOSED';
                            context.read<AdvertisementBloc>().add(
                              UpdateStatusEvent(
                                advertisementId: widget.model.id,
                                status: 'CLOSED',
                                onSuccess: () {
                                  _controller.hide();
                                  setState(() {});
                                },
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WButton(
                                onTap: () {},
                                height: 40,
                                text: "Tugallangan",
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                color: red.withValues(alpha: .1),
                                textColor: red,
                              ),
                              widget.model.status == 'CLOSED'
                                  ? AppIcons.checkboxRadio.svg()
                                  : AppIcons.checkboxRadioDis.svg(),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (widget.isOffers)
                BlocBuilder<AdvertisementBloc, AdvertisementState>(
                  builder: (context, state) {
                    if (state.statusOffers.isInProgress) {
                      return const WShimmer(height: 56, width: double.infinity);
                    }
                    if (state.offersList.isEmpty) {
                      return const SizedBox();
                    }
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: context.color.grey.withValues(alpha: .5),
                      ),
                      child: ListTile(
                        onTap: () {
                          final bloc = context.read<AdvertisementBloc>();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: bloc,
                                child: OffersView(
                                  offersList: state.offersList,
                                  advertisementId: widget.model.id,
                                ),
                              ),
                            ),
                          );
                        },
                        leading: AppIcons.layer.svg(height: 24, width: 24),
                        title: Row(
                          children: [
                            const Expanded(child: Text('Takliflar')),
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: context.color.contColor,
                              child: Text(
                                state.offersList.length > 99
                                    ? "+${state.offersList.length}"
                                    : state.offersList.length.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: context.color.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: AppIcons.arrowForward.svg(),
                      ),
                    );
                  },
                ),
            ],
            if (widget.isComments) ...[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: context.color.grey.withValues(alpha: .5),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CommentsView(
                          comments: widget.model.comments ?? [],
                          id: widget.model.id,
                        ),
                      ),
                    );
                  },
                  leading: AppIcons.message.svg(color: context.color.iron),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(AppLocalizations.of(context)!.comments),
                      ),
                      if (widget.model.comments != null)
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
                                  backgroundImage: AssetImage(
                                    AppImages.avatar_2,
                                  ),
                                ),
                              ),
                              const Positioned(
                                left: 32,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundImage: AssetImage(
                                    AppImages.avatar_3,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: white,
                                  child: Text(
                                    widget.model.comments!.length.toString(),
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
                  if (widget.model.fromLocation != null &&
                      widget.model.toLocation != null)
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
                                (widget.model.fromLocation?.name ??
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
                                (widget.model.toLocation?.name ??
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
                          '${calculateDistance(widget.model.fromLocation?.lat ?? 0, widget.model.fromLocation?.lng ?? 0, widget.model.toLocation?.lat ?? 0, widget.model.toLocation?.lng ?? 0).toInt()} km',
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
                        if (widget.model.fromLocation != null)
                          Expanded(
                            child: Text(
                              (widget.model.fromLocation?.name ??
                                  AppLocalizations.of(context)!.unknown),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: context.color.white,
                              ),
                            ),
                          ),
                        if (widget.model.toLocation != null)
                          Expanded(
                            child: Text(
                              (widget.model.toLocation?.name ??
                                  AppLocalizations.of(context)!.unknown),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: context.color.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  WButton(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LocationInfoView(
                            point1: widget.model.fromLocation,
                            point2: widget.model.toLocation,
                            isFirst: true,
                          ),
                        ),
                      );
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
            if (widget.model.details?.transportNumber != null) ...[
              Text(
                '${AppLocalizations.of(context)!.transport_number}:',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              WInfoContainer(text: widget.model.details?.transportNumber ?? ""),
              const SizedBox(height: 8),
            ],
            if (widget.model.details?.madeAt != null) ...[
              Text(
                '${AppLocalizations.of(context)!.manufacture_year}:',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              WInfoContainer(text: widget.model.details?.madeAt ?? ""),
              const SizedBox(height: 8),
            ],
            if (widget.model.details?.techPassportSeria != null) ...[
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
                  WInfoContainer(
                    text: widget.model.details?.techPassportSeria ?? "",
                  ),
                  WInfoContainer(
                    text: widget.model.details?.techPassportNum ?? "",
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            if (!widget.isMyCar &&
                !widget.isOnlyCar &&
                (widget.model.details?.loadTypeList ?? []).isNotEmpty) ...[
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
                  widget.model.details!.loadTypeList!.length,
                  (index) => WInfoContainer(
                    text: MyFunction.getLoadTypeName(
                      widget.model.details!.loadTypeList![index],
                      context,
                    ),
                  ),
                ),
              ),
            ],
            if (widget.model.details!.kg != null ||
                widget.model.details!.m3 != null ||
                widget.model.details!.litr != null) ...[
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
                  if (widget.model.details!.kg != null)
                    WInfoContainer(text: "${widget.model.details!.kg} kg"),
                  if (widget.model.details!.m3 != null)
                    WInfoContainer(text: "${widget.model.details!.m3} m3"),
                  if (widget.model.details!.litr != null)
                    WInfoContainer(text: "${widget.model.details!.litr} litr"),
                ],
              ),
            ],
            const SizedBox(height: 16),
            if (!widget.isMyCar && !widget.isOnlyCar) ...[
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
                      DateTime.tryParse(widget.model.shipmentDate ?? "") ??
                          DateTime.now(),
                      context,
                    ),
                    icon: AppIcons.calendar,
                  ),
                  WInfoContainer(
                    text:
                        MyFunction.formattedTime(
                          DateTime.tryParse(
                                widget.model.details?.fromDate ?? "",
                              ) ??
                              DateTime.now(),
                        ) +
                        (widget.model.details?.toDate != null
                            ? " - ${MyFunction.formattedTime(DateTime.tryParse(widget.model.details?.toDate ?? "") ?? DateTime.now())}"
                            : ""),
                    icon: AppIcons.clock,
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            if (widget.model.details?.passengerCount != null) ...[
              Text(
                '${AppLocalizations.of(context)!.passengerCount}:',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              WInfoContainer(
                text: "${widget.model.details?.passengerCount ?? "0"} kishi",
              ),
              const SizedBox(height: 16),
            ],
            if (widget.model.details?.transportCount != null) ...[
              Text(
                '${AppLocalizations.of(context)!.transportCount}:',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              WInfoContainer(
                text: "${widget.model.details?.transportCount ?? "0"}",
              ),
              const SizedBox(height: 16),
            ],
            if (widget.model.transportName != null) ...[
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
                        widget.model.transportName ??
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
                      imageUrl: widget.model.transportIcon ?? "",
                      height: 48,
                      errorWidget: (context, url, error) => const SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
            if (widget.model.payType.isNotEmpty &&
                !widget.isMyCar &&
                !widget.isOnlyCar) ...[
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
                text: widget.model.payType == 'CASH'
                    ? AppLocalizations.of(context)!.cash
                    : AppLocalizations.of(context)!.card,
                icon: widget.model.payType == 'CASH'
                    ? AppIcons.cash
                    : AppIcons.card,
                iconCollor: false,
              ),
            ],
            if (widget.model.price != null &&
                !widget.isMyCar &&
                !widget.isOnlyCar) ...[
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
                text: (widget.model.price ?? 0) == 0
                    ? AppLocalizations.of(context)!.price_offer
                    : MyFunction.priceFormat(widget.model.price ?? 0),
              ),
            ],
            if (widget.model.images != null) ...[
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
                  widget.model.images!.length,
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
                                        'https://api.carting.uz/uploads/files/${widget.model.images![index]}',
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
                            'https://api.carting.uz/uploads/files/${widget.model.images![index]}',
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
              widget.model.note,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
