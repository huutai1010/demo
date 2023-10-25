import '../data/network/BaseApiServices.dart';
import '../data/network/NetworkApiService.dart';
import '../res/app_url.dart';

class BookingRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> postBooking(dynamic data) async {
    try {
      dynamic response = await _apiServices.getPostApiRepsonseAuth(
          AppUrl.postBookingEndpoint, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> confirmBooking(String confirmUrl) async {
    try {
      final url = confirmUrl.replaceAll(
          RegExp('http://replacement.link'), AppUrl.baseUrl);
      dynamic response = await _apiServices.getGetApiResponseAuth(url);
      return response;
    } catch (e) {
      // Do nothing
    }
  }

  Future<dynamic> getCelebratedImages(int bookingId) async {
    try {
      dynamic response = await _apiServices.getGetApiResponseAuth(
          '${AppUrl.getCelebratedPlaceEndpoint}/$bookingId');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
