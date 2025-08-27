import 'package:carting/assets/assets/icons.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/presentation/widgets/w_scale_animation.dart';
import 'package:flutter/cupertino.dart';

class CargoTypeItem extends StatefulWidget {
  const CargoTypeItem({
    super.key,
    this.width,
    required this.onItemTap,
    required this.list,
  });
  final double? width;
  final Function(List<CargoTypeValu> list) onItemTap;
  final List<CargoTypeValu> list;

  @override
  State<CargoTypeItem> createState() => _CargoTypeItemState();
}

class _CargoTypeItemState extends State<CargoTypeItem> {
  late List<CargoTypeValu> list;

  @override
  void initState() {
    list = widget.list;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
      child: ListView.builder(
        itemBuilder: (context, index) => WScaleAnimation(
          onTap: () {
            setState(() {
              list[index].value = !list[index].value;
            });
            widget.onItemTap(list);
          },
          child: CupertinoListTile(
            trailing: list[index].value
                ? AppIcons.checkboxActiv.svg()
                : AppIcons.checkbox.svg(),
            title: Text(
              list[index].title,
              style: TextStyle(
                color: context.color.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        itemCount: list.length,
        shrinkWrap: true,
      ),
    );
  }
}

class CargoTypeValu {
  String title;
  bool value;
  final int id;
  CargoTypeValu({required this.id, required this.title, required this.value});
}
