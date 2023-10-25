import '../models/place.dart';
import '../models/place_image.dart';
import '../models/tour.dart';
import '../repository/place_repository.dart';
import '../repository/tour_repository.dart';
import '../services/logger_service.dart';
import '../view/place/place_detail_view.dart';
import '../view/tour/tour_detail_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeViewViewModel with ChangeNotifier {
  final _placeRepo = PlaceRepository();
  final _tourRepo = TourRepository();

  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<List<Place>> getPopularPlaces() async {
    var popularPlaces = <Place>[];
    await _placeRepo.getPopularPlaces().then((value) {
      setLoading(false);
      if (value['places'] != null) {
        var json = value as Map<String, dynamic>;
        json['places'].forEach((v) => popularPlaces.add(Place.fromJson(v)));
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
    });
    return popularPlaces;
  }

  Future<List<Tour>> getPopularTours() async {
    var popularTours = <Tour>[];
    await _tourRepo.getPopularTour().then((value) {
      setLoading(false);
      if (value['tours'] != null) {
        var json = value as Map<String, dynamic>;
        json['tours'].forEach((v) => popularTours.add(Tour.fromJson(v)));
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
    });
    return popularTours;
  }

  Future<Place?> getPlaceDetails(
      int placeId, BuildContext homeViewContext, bool isPopularPlace) async {
    Place? place;
    await _placeRepo.getPlaceDetails(placeId).then((value) {
      setLoading(false);
      if (value['place'] != null) {
        place = Place.fromJson(value['place']);
        loggerInfo.i('get place success');
        Navigator.push(
          homeViewContext,
          MaterialPageRoute(
            builder: (_) => isPopularPlace
                ? PlaceDetailView(
                    id: place?.id ?? 0,
                    name: place?.name ?? 'Undefined',
                    description: place?.description ?? 'Undefined',
                    placeImages: place?.placeImages ?? <PlaceImages>[],
                    price: place?.price ?? 0.0,
                    exchanges: place?.exchanges ?? {},
                    entryTicket: place?.entryTicket ?? 0.0,
                    rate: place?.rate ?? 0.0,
                    feedbacks: place?.feedBacks ?? [],
                    openTime: place?.openTime ?? 'Undefined',
                    endTime: place?.endTime ?? 'Undefined',
                  )
                : Container(),
          ),
        );
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
    });
    return place;
  }

  void getTourDetails(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => Container()));
  }

  Future<Tour?> getTourDetailsV2(
      int tourId, BuildContext homeViewContext, bool isPopularPlace) async {
    Tour? tour;
    await _tourRepo.getTourDetails(tourId).then((value) {
      setLoading(false);
      if (value['tour'] != null) {
        tour = Tour.fromJson(value['tour']);
        loggerInfo.i('get tour success');
        Navigator.push(
          homeViewContext,
          MaterialPageRoute(
            builder: (_) => !isPopularPlace
                ? TourDetailView(
                    id: tour?.id ?? 0,
                    name: tour?.name ?? 'Undefined',
                    description: tour?.description ?? 'Undefined',
                    image: tour?.image ?? 'Undefined',
                    places: tour?.places ?? <Place>[],
                    placeImages: tour?.placeImages ?? <PlaceImages>[],
                    price: tour?.price ?? 0.0,
                    rate: tour?.rate ?? 0.0,
                    feedbacks: tour?.feedBacks ?? [],
                    exchanges: tour?.exchanges ?? {},
                  )
                : Container(),
          ),
        );
      }
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(error.toString());
      }
    });
    return tour;
  }
}
