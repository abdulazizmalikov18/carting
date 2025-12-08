// import 'package:carting/data/models/delivery_create_model.dart';
// import 'package:carting/data/models/location_model.dart';

// Map<String, dynamic> getCreateModel() {
//   return DeliveryCreateModel(
//     toLocation: LocationModel(
//       lat: point2!.latitude,
//       lng: point2!.longitude,
//       name: point2!.name,
//     ),
//     fromLocation: LocationModel(
//       lat: point1!.latitude,
//       lng: point1!.longitude,
//       name: point1!.name,
//     ),
//     serviceName: 'Yuk tashish',
//     details: Details(
//       transportationTypeId: state.transportationTypes[trTypeId.value].id,
//       loadTypeId: '${loadTypeId.value}',
//       loadServiceId: '${loadServiceId.value}',
//       loadTypeList: list
//           .where((item) => item.value == true)
//           .map((item) => item.id)
//           .toList(),
//       // loadWeight: LoadWeight(
//       //   amount: int.tryParse(controllerCount.text) ?? 0,
//       //   name: selectedUnit,
//       // ),
//       fromDate: selectedDate.toString(),
//       toDate: selectedDate2.toString(),
//       kg: selectedUnit == AppLocalizations.of(context)!.unit_kg
//           ? controllerKg.text.isEmpty
//                 ? null
//                 : controllerKg.text
//           : null,
//       tn: selectedUnit == AppLocalizations.of(context)!.unit_tn
//           ? controllerKg.text.isEmpty
//                 ? null
//                 : controllerKg.text
//           : null,
//       m3: controllerm3.text.isEmpty ? null : controllerm3.text,
//       litr: controllerLitr.text.isEmpty ? null : controllerLitr.text,
//     ),
//     advType: 'RECEIVE',
//     serviceTypeId: 1,
//     shipmentDate: controller.text,
//     note: controllerCommet.text,
//     payType: switch (payDate.value) {
//       0 => null,
//       1 => 'CASH',
//       2 => 'CARD',
//       int() => null,
//     },
//     price: priceOffer.value
//         ? 0
//         : int.tryParse(controllerPrice.text.replaceAll(' ', '')) ?? 0,
//   ).toJson();
// }
