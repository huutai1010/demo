import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/view/tour/tour_tracking_viewv2.dart';
import 'package:flutter/material.dart';

class JourneyCurrentlyGoneView extends StatefulWidget {
  const JourneyCurrentlyGoneView({super.key});

  @override
  State<JourneyCurrentlyGoneView> createState() =>
      _JourneyCurrentlyGoneViewState();
}

class _JourneyCurrentlyGoneViewState extends State<JourneyCurrentlyGoneView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const TourTrackingViewV2())),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image:
                          AssetImage('assets/images/background/ho_con_rua.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: 120,
                  height: 145,
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      'Hành trình 1',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 15),
                    const Row(
                      children: [
                        Icon(
                          Icons.access_time_filled_outlined,
                          color: Color(0xFFFC820A),
                        ),
                        SizedBox(width: 5),
                        Text('5 giờ 30 phút')
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.store_rounded,
                          color: Color(0xFF1A94FF),
                        ),
                        const SizedBox(width: 5),
                        Text('2/3 ${context.tr('places')}')
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
