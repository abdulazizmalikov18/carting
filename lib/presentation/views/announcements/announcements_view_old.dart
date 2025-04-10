// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carting/app/auth/auth_bloc.dart';
// import 'package:carting/assets/colors/colors.dart';
// import 'package:carting/data/models/advertisement_model.dart';
// import 'package:carting/infrastructure/core/context_extension.dart';
// import 'package:carting/l10n/localizations.dart';
// import 'package:carting/presentation/routes/route_name.dart';
// import 'package:carting/presentation/views/announcements/create_info_view.dart';
// import 'package:carting/presentation/widgets/custom_snackbar.dart';
// import 'package:carting/utils/caller.dart';
// import 'package:carting/utils/enum_filtr.dart';
// import 'package:carting/utils/my_function.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:formz/formz.dart';

// import 'package:carting/app/advertisement/advertisement_bloc.dart';
// import 'package:carting/assets/assets/icons.dart';
// import 'package:carting/presentation/views/announcements/announcements_type_view.dart';
// import 'package:carting/presentation/views/announcements/widgets/announcements_iteam.dart';
// import 'package:carting/presentation/views/common/filter_view.dart';
// import 'package:carting/presentation/views/home/deliver_info_view.dart';
// import 'package:carting/presentation/widgets/w_button.dart';
// import 'package:carting/presentation/widgets/w_shimmer.dart';
// import 'package:carting/presentation/widgets/w_tabbar.dart';
// import 'package:go_router/go_router.dart';

// class AnnouncementsViewOld extends StatefulWidget {
//   const AnnouncementsViewOld({super.key});

//   @override
//   State<AnnouncementsViewOld> createState() => _AnnouncementsViewOldState();
// }

// class _AnnouncementsViewOldState extends State<AnnouncementsViewOld>
//     with SingleTickerProviderStateMixin {
//   List<bool> active = [true, true, true, true, true];
//   String selectedUnit = 'Barchasi';
//   String selectedUnit2 = 'Barchasi';

//   late TabController _tabController;

//   @override
//   void initState() {
//     context.read<AdvertisementBloc>().add(GetAdvertisementsEvent());
//     context.read<AdvertisementBloc>().add(GetAdvertisementsProvideEvent());
//     context.read<AdvertisementBloc>().add(GetAdvertisementsReceiveEvent());
//     super.initState();
//     _tabController = TabController(
//       vsync: this,
//       length: 3,
//       initialIndex: context.read<AdvertisementBloc>().state.tabIndex,
//     );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: false,
//         title: const Text(
//           'E’lon izlash',
//           style: TextStyle(
//             fontSize: 28,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
//                 builder: (context) => FilterView(
//                   filterType: FilterType.services,
//                   list: active,
//                 ),
//               ));
//             },
//             icon: Row(
//               spacing: 8,
//               children: [
//                 AppIcons.filter.svg(color: context.color.iron),
//                 const Text(
//                   'Filter',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 )
//               ],
//             ),
//           ),
//           const SizedBox(width: 8),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size(double.infinity, 24),
//           child: Container(
//             padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//             alignment: Alignment.centerLeft,
//             child: BlocSelector<AdvertisementBloc, AdvertisementState, int>(
//               selector: (state) => state.advertisement.length,
//               builder: (context, state) => Text(
//                 'E’lonlar soni: $state ta',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   color: context.color.darkText,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: BlocBuilder<AdvertisementBloc, AdvertisementState>(
//         builder: (context, state) {
//           if (state.status.isInProgress) {
//             return ListView.separated(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
//               itemBuilder: (context, index) => const WShimmer(
//                 height: 152,
//                 width: double.infinity,
//               ),
//               separatorBuilder: (context, index) => const SizedBox(height: 16),
//               itemCount: 12,
//             );
//           }
//           if (state.advertisement.isEmpty) {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 AppIcons.emptyFile.svg(),
//                 const SizedBox(height: 16),
//                 WButton(
//                   margin: const EdgeInsets.all(16),
//                   onTap: () {
//                     context
//                         .read<AdvertisementBloc>()
//                         .add(GetAdvertisementsEvent());
//                   },
//                   text: AppLocalizations.of(context)!.refresh,
//                 ),
//                 const SizedBox(height: 100),
//               ],
//             );
//           }
//           return RefreshIndicator.adaptive(
//             onRefresh: () async {
//               context.read<AdvertisementBloc>().add(GetAdvertisementsEvent());
//               Future.delayed(Duration.zero);
//             },
//             child: ListView.separated(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
//               itemBuilder: (context, index) => GestureDetector(
//                 onTap: () {
//                   final bloc = context.read<AdvertisementBloc>();
//                   Navigator.of(context, rootNavigator: true)
//                       .push(MaterialPageRoute(
//                     builder: (context) => BlocProvider.value(
//                       value: bloc,
//                       child: DeliverInfoView(
//                         model: state.advertisement[index],
//                         isMe: false,
//                       ),
//                     ),
//                   ));
//                 },
//                 child: AnnouncementsIteamNew(model: state.advertisement[index]),
//               ),
//               separatorBuilder: (context, index) => const SizedBox(height: 16),
//               itemCount: state.advertisement.length,
//             ),
//           );
//         },
//       ),
//     );

