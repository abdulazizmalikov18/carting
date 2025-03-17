import 'package:carting/assets/colors/colors.dart';
import 'package:carting/data/models/advertisement_model.dart';
import 'package:carting/infrastructure/core/context_extension.dart';
import 'package:carting/utils/log_service.dart';
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
  late final List<MapObject> mapObjects = [];
  final List<DrivingSessionResult> results = [];
  late final DrivingSession session;
  DrivingRoute? route;

  diriv() async {
    var resultWithSession = await YandexDriving.requestRoutes(
      points: [
        RequestPoint(
          point: Point(
            latitude: widget.point1!.lat,
            longitude: widget.point1!.lng,
          ),
          requestPointType: RequestPointType.wayPoint,
        ),
        RequestPoint(
          point: Point(
            latitude: widget.point2!.lat,
            longitude: widget.point2!.lng,
          ),
          requestPointType: RequestPointType.wayPoint,
        ),
      ],
      drivingOptions: const DrivingOptions(
        routesCount: 1,
        avoidTolls: true,
        avoidUnpaved: true,
      ),
    );
    session = resultWithSession.$1;
    final data3 = await resultWithSession.$2;
    await _handleResult(data3);
  }

  Future<void> _handleResult(DrivingSessionResult result) async {
    if (result.error != null) {
      return;
    }

    setState(() {
      results.add(result);
    });
    setState(() {
      try {
        if (result.routes!.isNotEmpty) {
          route = result.routes!.first;
        }
      } catch (e) {
        Log.e(e);
      }
      result.routes!.asMap().forEach((i, route) {
        mapObjects.add(PolylineMapObject(
          mapId: const MapObjectId('route_polyline'),
          polyline: route.geometry,
          strokeColor: green,
          strokeWidth: 5,
        ));
      });
    });
    _centerRouteOnMap();
  }

  void _centerRouteOnMap() {
    if (route != null) {
      // newGeometry metodini ishlatish
      const focusRect = ScreenRect(
        bottomRight: ScreenPoint(x: 800, y: 1600),
        topLeft: ScreenPoint(x: 200, y: 400),
      );
      mapController.moveCamera(
        CameraUpdate.newGeometry(
          Geometry.fromPolyline(route!.geometry),
          focusRect: focusRect,
        ),
        animation: const MapAnimation(
          type: MapAnimationType.smooth,
          duration: 1.0,
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.point1 != null && widget.point2 != null) {
      diriv();
    }
  }

  @override
  void dispose() {
    super.dispose();

    _close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: (controller) async {
              mapController = controller;
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
              ...mapObjects,
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

  Future<void> _close() async {
    await session.close();
  }
}
