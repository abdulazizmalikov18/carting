import 'package:cached_network_image/cached_network_image.dart';
import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/data/models/offers_model.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/utils/my_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OffersView extends StatefulWidget {
  const OffersView({
    super.key,
    required this.offersList,
    required this.advertisementId,
  });
  final List<OffersModel> offersList;
  final int advertisementId;

  @override
  State<OffersView> createState() => _OffersViewState();
}

class _OffersViewState extends State<OffersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Takliflar')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: CachedNetworkImageProvider(
                widget.offersList[index].offererAvatar,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.offersList[index].offererName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    MyFunction.dateFormatden(
                      widget.offersList[index].offeredTime,
                      context,
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${MyFunction.priceFormat(widget.offersList[index].offeredSum)} UZS',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            WButton(
              onTap: () {
                final bloc = context.read<AdvertisementBloc>();
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => AcceptRejectModal(
                    bloc: bloc,
                    isAccept: true,
                    offerId: widget.offersList[index].id,
                    advertisementId: widget.advertisementId,
                  ),
                );
              },
              height: 48,
              width: 48,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: AppIcons.accept.svg(),
            ),
            const SizedBox(width: 8),
            WButton(
              onTap: () {
                final bloc = context.read<AdvertisementBloc>();
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => AcceptRejectModal(
                    bloc: bloc,
                    isAccept: false,
                    offerId: widget.offersList[index].id,
                    advertisementId: widget.advertisementId,
                  ),
                );
              },
              height: 48,
              width: 48,
              color: red.withValues(alpha: 0.1),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: AppIcons.close.svg(color: red),
            )
          ],
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemCount: widget.offersList.length,
      ),
    );
  }
}

class AcceptRejectModal extends StatelessWidget {
  const AcceptRejectModal({
    super.key,
    required this.bloc,
    required this.isAccept,
    required this.offerId,
    required this.advertisementId,
  });

  final AdvertisementBloc bloc;
  final bool isAccept;
  final int offerId;
  final int advertisementId;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                isAccept
                    ? "Haqiqatda qabul qilmoqchimisiz?"
                    : "Haqiqatda bekor qilmoqchimisiz?",
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
                      text: AppLocalizations.of(context)!.no,
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<AdvertisementBloc, AdvertisementState>(
                      bloc: bloc,
                      builder: (context, state) {
                        return WButton(
                          onTap: () {
                            bloc.add(ReplyOffersEvent(
                              advertisementId: advertisementId,
                              offerId: offerId,
                              status: isAccept,
                              onSuccess: () {
                                Navigator.of(context)
                                  ..pop()
                                  ..pop()
                                  ..pop(true);
                              },
                            ));
                          },
                          textColor: greyText,
                          color: greyBack,
                          text: AppLocalizations.of(context)!.yes,
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
    );
  }
}
