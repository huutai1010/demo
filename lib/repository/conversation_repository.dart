import '../data/network/BaseApiServices.dart';
import '../data/network/NetworkApiService.dart';
import '../res/app_url.dart';

class ConversationRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> getConversationsApi() async {
    try {
      dynamic response = await _apiServices.getGetApiResponseAuth(
        AppUrl.getConversationsEndpoint,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future postConversation(dynamic data) async {
    try {
      await _apiServices.getPostApiRepsonseAuth(
          AppUrl.postConversationsEndpoint, data);
    } catch (e) {
      // Do nothing
    }
  }

  Future<dynamic> postCallApi(String receiverId) async {
    try {
      dynamic response = await _apiServices.getGetApiResponseAuth(
        '${AppUrl.postCallEndpoint}/$receiverId/1',
      );
      return response;
    } catch (e) {
      // Do nothing
    }
  }
}
