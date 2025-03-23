part of 'package:carting/presentation/views/common/location_view.dart';

mixin LocotionMixin on State<LocationView> {
  late TextEditingController controllerLat;
  late TextEditingController controllerLong;
  YandexMapController? mapController;
  DrivingSession? session;
  // bool _isControllerDisposed = false;
  List<MapPoint> list = [];
  MapPoint? point1;
  MapPoint? point2;
  ValueNotifier<bool> isMap = ValueNotifier(false);
  ValueNotifier<int> isMapIndex = ValueNotifier(1);
  late final List<MapObject> mapObjects = [];
  final List<DrivingSessionResult> results = [];

  CameraPosition? _userLocation;
  CameraPosition? _position;

  String _address = 'Manzil aniqlanmoqda...';

  /// Значение текущего масштаба карты
  var _mapZoom = 0.0;
  @override
  void initState() {
    getMerk();
    controllerLat = TextEditingController(
      text: widget.point1?.name ?? "",
    );
    controllerLong = TextEditingController(
      text: widget.point2?.name ?? "",
    );

    point1 = widget.point1;
    point2 = widget.point2;

    super.initState();
    AndroidYandexMap.useAndroidViewSurface = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.isFirst && point1 != null) {
      _moveToCurrentLocation(AppLatLong(
        lat: point1!.latitude,
        long: point1!.longitude,
      ));
    } else if (point2 != null) {
      _moveToCurrentLocation(AppLatLong(
        lat: point2!.latitude,
        long: point2!.longitude,
      ));
    } else {
      _initPermission().ignore();
    }
    if (point1 != null && point2 != null) {
      diriv();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _close();
  }

  getMerk() {
    if (widget.point1 != null) {
      Log.i('Kirdik');
      list.add(widget.point1!);
      setState(() {});
    }
  }

  void _onMapCreated(YandexMapController controller) {
    setState(() {
      mapController = controller;
    });
    // _isControllerDisposed = false; // Controller hali dispose bo‘lmadi
  }

  diriv() async {
    var resultWithSession = await YandexDriving.requestRoutes(
      points: [
        RequestPoint(
          point: Point(
            latitude: point1!.latitude,
            longitude: point1!.longitude,
          ),
          requestPointType: RequestPointType.wayPoint,
        ),
        RequestPoint(
          point: Point(
            latitude: point2!.latitude,
            longitude: point2!.longitude,
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
      result.routes!.asMap().forEach((i, route) {
        mapObjects.add(PolylineMapObject(
          mapId: MapObjectId('route_${i}_polyline'),
          polyline: route.geometry,
          strokeColor: green,
          strokeWidth: 5,
        ));
      });
    });
  }

  /// Метод, который включает слой местоположения пользователя на карте
  /// Выполняется проверка на доступ к местоположению, в случае отсутствия
  /// разрешения - выводит сообщение
  Future<void> _initLocationLayer() async {
    final locationPermissionIsGranted =
        await Permission.location.request().isGranted;

    if (locationPermissionIsGranted) {
      await mapController?.toggleUserLayer(visible: true);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        CustomSnackbar.show(
          context,
          'Нет доступа к местоположению пользователя',
        );
      });
    }
  }

  /// Метод для получения коллекции кластеризованных маркеров
  ClusterizedPlacemarkCollection _getClusterizedCollection({
    required List<PlacemarkMapObject> placemarks,
  }) {
    return ClusterizedPlacemarkCollection(
      mapId: const MapObjectId('clusterized-1'),
      placemarks: placemarks,
      radius: 50,
      minZoom: 15,
      onClusterAdded: (self, cluster) async {
        return cluster.copyWith(
          appearance: cluster.appearance.copyWith(
            opacity: 1.0,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromBytes(
                  await ClusterIconPainter(cluster.size).getClusterIconBytes(),
                ),
              ),
            ),
          ),
        );
      },
      onClusterTap: (self, cluster) async {
        await mapController?.moveCamera(
          animation:
              const MapAnimation(type: MapAnimationType.linear, duration: 0.3),
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: cluster.placemarks.first.point,
              zoom: _mapZoom + 1,
            ),
          ),
        );
      },
    );
  }

  /// Метод для генерации объектов маркеров для отображения на карте
  List<PlacemarkMapObject> _getPlacemarkObjects(BuildContext context) {
    return list
        .map(
          (point) => PlacemarkMapObject(
            mapId: MapObjectId('MapObject $point'),
            point: Point(latitude: point.latitude, longitude: point.longitude),
            opacity: 1,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage(
                  'assets/images/location.png',
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  Future<String> getPlaceMarkFromYandex(double lat, double lon) async {
    try {
      final resultWithSession = await YandexSearch.searchByPoint(
        point: Point(latitude: lat, longitude: lon),
        searchOptions: const SearchOptions(
          searchType: SearchType.geo,
          geometry: false,
        ),
      );

      final results = await resultWithSession.$2;
      if (results.items != null) {
        if (results.items!.isNotEmpty) {
          final address = results.items!.first.name;
          return address;
        }
      }
      return 'No address found';
    } catch (e) {
      return 'Error getting address';
    }
  }

  /// Проверка разрешений на доступ к геопозиции пользователя
  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }

  /// Получение текущей геопозиции пользователя
  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = TashketnLoaction();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }
    _moveToCurrentLocation(location);
  }

  /// Метод для показа текущей позиции
  Future<void> _moveToCurrentLocation(
    AppLatLong appLatLong,
  ) async {
    mapController?.moveCamera(
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: appLatLong.lat,
            longitude: appLatLong.long,
          ),
          zoom: 15,
        ),
      ),
    );
  }

  Future<void> _close() async {
    // if (!_isControllerDisposed) {
    //   _isControllerDisposed = true;
    //   mapController.dispose();
    // }
    if (session != null) {
      try {
        await session?.cancel();
        await session?.close();
      } catch (e) {
        Log.e(e);
      }
    }
  }
}
