import 'package:etravel_mobile/models/feedback.dart';
import 'package:etravel_mobile/models/place_image.dart';

class Place {
  String? name;
  String? description;
  String? image;
  double? price;
  Map<String, double>? exchanges;
  double? entryTicket;
  double? rate;
  double? longitude;
  double? latitude;
  String? googlePlaceId;
  String? daysOfWeek;
  String? openTime;
  String? endTime;
  bool? isFavorite;
  List<PlaceImages>? placeImages;
  List<FeedBacks>? feedBacks;
  int? id;

  Place({
    this.name,
    this.description,
    this.image,
    this.price,
    this.entryTicket,
    this.rate,
    this.exchanges,
    this.longitude,
    this.latitude,
    this.googlePlaceId,
    this.daysOfWeek,
    this.openTime,
    this.endTime,
    this.placeImages,
    this.feedBacks,
    this.isFavorite,
    this.id,
  });

  Place.fromJson(Map<String, dynamic> jsonData) {
    name = jsonData['name'] ?? jsonData['placeName'];
    description = jsonData['description'];
    image = jsonData['image'];
    price = jsonData['price'];
    entryTicket = jsonData['entryTicket'];
    rate = jsonData['rate'];
    exchanges = (jsonData['exchanges'] as Map<String, dynamic>?)?.map(
      (key, value) => MapEntry(key, value),
    );
    longitude = jsonData['longitude'];
    latitude = jsonData['latitude'];
    googlePlaceId = jsonData['googlePlaceId'];
    daysOfWeek = jsonData['daysOfWeek'];
    openTime = jsonData['openTime'];
    endTime = jsonData['endTime'];
    isFavorite = jsonData['isFavorite'];
    if (jsonData['placeImages'] != null) {
      placeImages = <PlaceImages>[];
      jsonData['placeImages'].forEach((v) {
        placeImages!.add(PlaceImages.fromJson(v));
      });
    } else if (jsonData['celebrateImages'] != null) {
      placeImages = <PlaceImages>[];
      jsonData['celebrateImages'].forEach((v) {
        placeImages!.add(PlaceImages.fromJson(v));
      });
    }
    if (jsonData['feedBacks'] != null) {
      feedBacks = <FeedBacks>[];
      jsonData['feedBacks'].forEach((v) {
        feedBacks!.add(FeedBacks.fromJson(v));
      });
    }
    id = jsonData['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['price'] = price;
    data['entryTicket'] = entryTicket;
    data['rate'] = rate;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['googlePlaceId'] = googlePlaceId;
    data['daysOfWeek'] = daysOfWeek;
    data['openTime'] = openTime;
    data['endTime'] = endTime;
    if (placeImages != null) {
      data['placeImages'] = placeImages!.map((v) => v.toJson()).toList();
    }
    if (feedBacks != null) {
      data['feedBacks'] = feedBacks!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }
}
