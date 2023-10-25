import 'dart:convert';
import 'package:etravel_mobile/models/tour.dart';
import '../models/account.dart';
import '../models/place.dart';
import 'logger_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService getInstance = LocalStorageService();

  Future saveAccountInfo(Account account) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accountInfo = jsonEncode(account.toJson());
    sharedPreferences.setString('account', accountInfo);
  }

  Future savePlaceToCart(Place place) async {
    var cart = <Map<String, dynamic>>[];
    var listPlaces = <Place>[];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await getPlacesFromCart().then((placesFromStorage) {
      loggerInfo.i('placesFromStorage = ${placesFromStorage.length}');
      if (placesFromStorage.isEmpty) {
        cart.add(place.toJson());
        String encodeData = jsonEncode(cart);
        sharedPreferences.setString('cart', encodeData);
        loggerInfo.i('cart size = ${cart.length}');
      } else {
        listPlaces.add(place);
        for (var placeToAdd in placesFromStorage) {
          listPlaces.add(placeToAdd);
        }
        sharedPreferences.remove('cart');
        for (var element in listPlaces) {
          cart.add(element.toJson());
        }
        sharedPreferences.setString('cart', jsonEncode(cart));
        loggerInfo.i('cart size = ${cart.length}');
      }
    });
  }

  Future saveTourToCart(Tour tour) async {
    var cart = <Map<String, dynamic>>[];
    var listTours = <Tour>[];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await getToursFromCart().then((toursFromStorage) {
      loggerInfo.i('toursFromStorage = ${toursFromStorage.length}');
      if (toursFromStorage.isEmpty) {
        cart.add(tour.toJson());
        String encodeData = jsonEncode(cart);
        sharedPreferences.setString('cartTour', encodeData);
        loggerInfo.i('cart size = ${cart.length}');
      } else {
        listTours.add(tour);
        for (var tourToAdd in toursFromStorage) {
          listTours.add(tourToAdd);
        }
        sharedPreferences.remove('cartTour');
        for (var element in listTours) {
          cart.add(element.toJson());
        }
        sharedPreferences.setString('cartTour', jsonEncode(cart));
        loggerInfo.i('cart size = ${cart.length}');
      }
    });
  }

  Future saveLanguageCode(String languageCode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('languageCode', languageCode);
  }

  Future<String> getLanguageCode() async {
    late String languageCode;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    languageCode = sharedPreferences.getString('languageCode') ?? '';
    return languageCode;
  }

  Future<List<Place>> getPlacesFromCart() async {
    var cart = <Place>[];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var cartString = sharedPreferences.getString('cart');
    if (cartString != null) {
      var listPlaces = jsonDecode(cartString);
      listPlaces.forEach((v) {
        cart.add(Place.fromJson(v));
      });
    }
    return cart;
  }

  Future<List<Tour>> getToursFromCart() async {
    var cart = <Tour>[];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var cartString = sharedPreferences.getString('cartTour');
    if (cartString != null) {
      var listTours = jsonDecode(cartString);
      listTours.forEach((v) {
        cart.add(Tour.fromJson(v));
      });
    }
    return cart;
  }

  Future removeBookingItem() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('cart');
  }

  Future<Account?> getAccount() async {
    Account? account;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accountInfo = sharedPreferences.getString('account');
    if (accountInfo != null) {
      account = Account.fromJson(jsonDecode(accountInfo));
      loggerInfo.i(
          'Get account from local storage: ${account.firstName} ${account.lastName}');
    } else {
      loggerInfo.e('No account from storage');
    }
    return account;
  }

  Future removeAccountData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('account');
    Account? account = await getAccount();
    if (account == null) {
      loggerInfo.i('Clear account from storage successfully!');
    } else {
      loggerInfo.e('Clear account from storage unsuccessfully!');
    }
  }

  Future clearCart() async {
    var phone = '';
    var cartPlace = <Map<String, dynamic>>[];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await getAccount().then((account) => phone = account?.phone ?? '');
    sharedPreferences.setString('cartPlace$phone', jsonEncode(cartPlace));
  }

  Future addToCartPlace(Place bookingItem) async {
    var cart = <Map<String, dynamic>>[];
    var phone = '';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await getAccount().then((account) {
      phone = account?.phone ?? '';
    });
    cart.add(bookingItem.toJson());
    await getCartPlace().then((places) {
      if (places.isNotEmpty) {
        for (var item in places) {
          cart.add(item.toJson());
        }
      }
      sharedPreferences.setString('cartPlace$phone', jsonEncode(cart));
    });
  }

  Future<List<Place>> getCartPlace() async {
    var cart = <Place>[];
    var phone = '';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await getAccount().then((account) => phone = account?.phone ?? '');
    var cartString = sharedPreferences.getString('cartPlace$phone');
    if (cartString != null) {
      var listBookingItems = jsonDecode(cartString);
      listBookingItems.forEach((bookingItem) {
        var place = Place.fromJson(bookingItem);
        cart.add(place);
      });
    }
    return cart;
  }

  Future deletePlaceInCart(int placeId) async {
    var cartPlace = <Place>[];
    await getCartPlace().then((value) async {
      cartPlace = value;
      for (var place in cartPlace) {
        if (place.id == placeId) {
          cartPlace.remove(place);
          await updateCartPlace(cartPlace);
          break;
        }
      }
    });
  }

  Future updateCartPlace(List<Place> places) async {
    var phone = '';
    var newCartPlace = <Map<String, dynamic>>[];
    for (var place in places) {
      newCartPlace.add(place.toJson());
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await getAccount().then((account) => phone = account?.phone ?? '');
    await sharedPreferences.setString(
        'cartPlace$phone', jsonEncode(newCartPlace));
  }
}
