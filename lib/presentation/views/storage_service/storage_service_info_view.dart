import 'package:cached_network_image/cached_network_image.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/assets/images.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/data/models/advertisement_model.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/common/comments_view.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/utils/my_function.dart';
import 'package:flutter/material.dart';

class StorageServiceInfoView extends StatefulWidget {
  const StorageServiceInfoView({super.key, required this.model});
  final AdvertisementModel model;

  @override
  State<StorageServiceInfoView> createState() => _StorageServiceInfoViewState();
}

class _StorageServiceInfoViewState extends State<StorageServiceInfoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.backGroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: white,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
            ),
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.model.images != null
                  ? PageView.builder(
                      itemCount: widget.model.images?.length,
                      itemBuilder: (context, index) => CachedNetworkImage(
                        imageUrl:
                            'https://api.carting.uz/uploads/files/${widget.model.images![index]}',
                        fit: BoxFit.cover,
                      ),
                    )
                  : AppImages.ombor.imgAsset(
                      fit: BoxFit.cover,
                    ),
            ),
          )
        ],
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Ombor",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
                      AppIcons.star.svg(),
                      RichText(
                        text: TextSpan(
                          text:
                              "${MyFunction.calculateAverageRating(widget.model.comments ?? [])}, ",
                          style: TextStyle(
                            fontSize: 14,
                            color: context.color.white,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  "${widget.model.comments?.length ?? 0} ta izoh",
                              style: TextStyle(
                                fontSize: 12,
                                color: context.color.darkText,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Text(
                "${MyFunction.priceFormat(widget.model.price ?? 0)} UZS",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.model.note,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: context.color.darkText,
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  text: "Maydon:  ",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: context.color.darkText,
                  ),
                  children: [
                    TextSpan(
                      text:
                          "${widget.model.details?.area ?? AppLocalizations.of(context)!.unknown} m2",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: context.color.white,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: context.color.contColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  onTap: () {},
                  leading: AppIcons.location.svg(
                    height: 24,
                    width: 24,
                  ),
                  title: Text(
                    widget.model.toLocation?.name ??
                        AppLocalizations.of(context)!.unknown,
                    maxLines: 1,
                  ),
                  trailing: AppIcons.arrowCircle.svg(),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: context.color.contColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentsView(
                        comments: widget.model.comments ?? [],
                        id: widget.model.id,
                      ),
                    ));
                  },
                  leading: AppIcons.message.svg(color: context.color.iron),
                  title: Text(AppLocalizations.of(context)!.comments),
                  trailing: AppIcons.arrowCircle.svg(),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: WButton(
                      onTap: () {},
                      isDisabled: true,
                      disabledColor: const Color(0xFFD4D5D6),
                      text: AppLocalizations.of(context)!.queueRegistration,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: WButton(
                      onTap: () {},
                      text: AppLocalizations.of(context)!.call,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              WButton(
                onTap: () {},
                color: blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppIcons.telegram.svg(),
                    const SizedBox(width: 12),
                    Text(AppLocalizations.of(context)!.contactViaTelegram)
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
