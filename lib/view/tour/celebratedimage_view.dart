import 'package:etravel_mobile/const/const.dart';
import 'package:etravel_mobile/repository/booking_repository.dart';
import 'package:flutter/material.dart';

import '../../models/place.dart';
import '../../widgets/celebrate_item.dart';
import '../common/common_app_bar.dart';

class CelebratedImageView extends StatelessWidget {
  final int bookingId;
  const CelebratedImageView({
    super.key,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        appBar: AppBar(),
        title: Text(
          'Celebrated place images',
          style: titleTextStyle.copyWith(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: FutureBuilder(
          future: BookingRepository().getCelebratedImages(bookingId),
          builder: (ctx, snapshot) {
            final placesData = (snapshot.data?['places'] as List?);
            final places = placesData
                    ?.map((e) => Place.fromJson(e))
                    .where((element) => (element.placeImages ?? []).isNotEmpty)
                    .toList() ??
                [];
            return ListView.builder(
              itemCount: places.length,
              itemBuilder: (c, i) => Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: CelebrateItem(
                  place: places[i],
                  time: DateTime.parse(
                    placesData?[i]['startTime'],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
