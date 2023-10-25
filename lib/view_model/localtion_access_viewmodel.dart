import '../services/location_service.dart';
import '../services/logger_service.dart';
import '../view/onboarding/onboarding_view.dart';
import 'package:flutter/material.dart';

class LocationAccessViewModel {
  Future handleAccessLocation(BuildContext context) async {
    bool isAllowed = false;
    await LocationService.getInstance
        .grantAccessCurrentLocation()
        .then((locationPermission) {
      isAllowed = locationPermission;
      loggerInfo.i('isAllowed = $isAllowed');
      if (isAllowed) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const OnboardingView(),
          ),
        );
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Some thing went wrong'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('Try again'),
              ),
            ],
          ),
        );
      }
    });
  }
}
