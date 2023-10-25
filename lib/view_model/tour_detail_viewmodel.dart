import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/view/payment/choosepayment_view.dart';
import 'package:flutter/material.dart';

class TourDetailViewModel with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future bookTour(BuildContext context, List<Place> places, int tourId,
      double price) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ChoosePaymentView(places: places, tourId: tourId, price: price),
      ),
    );
  }
}
