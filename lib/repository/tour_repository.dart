import 'package:etravel_mobile/models/tour.dart';
import 'package:etravel_mobile/services/local_storage_service.dart';

import '../data/network/BaseApiServices.dart';
import '../data/network/NetworkApiService.dart';
import '../res/app_url.dart';

class TourRepository {
  final BaseApiServices _baseApiServices = NetworkApiService();

  Future<dynamic> getPopularTour() async {
    try {
      dynamic response =
          _baseApiServices.getGetApiResponseAuth(AppUrl.topTourEndpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getTourDetails(int tourId) async {
    try {
      dynamic response = _baseApiServices
          .getGetApiResponseAuth('${AppUrl.tourDetailsEndpoint}/$tourId');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