//     // return Scaffold(
//     //   appBar: AppBar(
//     //     leading: IconButton(
//     //       onPressed: () {
//     //         Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
//     //           builder: (context) => FilterView(
//     //             filterType: FilterType.services,
//     //             list: active,
//     //           ),
//     //         ));
//     //       },
//     //       icon: AppIcons.filter.svg(color: context.color.iron),
//     //     ),
//     //     title: Text(AppLocalizations.of(context)!.announcements),
//     //     // bottom: PreferredSize(
//     //     //   preferredSize: const Size(double.infinity, 72),
//     //     //   child: Padding(
//     //     //     padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
//     //     //     child: CustomTextField(
//     //     //       prefixIcon: AppIcons.searchNormal.svg(color: context.color.iron),
//     //     //       hintText: AppLocalizations.of(context)!.searchAnnouncement,
//     //     //     ),
//     //     //   ),
//     //     // ),
//     //     actions: [
//     //       BlocSelector<AdvertisementBloc, AdvertisementState, int>(
//     //         selector: (state) => state.tabIndex,
//     //         builder: (context, state) {
//     //           _tabController.animateTo(state);
//     //           return AnimatedCrossFade(
//     //             firstChild: WButton(
//     //               onTap: () {
//     //                 if (state == 2) {
//     //                   MyFunction.authChek(
//     //                     context: context,
//     //                     onTap: () {
//     //                       final bloc = context.read<AdvertisementBloc>();
//     //                       Navigator.of(context, rootNavigator: true)
//     //                           .push(MaterialPageRoute(
//     //                         builder: (context) => AnnouncementsTypeView(
//     //                           bloc: bloc,
//     //                         ),
//     //                       ));
//     //                     },
//     //                     isFull: true,
//     //                   );
//     //                 } else if (state == 1) {
//     //                   context.go(AppRouteName.home);
//     //                 }
//     //               },
//     //               height: 40,
//     //               width: 40,
//     //               borderRadius: 12,
//     //               child: AppIcons.addCircle.svg(),
//     //             ),
//     //             secondChild: const SizedBox(),
//     //             alignment: Alignment.center,
//     //             crossFadeState: state == 0
//     //                 ? CrossFadeState.showSecond
//     //                 : CrossFadeState.showFirst,
//     //             duration: const Duration(milliseconds: 200),
//     //             reverseDuration: const Duration(milliseconds: 200),
//     //           );
//     //         },
//     //       ),
//     //       const SizedBox(width: 12),
//     //     ],
//     //   ),
//     //   body: NestedScrollView(
//     //     headerSliverBuilder: (context, innerBoxIsScrolled) => [
//     //       SliverToBoxAdapter(
//     //         child: Padding(
//     //           padding: const EdgeInsets.symmetric(horizontal: 16),
//     //           child: Column(
//     //             children: [
//     //               WTabBar(
//     //                 isScrollable: true,
//     //                 tabController: _tabController,
//     //                 onTap: (p0) {
//     //                   context
//     //                       .read<AdvertisementBloc>()
//     //                       .add(TabIndexEvent(index: p0));
//     //                 },
//     //                 tabs: [
//     //                   Text(AppLocalizations.of(context)!.all),
//     //                   Text(AppLocalizations.of(context)!.myOrders),
//     //                   Text(AppLocalizations.of(context)!.myServices),
//     //                 ],
//     //               ),
//     //             ],
//     //           ),
//     //         ),
//     //       ),
//     //     ],
//     //     body: BlocBuilder<AuthBloc, AuthState>(
//     //       builder: (context, state) {
//     //         if (state.status == AuthenticationStatus.unauthenticated) {
//     //           return Padding(
//     //             padding: const EdgeInsets.all(16),
//     //             child: Column(
//     //               spacing: 16,
//     //               mainAxisAlignment: MainAxisAlignment.center,
//     //               children: [
//     //                 AppIcons.emptyFile.svg(),
//     //                 Text(AppLocalizations.of(context)!.register),
//     //                 WButton(
//     //                   onTap: () {
//     //                     context.pushReplacement(AppRouteName.auth);
//     //                   },
//     //                   text: AppLocalizations.of(context)!.enter,
//     //                 ),
//     //                 const SizedBox(height: 60)
//     //               ],
//     //             ),
//     //           );
//     //         }
//     //         return TabBarView(
//     //           controller: _tabController,
//     //           children: [
//     //             BlocBuilder<AdvertisementBloc, AdvertisementState>(
//     //               builder: (context, state) {
//     //                 if (state.status.isInProgress) {
//     //                   return ListView.separated(
//     //                     padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
//     //                     itemBuilder: (context, index) => const WShimmer(
//     //                       height: 152,
//     //                       width: double.infinity,
//     //                     ),
//     //                     separatorBuilder: (context, index) =>
//     //                         const SizedBox(height: 16),
//     //                     itemCount: 12,
//     //                   );
//     //                 }
//     //                 if (state.advertisement.isEmpty) {
//     //                   return Column(
//     //                     mainAxisAlignment: MainAxisAlignment.center,
//     //                     crossAxisAlignment: CrossAxisAlignment.center,
//     //                     children: [
//     //                       AppIcons.emptyFile.svg(),
//     //                       const SizedBox(height: 16),
//     //                       WButton(
//     //                         margin: const EdgeInsets.all(16),
//     //                         onTap: () {
//     //                           context
//     //                               .read<AdvertisementBloc>()
//     //                               .add(GetAdvertisementsEvent());
//     //                         },
//     //                         text: AppLocalizations.of(context)!.refresh,
//     //                       ),
//     //                       const SizedBox(height: 100),
//     //                     ],
//     //                   );
//     //                 }
//     //                 return RefreshIndicator.adaptive(
//     //                   onRefresh: () async {
//     //                     context
//     //                         .read<AdvertisementBloc>()
//     //                         .add(GetAdvertisementsEvent());
//     //                     Future.delayed(Duration.zero);
//     //                   },
//     //                   child: ListView.separated(
//     //                     padding: const EdgeInsets.all(16).copyWith(bottom: 100),
//     //                     itemBuilder: (context, index) => GestureDetector(
//     //                       onTap: () {
//     //                         final bloc = context.read<AdvertisementBloc>();
//     //                         Navigator.of(context, rootNavigator: true)
//     //                             .push(MaterialPageRoute(
//     //                           builder: (context) => BlocProvider.value(
//     //                             value: bloc,
//     //                             child: DeliverInfoView(
//     //                               model: state.advertisement[index],
//     //                               isMe: false,
//     //                             ),
//     //                           ),
//     //                         ));
//     //                       },
//     //                       child: AnnouncementsIteam(
//     //                         isPrice: true,
//     //                         isGreen: index == 0 &&
//     //                             state.advertisement[index].isOwner,
//     //                         model: state.advertisement[index],
//     //                       ),
//     //                     ),
//     //                     separatorBuilder: (context, index) =>
//     //                         const SizedBox(height: 16),
//     //                     itemCount: state.advertisement.length,
//     //                   ),
//     //                 );
//     //               },
//     //             ),
//     //             BlocBuilder<AdvertisementBloc, AdvertisementState>(
//     //               builder: (context, state) {
//     //                 if (state.statusRECEIVE.isInProgress) {
//     //                   return ListView.separated(
//     //                     padding: const EdgeInsets.all(16).copyWith(bottom: 100),
//     //                     itemBuilder: (context, index) => const WShimmer(
//     //                       height: 152,
//     //                       width: double.infinity,
//     //                     ),
//     //                     separatorBuilder: (context, index) =>
//     //                         const SizedBox(height: 16),
//     //                     itemCount: 12,
//     //                   );
//     //                 }
//     //                 if (state.advertisementRECEIVE.isEmpty) {
//     //                   return Column(
//     //                     mainAxisAlignment: MainAxisAlignment.center,
//     //                     crossAxisAlignment: CrossAxisAlignment.center,
//     //                     children: [
//     //                       AppIcons.emptyFile.svg(),
//     //                       const SizedBox(height: 16),
//     //                       WButton(
//     //                         margin: const EdgeInsets.all(16),
//     //                         onTap: () {
//     //                           context
//     //                               .read<AdvertisementBloc>()
//     //                               .add(GetAdvertisementsProvideEvent());
//     //                         },
//     //                         text: AppLocalizations.of(context)!.refresh,
//     //                       ),
//     //                       const SizedBox(height: 100)
//     //                     ],
//     //                   );
//     //                 }
//     //                 return RefreshIndicator.adaptive(
//     //                   onRefresh: () async {
//     //                     context
//     //                         .read<AdvertisementBloc>()
//     //                         .add(GetAdvertisementsReceiveEvent());
//     //                     Future.delayed(Duration.zero);
//     //                   },
//     //                   child: ListView.separated(
//     //                     padding: const EdgeInsets.all(16).copyWith(bottom: 100),
//     //                     itemBuilder: (context, index) => GestureDetector(
//     //                       onTap: () {
//     //                         final bloc = context.read<AdvertisementBloc>();
//     //                         Navigator.of(context, rootNavigator: true)
//     //                             .push(MaterialPageRoute(
//     //                           builder: (context) => BlocProvider.value(
//     //                             value: bloc,
//     //                             child: DeliverInfoView(
//     //                               model: state.advertisementRECEIVE[index],
//     //                             ),
//     //                           ),
//     //                         ));
//     //                       },
//     //                       child: AnnouncementsIteam(
//     //                         model: state.advertisementRECEIVE[index],
//     //                         isGreen: index == 0 &&
//     //                             MyFunction.isOneMinuteAgo(state
//     //                                     .advertisementRECEIVE[index]
//     //                                     .createdAt ??
//     //                                 ''),
//     //                       ),
//     //                     ),
//     //                     separatorBuilder: (context, index) =>
//     //                         const SizedBox(height: 16),
//     //                     itemCount: state.advertisementRECEIVE.length,
//     //                   ),
//     //                 );
//     //               },
//     //             ),
//     //             BlocBuilder<AdvertisementBloc, AdvertisementState>(
//     //               builder: (context, state) {
//     //                 if (state.statusPROVIDE.isInProgress) {
//     //                   return ListView.separated(
//     //                     padding: const EdgeInsets.all(16).copyWith(bottom: 100),
//     //                     itemBuilder: (context, index) => const WShimmer(
//     //                       height: 152,
//     //                       width: double.infinity,
//     //                     ),
//     //                     separatorBuilder: (context, index) =>
//     //                         const SizedBox(height: 16),
//     //                     itemCount: 12,
//     //                   );
//     //                 }
//     //                 if (state.advertisementPROVIDE.isEmpty) {
//     //                   return Column(
//     //                     mainAxisAlignment: MainAxisAlignment.center,
//     //                     crossAxisAlignment: CrossAxisAlignment.center,
//     //                     children: [
//     //                       AppIcons.emptyFile.svg(),
//     //                       const SizedBox(height: 16),
//     //                       WButton(
//     //                         margin: const EdgeInsets.all(16),
//     //                         onTap: () {
//     //                           context
//     //                               .read<AdvertisementBloc>()
//     //                               .add(GetAdvertisementsReceiveEvent());
//     //                         },
//     //                         text: AppLocalizations.of(context)!.refresh,
//     //                       ),
//     //                       const SizedBox(height: 100)
//     //                     ],
//     //                   );
//     //                 }
//     //                 return RefreshIndicator.adaptive(
//     //                   onRefresh: () async {
//     //                     context
//     //                         .read<AdvertisementBloc>()
//     //                         .add(GetAdvertisementsProvideEvent());
//     //                     Future.delayed(Duration.zero);
//     //                   },
//     //                   child: ListView.separated(
//     //                     padding: const EdgeInsets.all(16).copyWith(bottom: 100),
//     //                     itemBuilder: (context, index) => GestureDetector(
//     //                       onTap: () {
//     //                         final bloc = context.read<AdvertisementBloc>();
//     //                         Navigator.of(context, rootNavigator: true)
//     //                             .push(MaterialPageRoute(
//     //                           builder: (context) => BlocProvider.value(
//     //                             value: bloc,
//     //                             child: CreateInfoView(
//     //                               model: state.advertisementPROVIDE[index],
//     //                             ),
//     //                           ),
//     //                         ));
//     //                       },
//     //                       child: AnnouncementsIteam(
//     //                         model: state.advertisementPROVIDE[index],
//     //                       ),
//     //                     ),
//     //                     separatorBuilder: (context, index) =>
//     //                         const SizedBox(height: 16),
//     //                     itemCount: state.advertisementPROVIDE.length,
//     //                   ),
//     //                 );
//     //               },
//     //             ),
//     //           ],
//     //         );
//     //       },
//     //     ),
//     //   ),
//     // );
//   }
// }

