class AppUrl {
  static var baseUrl = 'http://10.0.2.2:8000';

  static var socketBaseUrl =
      'https://etravel-tracking-location.azurewebsites.net';

  static var googleMapHost = 'https://maps.googleapis.com/maps/api';

  static var getDirections =
      '$googleMapHost/directions/json?key=&origin=destination=';

  static var phoneLoginEndpoint = '$baseUrl/api/auth/user/login';

  static var getCurrentProfileEndpoint = '$baseUrl/api/auth/me';

  static var updateCurrentProfileEndpoint = '$baseUrl/api/auth/me';

  static var loginEndPoint = '$baseUrl/api/auth/user/login';

  static var registerEndPoint = '$baseUrl/api/auth/register';

  static var getLanguagesEndpoint = '$baseUrl/api/languages';

  static var changeLanguageEndpoint = '$baseUrl/api/auth/languages';

  static var getPlacesAroundEndpoint = '$baseUrl/api/places/nearby';

  static var searchPlacesEndpoint = '$baseUrl/api/places/search?category=';

  static var topPlaceEndpoint = '$baseUrl/api/places/top?top=10';

  static var topTourEndpoint = '$baseUrl/api/tours/top?top=10';

  static var placeDetailsEndpoint = '$baseUrl/api/places';

  static var tourDetailsEndpoint = '$baseUrl/api/tours';

  static var getFeedbackEndpoint = '$baseUrl/api/feedbacks/';

  static var createFeedbackEnpoint = '$baseUrl/api/feedbacks';

  static var getCategoriesEndpoint = '$baseUrl/api/categories?languageCode=';

  static var markFavoritePlaceEndpoint = '$baseUrl/api/accounts/mark-place/';

  static var getFavoritePlaceEndpoint = '$baseUrl/api/accounts/mark-place';

  static var pushNotificationEndpoint = '$baseUrl/notification';

  static var createConversationEndpoint = '$baseUrl/api/conversations';

  static var getConversationsEndpoint = '$baseUrl/api/conversations';
  static var postConversationsEndpoint = '$baseUrl/api/conversations';

  static var getCelebratedPlaceEndpoint = '$baseUrl/api/bookings/celebrated';

  static var createCelebratedPlaceEndpoint = '$baseUrl/api/bookings/celebrated';

  static var getVideoCallDetailsEndpoint = '$baseUrl/api/conversations/call';

  static var getAccountsEndpoint = '$baseUrl/api/accounts?pagesize=10000';
  static var getNearbyAccountsEndpoint = '$baseUrl/api/accounts/nearby';

  static var postCallEndpoint = '$baseUrl/api/conversations/call';

  static var postNotificationEndpoint = '$baseUrl/notification';
  static var getTransactionsEndpoint = '$baseUrl/api/transactions';
  static var postBookingEndpoint = '$baseUrl/api/bookings';
  static var getNationalitiesEndpoint = '$baseUrl/api/nationalities';
}
