import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/repository/place_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import '../models/place.dart';
import '../services/local_storage_service.dart';
import 'package:flutter/material.dart';

class PlaceDetailViewModel with ChangeNotifier {
  final _placeRepo = PlaceRepository();
  var markers = <Marker>[];
  var places = <Place>[];

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<Place?> getPlaceDetails(int placeId) async {
    late Place? place;
    await _placeRepo.getPlaceDetails(placeId).then((value) {
      setLoading(false);
      if (value['place'] != null) {
        place = Place.fromJson(value['place']);
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
    });
    return place;
  }

  Future addPlaceToCart(Place place, BuildContext context) async {
    await LocalStorageService.getInstance.addToCartPlace(place).then((value) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(context.tr('add_place_to_tour_successfully')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  Future<bool> isBookingPlace(int placeId) async {
    var result = false;
    await _placeRepo.isBookingPlace(placeId).then((value) {
      result = value;
      return result;
    });
    return result;
  }

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  loadMarkerData(Place place, BuildContext context) async {
    places.add(place);
    final Uint8List markerIcon =
        await getBytesFromAssets('assets/images/map/pin-place.png', 150);
    for (int i = 0; i < places.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(places[i].latitude!, places[i].longitude!),
          icon: BitmapDescriptor.fromBytes(markerIcon),
          onTap: () {},
        ),
      );
    }
  }
}
