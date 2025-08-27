import 'package:carting/app/advertisement/advertisement_bloc.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/common/map_point.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/utils/debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class LocationTextView extends StatefulWidget {
  const LocationTextView({
    super.key,
    required this.isOne,
    this.point1,
    this.point2,
    required this.isFirst,
    required this.bloc,
    required this.controllerLat,
    required this.controllerLong,
    required this.onTap,
  });
  final bool isOne;
  final MapPoint? point1;
  final MapPoint? point2;
  final bool isFirst;
  final TextEditingController controllerLat;
  final TextEditingController controllerLong;
  final AdvertisementBloc bloc;
  final Function(Point? point, bool isFirst) onTap;

  @override
  State<LocationTextView> createState() => _LocationTextViewState();
}

class _LocationTextViewState extends State<LocationTextView> {
  final List<SuggestSessionResult> results = [];
  bool isFirst = false;
  late FocusNode focusNodeFrom;
  late FocusNode focusNodeTo;

  @override
  void initState() {
    super.initState();
    isFirst = widget.isFirst;
    setState(() {});
    focusNodeFrom = FocusNode();
    focusNodeTo = FocusNode();

    focusNodeFrom.addListener(() {
      setState(() {});
    });

    focusNodeTo.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    focusNodeFrom.dispose();
    focusNodeTo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Container(
          height: 5,
          width: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: const Color(0xFFB7BFC6),
          ),
        ),
        const SizedBox(height: 4),
        Hero(
          tag: 'imageHero',
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.color.contColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF292D32).withValues(alpha: 0.02),
                  offset: const Offset(0, 2),
                  blurRadius: 8.5,
                ),
              ],
            ),
            child: Column(
              children: [
                if (!widget.isOne) ...[
                  TextField(
                    controller: widget.controllerLat,
                    autofocus: isFirst,
                    focusNode: focusNodeFrom,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.from,
                      hintText: AppLocalizations.of(context)!.from,
                      border: InputBorder.none,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: focusNodeFrom.hasFocus
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (widget.controllerLat.text.isNotEmpty)
                                  IconButton(
                                    onPressed: () {
                                      widget.controllerLat.clear();
                                      setState(() {});
                                    },
                                    icon: const Icon(CupertinoIcons.clear),
                                  ),
                                WButton(
                                  height: 28,
                                  textStyle: TextStyle(
                                    fontSize: 12,
                                    color: context.color.white,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  color: context.color.grey,
                                  onTap: () {
                                    Navigator.of(context).pop(1);
                                  },
                                  text: AppLocalizations.of(context)!.mapdan,
                                ),
                              ],
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      isFirst = true;
                      onDebounce(() {
                        _suggest(value);
                      });
                    },
                  ),

                  const Divider(height: 1),
                  // To Location
                ],
                TextField(
                  controller: widget.controllerLong,
                  autofocus: !isFirst,
                  focusNode: focusNodeTo,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.to,
                    hintText: AppLocalizations.of(context)!.to,
                    border: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: focusNodeTo.hasFocus
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.controllerLong.text.isNotEmpty)
                                IconButton(
                                  onPressed: () {
                                    widget.controllerLong.clear();
                                    setState(() {});
                                  },
                                  icon: const Icon(CupertinoIcons.clear),
                                ),
                              WButton(
                                height: 28,
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  color: context.color.white,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                color: context.color.grey,
                                onTap: () {
                                  Navigator.of(context).pop(2);
                                },
                                text: AppLocalizations.of(context)!.mapdan,
                              ),
                            ],
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    isFirst = false;
                    onDebounce(() {
                      _suggest(value);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(child: Column(children: _getList())),
        ),
      ],
    );
  }

  Future<void> _suggest(String value) async {
    results.clear();
    final resultWithSession = await YandexSuggest.getSuggestions(
      text: value,
      boundingBox: const BoundingBox(
        northEast: Point(latitude: 55.0, longitude: 87.0),
        southWest: Point(latitude: 35.0, longitude: 55.0),
      ),
      suggestOptions: const SuggestOptions(
        suggestType: SuggestType.unspecified,
        suggestWords: true,
        userPosition: Point(latitude: 45.0, longitude: 70.0),
      ),
    );
    await _handleResult(await resultWithSession.$2);
  }

  Future<void> _handleResult(SuggestSessionResult result) async {
    if (result.error != null) {
      return;
    }

    setState(() {
      results.add(result);
    });
  }

  List<Widget> _getList() {
    final list = <Widget>[];

    if (results.isEmpty) {
      final locationHistory = widget.bloc.state.locationHistory;
      if (locationHistory.isNotEmpty) {
        locationHistory.asMap().forEach((i, item) {
          list.add(
            ListTile(
              title: Text(item.toLocation.name),
              onTap: () {
                if (isFirst) {
                  widget.controllerLat.text = item.toLocation.name;
                } else {
                  widget.controllerLong.text = item.toLocation.name;
                }
                widget.onTap(
                  Point(
                    latitude: item.toLocation.lat,
                    longitude: item.toLocation.lng,
                  ),
                  isFirst,
                );
                Navigator.of(context).pop();
              },
            ),
          );
          list.add(const Divider(height: 1));
        });
      } else {
        list.add((Text(AppLocalizations.of(context)!.nothing_found)));
      }
    }

    for (var r in results) {
      r.items!.asMap().forEach((i, item) {
        list.add(
          ListTile(
            title: Text(item.title),
            subtitle: Text(item.subtitle ?? "Nomalum"),
            onTap: () {
              if (isFirst) {
                widget.controllerLat.text = item.title;
              } else {
                widget.controllerLong.text = item.title;
              }
              widget.onTap(item.center, isFirst);
              Navigator.of(context).pop();
            },
          ),
        );
        list.add(const Divider(height: 1));
      });
    }

    return list;
  }
}
