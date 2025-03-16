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
  final Function(Point? point, bool isFirst) onTap;

  @override
  State<LocationTextView> createState() => _LocationTextViewState();
}

class _LocationTextViewState extends State<LocationTextView> {
  final List<SuggestSessionResult> results = [];
  bool isFirst = false;

  @override
  void initState() {
    super.initState();
    isFirst = widget.isFirst;
    setState(() {});
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
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.color.scaffoldBackground,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                if (!widget.isOne) ...[
                  TextField(
                    controller: widget.controllerLat,
                    autofocus: isFirst,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.from,
                      hintText: AppLocalizations.of(context)!.from,
                      border: InputBorder.none,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: Row(
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
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            color: context.color.grey,
                            onTap: () {
                              Navigator.of(context).pop(1);
                            },
                            text: 'Mapdan',
                          ),
                        ],
                      ),
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
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.to,
                    hintText: AppLocalizations.of(context)!.to,
                    border: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Row(
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
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          color: context.color.grey,
                          onTap: () {
                            Navigator.of(context).pop(2);
                          },
                          text: 'Mapdan',
                        ),
                      ],
                    ),
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
          child: SingleChildScrollView(
            child: Column(
              children: _getList(),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _suggest(String value) async {
    print('Suggest query: $value');
    results.clear();
    final resultWithSession = await YandexSuggest.getSuggestions(
      text: value,
      boundingBox: const BoundingBox(
        northEast: Point(latitude: 56.0421, longitude: 38.0284),
        southWest: Point(latitude: 55.5143, longitude: 37.24841),
      ),
      suggestOptions: const SuggestOptions(
        suggestType: SuggestType.geo,
        suggestWords: true,
        userPosition: Point(latitude: 56.0321, longitude: 38),
      ),
    );
    await _handleResult(await resultWithSession.$2);
  }

  Future<void> _handleResult(SuggestSessionResult result) async {
    if (result.error != null) {
      print('Error: ${result.error}');
      return;
    }

    setState(() {
      results.add(result);
    });
  }

  List<Widget> _getList() {
    final list = <Widget>[];

    if (results.isEmpty) {
      list.add((const Text('Nothing found')));
    }

    for (var r in results) {
      r.items!.asMap().forEach((i, item) {
        list.add(ListTile(
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
        ));
        list.add(const Divider(height: 1));
      });
    }

    return list;
  }
}