// class AnnouncementsIteamNew extends StatelessWidget {
//   const AnnouncementsIteamNew({
//     super.key,
//     required this.model,
//   });
//   final AdvertisementModel model;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(24),
//         color: context.color.contColor,
//         boxShadow: wboxShadow2,
//       ),
//       child: Column(
//         spacing: 16,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'ID ${model.id}',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   color: context.color.darkText,
//                 ),
//               ),
//               Text(
//                 MyFunction.formatDate(
//                   DateTime.tryParse(model.createdAt ?? " ") ?? DateTime.now(),
//                 ),
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   color: context.color.darkText,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             spacing: 8,
//             children: [
//               AppIcons.columLocation.svg(),
//               Expanded(
//                 child: Column(
//                   spacing: 8,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       (model.fromLocation?.name ??
//                           AppLocalizations.of(context)!.unknown),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         color: context.color.white,
//                       ),
//                     ),
//                     Text(
//                       (model.toLocation?.name ??
//                           AppLocalizations.of(context)!.unknown),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         color: context.color.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Text(
//                 '306 km',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   color: context.color.darkText,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   spacing: 12,
//                   children: [
//                     RowIcon(
//                       text: (model.price == null || model.price == 0)
//                           ? 'Narx taklifi'
//                           : '${MyFunction.priceFormat(model.price ?? 0)} UZS',
//                       icon: AppIcons.layer.svg(
//                         color: context.color.iron,
//                         height: 20,
//                       ),
//                       isGreen: true,
//                     ),
//                     RowIcon(
//                       text: model.serviceName ??
//                           AppLocalizations.of(context)!.unknown,
//                       icon: AppIcons.shipping.svg(
//                         color: context.color.iron,
//                         height: 20,
//                       ),
//                     ),
//                     RowIcon(
//                       text: 'Qurilish materiallari, 160 kg',
//                       icon: AppIcons.box.svg(
//                         color: context.color.iron,
//                         height: 20,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (model.transportIcon != null)
//                 CachedNetworkImage(
//                   imageUrl: model.transportIcon!,
//                   height: 48,
//                 )
//             ],
//           ),
//           Container(
//             padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(24),
//               color: context.color.scaffoldBackground,
//             ),
//             height: 48,
//             child: Row(
//               spacing: 8,
//               children: [
//                 const CircleAvatar(radius: 12),
//                 Expanded(
//                   child: Text(
//                     model.createdByName ??
//                         AppLocalizations.of(context)!.unknown,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//                 WButton(
//                   onTap: () async {
//                     if (model.createdByPhone != null) {
//                       await Caller.makePhoneCall(model.createdByPhone!);
//                     } else if (model.createdByTgLink != null) {
//                       await Caller.launchTelegram(model.createdByTgLink!);
//                     } else {
//                       CustomSnackbar.show(
//                         context,
//                         AppLocalizations.of(context)!.unknown,
//                       );
//                     }
//                   },
//                   text: 'Bog‘lanish',
//                   padding: const EdgeInsets.symmetric(horizontal: 24),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class RowIcon extends StatelessWidget {
//   const RowIcon({
//     super.key,
//     required this.text,
//     this.isGreen = false,
//     required this.icon,
//   });
//   final String text;
//   final bool isGreen;
//   final Widget icon;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       spacing: 8,
//       children: [
//         icon,
//         Expanded(
//           child: Text(
//             text,
//             overflow: TextOverflow.ellipsis,
//             maxLines: 1,
//             style: isGreen
//                 ? const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: green,
//                   )
//                 : TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                     color: context.color.darkText,
//                   ),
//           ),
//         ),
//       ],
//     );
//   }
// }
