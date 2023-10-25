import 'dart:convert';
import 'dart:io';
import 'package:etravel_mobile/models/error.dart';
import 'package:etravel_mobile/services/logger_service.dart';
import 'package:etravel_mobile/services/secure_storage_service.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../app_exception.dart';
import 'BaseApiServices.dart';

class NetworkApiService extends BaseApiServices {
  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Content-type": "application/json",
        "Accept": "text/plain",
      }).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      loggerInfo.i('Socket Exception');
      throw FetchDataException('No Internet Exception (Socket)');
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, data) async {
    dynamic responseJson;
    try {
      Response response = await http
          .post(Uri.parse(url),
              headers: {
                "Content-type": "application/json",
                'Accept': 'text/plain',
              },
              body: jsonEncode(data))
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getPutApiResponse(String url, data) {
    throw UnimplementedError();
  }

  @override
  Future getGetApiResponseAuth(String url) async {
    dynamic responseJson;
    String? accessToken;
    await SecureStorageService.getInstance
        .readSecureAccessToken()
        .then((value) => accessToken = value);

    try {
      Response repsonse = await http.get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'text/plain',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(repsonse);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future getPostApiRepsonseAuth(String url, data) async {
    dynamic responseJson;
    String? accessToken;
    await SecureStorageService.getInstance
        .readSecureAccessToken()
        .then((value) => accessToken = value);
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'text/plain',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on FetchDataException {
      throw FetchDataException('No Internet Exception');
    }
    return responseJson;
  }

  dynamic returnResponse(Response response) {
    loggerInfo.w('status code = ${response.statusCode}');
    late ErrorEtravel errorEtravel;
    if (response.statusCode >= 400) {
      errorEtravel = ErrorEtravel.fromJson(jsonDecode(response.body));
    }
    switch (response.statusCode) {
      case 200:
      case 201:
        if (response.body.isNotEmpty) {
          final responseJson = jsonDecode(response.body);
          return responseJson;
        }
        return null;
      case 400:
        throw BadRequestException(errorEtravel.message);
      case 401:
        throw UnauthorisedException(errorEtravel.message);
      case 402:
        throw PaymentRequiredException(errorEtravel.message);
      case 403:
        throw ForbiddenException(errorEtravel.message);
      case 404:
        throw NotFoundException(errorEtravel.message);
      case 405:
        throw MethodNotAllowedException(errorEtravel.message);
      case 406:
        throw NotAcceptableException(errorEtravel.message);
      case 408:
        throw RequestTimeoutException(errorEtravel.message);
      case 415:
        throw UnsupportMediaTypeException(errorEtravel.message);
      case 500:
        throw InternetServerException(errorEtravel.message);
      case 501:
        throw NotImplementedException(errorEtravel.message);
      case 503:
        throw ServiceUnavailableException(errorEtravel.message);
      default:
        throw FetchDataException(
          'Error occured while communicating with server' +
              ' with status code' +
              response.statusCode.toString(),
        );
    }
  }

  @override
  Future getPutApiRepsonseAuth(String url, data) async {
    dynamic responseJson;
    String? accessToken;
    await SecureStorageService.getInstance
        .readSecureAccessToken()
        .then((value) => accessToken = value);
    try {
      final response = await http
          .put(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'text/plain',
              'Authorization': 'Bearer $accessToken',
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on FetchDataException {
      throw FetchDataException('No Internet Exception');
    }
    return responseJson;
  }
}
