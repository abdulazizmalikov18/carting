import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/assets/images.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/assets/themes/theme_changer.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/presentation/views/orders/type_of_service_view.dart';
import 'package:carting/presentation/widgets/custom_text_field.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:flutter/material.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.of(context).push(MaterialPageRoute(
        //       builder: (context) => const FilterView(),
        //     ));
        //   },
        //   icon: AppIcons.filter.svg(color: context.color.iron),
        // ),
        title: SizedBox(
          height: 24,
          width: 128,
          child: AppScope.of(context).themeMode == ThemeMode.dark
              ? AppIcons.logoWhite.svg()
              : AppImages.logoTextDark.imgAsset(),
        ),
        actions: [
          WButton(
            margin: const EdgeInsets.only(right: 16),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const TypeOfServiceView(),
              ));
            },
            height: 40,
            width: 40,
            borderRadius: 12,
            color: green,
            child: AppIcons.addCircle.svg(),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: CustomTextField(
              prefixIcon: AppIcons.searchNormal.svg(color: context.color.iron),
              hintText: "Kerakli e’lonni qidiring",
            ),
          ),
        ),
      ),
      // body: ListView.separated(
      //   padding: const EdgeInsets.all(16),
      //   itemBuilder: (context, index) => const OrdersIteam(),
      //   separatorBuilder: (context, index) => const SizedBox(height: 16),
      //   itemCount: 12,
      // ),
    );
  }
}
