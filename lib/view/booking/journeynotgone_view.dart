import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/res/app_color.dart';
import 'package:flutter/material.dart';

class JourneyNotGoneView extends StatelessWidget {
  const JourneyNotGoneView({super.key});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage('assets/images/background/empty_journey.png'),
                  fit: BoxFit.cover,
                ),
              ),
              width: 180,
              height: 180,
            ),
            const SizedBox(height: 25),
            Text(
              context.tr('you_donot_have_journey_yet'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              context.tr('create_a_journey_now'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.primaryColor,
                ),
                width: MediaQuery.of(context).size.width * .8,
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  context.tr('create_journey'),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
