import 'package:carting/assets/colors/colors.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/presentation/views/common/location_text_view.dart';
import 'package:carting/presentation/widgets/custom_snackbar.dart';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'package:carting/assets/assets/icons.dart';
import 'package:carting/l10n/localizations.dart';
import 'package:carting/presentation/views/common/app_lat_long.dart';
import 'package:carting/presentation/views/common/clusterized_icon_painter.dart';
import 'package:carting/presentation/views/common/location_service.dart';
import 'package:carting/presentation/views/common/map_point.dart';
import 'package:carting/presentation/widgets/w_button.dart';
import 'package:carting/utils/log_service.dart';

part 'package:carting/presentation/views/common/locotion_mixin.dart';

class LocationView extends StatefulWidget {
  const LocationView({
    super.key,
    required this.onTap,
    this.isOne = false,
    this.point1,
    this.point2,
    required this.isFirst,
  });
  final Function(MapPoint? point1, MapPoint? point2) onTap;
  final bool isOne;
  final MapPoint? point1;
  final MapPoint? point2;
  final bool isFirst;

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> with LocotionMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        color: context.color.scaffoldBackground,
        child: ValueListenableBuilder(
          valueListenable: isMap,
          builder: (context, _, __) {
            if (isMap.value) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          isMap.value = false;
                        },
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      Text(
                        isMapIndex.value == 1
                            ? AppLocalizations.of(context)!.from
                            : AppLocalizations.of(context)!.to,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Text(
                    isMapIndex.value == 1
                        ? controllerLat.text
                        : controllerLong.text,
                  ),
                  const Divider(height: 32),
                  const SizedBox(height: 16),
                  SafeArea(
                    top: false,
                    child: WButton(
                      onTap: () {
                        if (isMapIndex.value == 1) {
                          point1 = MapPoint(
                            name: _address,
                            latitude: _position?.target.latitude ?? 0,
                            longitude: _position?.target.longitude ?? 0,
                          );
                        } else {
                          point2 = MapPoint(
                            name: _address,
                            latitude: _position?.target.latitude ?? 0,
                            longitude: _position?.target.longitude ?? 0,
                          );
                        }
                        isMap.value = false;
                        setState(() {});
                      },
                      text: AppLocalizations.of(context)!.confirm,
                    ),
                  ),
                ],
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: 'imageHero',
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: context.color.contColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF292D32).withValues(alpha: 0.02),
                          offset: const Offset(0, 2),
                          blurRadius: 8.5,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        if (!widget.isOne) ...[
                          TextField(
                            controller: controllerLat,
                            readOnly: true,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor:
                                    context.color.scaffoldBackground,
                                isScrollControlled: true,
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.sizeOf(context).height * 0.9,
                                ),
                                builder: (context) => LocationTextView(
                                  isOne: widget.isOne,
                                  isFirst: true,
                                  controllerLat: controllerLat,
                                  controllerLong: controllerLong,
                                  onTap: (point, isFirst) {
                                    Log.wtf(isFirst);
                                    _moveToCurrentLocation(AppLatLong(
                                      lat: point?.latitude ?? 0,
                                      long: point?.longitude ?? 0,
                                    ));
                                    Log.wtf(controllerLong.text);
                                    if (isFirst) {
                                      point1 = MapPoint(
                                        name: controllerLat.text,
                                        latitude: point!.latitude,
                                        longitude: point.longitude,
                                      );
                                    } else {
                                      point2 = MapPoint(
                                        name: controllerLong.text,
                                        latitude: point!.latitude,
                                        longitude: point.longitude,
                                      );
                                    }
                                    setState(() {});
                                  },
                                ),
                              ).then((value) {
                                if (value is int) {
                                  isMap.value = true;
                                  isMapIndex.value = value;
                                }
                              });
                            },
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.from,
                              hintText: AppLocalizations.of(context)!.from,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: InputBorder.none,
                            ),
                          ),
                          const Divider(height: 1),
                          // To Location
                        ],
                        TextField(
                          controller: controllerLong,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.to,
                            hintText: AppLocalizations.of(context)!.to,
                            border: InputBorder.none,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: context.color.scaffoldBackground,
                              isScrollControlled: true,
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.sizeOf(context).height * 0.9,
                              ),
                              builder: (context) => LocationTextView(
                                isOne: widget.isOne,
                                isFirst: false,
                                controllerLat: controllerLat,
                                controllerLong: controllerLong,
                                onTap: (point, isFirst) {
                                  _moveToCurrentLocation(AppLatLong(
                                    lat: point?.latitude ?? 0,
                                    long: point?.longitude ?? 0,
                                  ));
                                  if (isFirst) {
                                    isMapIndex.value = 1;
                                    point1 = MapPoint(
                                      name: controllerLat.text,
                                      latitude: point!.latitude,
                                      longitude: point.longitude,
                                    );
                                  } else {
                                    isMapIndex.value = 2;
                                    point2 = MapPoint(
                                      name: controllerLong.text,
                                      latitude: point!.latitude,
                                      longitude: point.longitude,
                                    );
                                  }
                                  setState(() {});
                                },
                              ),
                            ).then((value) {
                              if (value is int) {
                                Log.i(value);
                                isMap.value = true;
                                isMapIndex.value = value;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Confirm button
                SafeArea(
                  top: false,
                  child: WButton(
                    onTap: () {
                      widget.onTap(point1, point2);
                    },
                    text: AppLocalizations.of(context)!.confirm,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          // Google Map
          ValueListenableBuilder(
            valueListenable: isMap,
            builder: (context, _, __) {
              return YandexMap(
                onMapCreated: (controller) async {
                  _onMapCreated(controller);
                  mapController?.moveCamera(CameraUpdate.newCameraPosition(
                    const CameraPosition(
                      target: Point(
                        latitude: 41.2995,
                        longitude: 69.2401,
                      ), // O'zbekiston markazi
                      zoom: 3.0, // Kattaroq zoom
                    ),
                  ));
                  if (widget.point1 == null || widget.point2 == null) {
                    await _initLocationLayer();
                  } else {
                    if (widget.point1 != null) {
                      mapController?.moveCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: Point(
                            latitude: widget.point1!.latitude,
                            longitude: widget.point1!.longitude,
                          ),
                        ),
                      ));
                    } else {
                      mapController?.moveCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: Point(
                            latitude: widget.point2!.latitude,
                            longitude: widget.point2!.longitude,
                          ),
                        ),
                      ));
                    }
                  }
                },
                onCameraPositionChanged:
                    (cameraPosition, reason, finished) async {
                  if ((widget.point1 == null || widget.point2 == null) ||
                      isMap.value) {
                    Log.i("message");
                    if (finished) {
                      _address = await getPlaceMarkFromYandex(
                        cameraPosition.target.latitude,
                        cameraPosition.target.longitude,
                      );
                      _position = cameraPosition;
                      if (widget.isFirst && isMapIndex.value == 1) {
                        Log.i("message 1");
                        controllerLat.text = _address;
                        point1 = MapPoint(
                          name: controllerLat.text,
                          latitude: _position?.target.latitude ?? 0,
                          longitude: _position?.target.longitude ?? 0,
                        );
                      } else {
                        Log.i("message 2");
                        controllerLong.text = _address;
                        point2 = MapPoint(
                          name: controllerLong.text,
                          latitude: _position?.target.latitude ?? 0,
                          longitude: _position?.target.longitude ?? 0,
                        );
                      }
                    }
                    setState(() {
                      _mapZoom = cameraPosition.zoom;
                    });
                  }
                },
                mapObjects: [
                  _getClusterizedCollection(
                    placemarks: _getPlacemarkObjects(context),
                  ),
                  if (point1 != null)
                    PlacemarkMapObject(
                      mapId: const MapObjectId('widget.point1!.lat'),
                      point: Point(
                        latitude: point1!.latitude,
                        longitude: point1!.longitude,
                      ),
                      opacity: 1,
                      icon: PlacemarkIcon.single(
                        PlacemarkIconStyle(
                          image: BitmapDescriptor.fromAssetImage(
                            'assets/images/location.png',
                          ),
                        ),
                      ),
                    ),
                  if (point2 != null)
                    PlacemarkMapObject(
                      mapId: const MapObjectId('widget.point2!.lat'),
                      point: Point(
                        latitude: point2!.latitude,
                        longitude: point2!.longitude,
                      ),
                      opacity: 1,
                      icon: PlacemarkIcon.single(
                        PlacemarkIconStyle(
                          image: BitmapDescriptor.fromAssetImage(
                            'assets/images/location.png',
                          ),
                        ),
                      ),
                    ),
                  ...mapObjects,
                ],
                onUserLocationAdded: (view) async {
                  // получаем местоположение пользователя
                  _userLocation = await mapController?.getUserCameraPosition();
                  // если местоположение найдено, центрируем карту относительно этой точки
                  if (_userLocation != null) {
                    await mapController?.moveCamera(
                      CameraUpdate.newCameraPosition(
                        _userLocation!.copyWith(zoom: 15),
                      ),
                      animation: const MapAnimation(
                        type: MapAnimationType.linear,
                        duration: 0.3,
                      ),
                    );
                  }
                  // меняем внешний вид маркера - делаем его непрозрачным
                  return view.copyWith(
                    arrow: view.arrow.copyWith(
                      opacity: 1,
                      icon: PlacemarkIcon.single(
                        PlacemarkIconStyle(
                          image: BitmapDescriptor.fromAssetImage(
                            'assets/images/location_current.png',
                          ),
                          scale: .2,
                        ),
                      ),
                    ),
                    pin: view.pin.copyWith(
                      opacity: 1,
                      icon: PlacemarkIcon.single(
                        PlacemarkIconStyle(
                          image: BitmapDescriptor.fromAssetImage(
                            'assets/images/location_current.png',
                          ),
                          scale: .2,
                        ),
                      ),
                    ),
                  );
                },
                onMapTap: (Point point) async {
                  mapController?.moveCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(target: point),
                    ),
                    animation: const MapAnimation(duration: 1.0),
                  );
                },
              );
            },
          ),
          // Location marker in the center

          if ((widget.point1 == null || widget.point2 == null) || isMap.value)
            Center(
              child: CircleAvatar(
                backgroundColor: context.color.contColor,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: AppIcons.mapPin.svg(),
                ),
              ),
            ),
          Positioned(
            bottom: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: context.color.contColor,
                  radius: 24,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: context.color.white,
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: context.color.contColor,
                  radius: 24,
                  child: IconButton(
                    onPressed: () async {
                      await _initLocationLayer();
                      await _fetchCurrentLocation();
                    },
                    icon: AppIcons.gps.svg(color: context.color.white),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 24,
              decoration: BoxDecoration(
                color: context.color.scaffoldBackground,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, -2),
                    blurRadius: 10.0,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
