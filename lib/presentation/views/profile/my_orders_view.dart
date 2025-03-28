import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/widgets/w_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyOrdersView extends StatefulWidget {
  const MyOrdersView({super.key});

  @override
  State<MyOrdersView> createState() => _MyOrdersViewState();
}

class _MyOrdersViewState extends State<MyOrdersView> {
  @override
  void initState() {
    context.read<AdvertisementBloc>().add(GetAdvertisementsProvideEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.myOrders),
          bottom: const PreferredSize(
            preferredSize: Size(double.infinity, 72),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: WTabBar(tabs: [Text('Faollar'), Text('Tugallanganlar')]),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            SizedBox(),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
