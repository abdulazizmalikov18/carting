import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/assets/assets/icons.dart';
import 'package:carting/assets/colors/colors.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/common/location_view.dart';
import 'package:carting/presentation/views/common/map_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectionLocationField extends StatefulWidget {
  const SelectionLocationField({
    super.key,
    this.onTap1,
    this.onTap2,
    this.onSucces,
    this.isOne = false,
    this.point1,
    this.point2,
  });
  final Function(MapPoint? point)? onTap1;
  final Function(MapPoint? point)? onTap2;
  final Function(MapPoint? point, MapPoint? point2)? onSucces;
  final bool isOne;
  final MapPoint? point1;
  final MapPoint? point2;

  @override
  State<SelectionLocationField> createState() => _SelectionLocationFieldState();
}

class _SelectionLocationFieldState extends State<SelectionLocationField> {
  MapPoint? point1;
  MapPoint? point2;

  @override
  void initState() {
    point1 = widget.point1;
    point2 = widget.point2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.color.contColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: wboxShadow2,
      ),
      child: Column(
        children: [
          if (widget.onTap1 != null)
            ListTile(
              onTap: () {
                final bloc = context.read<AdvertisementBloc>();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LocationView(
                    isFirst: true,
                    point1: point1,
                    point2: point2,
                    bloc: bloc,
                    onTap: (mapPoint1, mapPoint2) {
                      Navigator.pop(context);
                      if (mapPoint1 != null) {
                        point1 = mapPoint1;
                        widget.onTap1!(point1);
                        setState(() {});
                      }
                      if (mapPoint2 != null) {
                        point2 = mapPoint2;
                        widget.onTap2!(point2);
                        setState(() {});
                      }
                      if (widget.onSucces != null) {
                        widget.onSucces!(mapPoint1, mapPoint2);
                      }
                    },
                  ),
                ));
              },
              title: Text(
                '${AppLocalizations.of(context)!.from}:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: context.color.white,
                ),
              ),
              subtitle: Text(
                point1?.name ?? AppLocalizations.of(context)!.select_location,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: point1?.name == null ? context.color.darkText : null,
                ),
              ),
              trailing: Container(
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
          if (widget.onTap1 != null)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(height: 1),
            ),
          if (widget.onTap2 != null)
            ListTile(
              onTap: () {
                final bloc = context.read<AdvertisementBloc>();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LocationView(
                      isFirst: false,
                      point1: point1,
                      point2: point2,
                      bloc: bloc,
                      isOne: widget.isOne,
                      onTap: (mapPoint1, mapPoint2) {
                        Navigator.pop(context);
                        if (mapPoint1 != null) {
                          mapPoint1 = mapPoint1;
                          widget.onTap1!(point1);
                          setState(() {});
                        }
                        if (mapPoint2 != null) {
                          point2 = mapPoint2;
                          widget.onTap2!(point2);
                          setState(() {});
                        }
                        if (widget.onSucces != null) {
                          widget.onSucces!(mapPoint1, mapPoint2);
                        }
                      },
                    ),
                  ),
                );
              },
              title: Text(
                "${AppLocalizations.of(context)!.to}:",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: context.color.white,
                ),
              ),
              subtitle: Text(
                point2?.name ?? AppLocalizations.of(context)!.select_location,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: point2?.name == null ? context.color.darkText : null,
                ),
              ),
              trailing: Container(
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
        ],
      ),
    );
  }
}
