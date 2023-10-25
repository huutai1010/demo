import 'package:etravel_mobile/models/tour.dart';

import '../models/place.dart';
import '../services/local_storage_service.dart';

class TourCreatingViewModel {
  Future<List<Place>> getPlacesFromCart() async {
    var places = <Place>[];
    await LocalStorageService.getInstance.getPlacesFromCart().then((value) {
      places = value;
    });
    return places;
  }

  Future<List<Tour>> getToursFromCart() async {
    var places = <Tour>[];
    await LocalStorageService.getInstance.getToursFromCart().then((value) {
      places = value;
    });
    return places;
  }

  Future<double> getTotalPrice() async {
    late double price = 0.0;
    await LocalStorageService.getInstance.getPlacesFromCart().then((value) {
      for (var element in value) {
        price += element.price!;
      }
    });
    return price;
  }

  Future<double> getToursTotalPrice() async {
    late double price = 0.0;
    await LocalStorageService.getInstance.getToursFromCart().then((value) {
      for (var element in value) {
        price += element.total!;
      }
    });
    return price;
  }
}
