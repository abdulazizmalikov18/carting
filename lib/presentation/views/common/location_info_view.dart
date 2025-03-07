import 'package:carting/data/models/advertisement_model.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class LocationInfoView extends StatefulWidget {
  const LocationInfoView({
    super.key,
    this.isOne = false,
    this.point1,
    this.point2,
    required this.isFirst,
  });
  final bool isOne;
  final Location? point1;
  final Location? point2;
  final bool isFirst;

  @override
  State<LocationInfoView> createState() => _LocationInfoViewState();
}

class _LocationInfoViewState extends State<LocationInfoView> {
  late YandexMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: (controller) async {
              mapController = controller;
              if (widget.isFirst) {
                await mapController.moveCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: Point(
                        latitude: widget.point1!.lat,
                        longitude: widget.point1!.lng,
                      ),
                      zoom: 13,
                    ),
                  ),
                );
              } else {
                await mapController.moveCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: Point(
                        latitude: widget.point2!.lat,
                        longitude: widget.point2!.lng,
                      ),
                      zoom: 13,
                    ),
                  ),
                );
              }
            },
            mapObjects: [
              if (widget.point1 != null)
                PlacemarkMapObject(
                  mapId: const MapObjectId('widget.point1!.lat'),
                  point: Point(
                    latitude: widget.point1!.lat,
                    longitude: widget.point1!.lng,
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
              if (widget.point2 != null)
                PlacemarkMapObject(
                  mapId: const MapObjectId('widget.point2!.lat'),
                  point: Point(
                    latitude: widget.point2!.lat,
                    longitude: widget.point2!.lng,
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
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: CircleAvatar(
                backgroundColor: context.color.contColor,
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
            ),
          ),
        ],
      ),
    );
  }
}
