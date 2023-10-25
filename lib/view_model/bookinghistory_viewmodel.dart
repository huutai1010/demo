import 'package:flutter/material.dart';

class BookingHistoryViewModel extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
