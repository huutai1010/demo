import 'package:etravel_mobile/res/app_color.dart';
import 'package:etravel_mobile/view/tour/tourvision_viewv2.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TourTrackingView extends StatefulWidget {
  const TourTrackingView({Key? key}) : super(key: key);

  @override
  _TourTrackingViewState createState() => _TourTrackingViewState();
}

class _TourTrackingViewState extends State<TourTrackingView> {
  List<String> places = [
    'Independence Palace',
    'Duc Ba Church',
    'City Opera House',
    'Ben Thanh Market',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          const TourVisionViewV2(),
          _getTracking(),
        ],
      ),
    );
  }

  Widget _getTracking() {
    return FractionallySizedBox(
      heightFactor: .5,
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Tour places',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              Column(
                children: List.generate(
                  places.length,
                  (index) => TimelineTile(
                    isFirst: (index == 0) ? true : false,
                    alignment: TimelineAlign.center,
                    endChild: Row(
                      children: [
                        const SizedBox(width: 15),
                        Text(places[index]),
                      ],
                    ),
                    indicatorStyle: IndicatorStyle(
                      color:
                          (index == 0) ? AppColors.primaryColor : Colors.grey,
                      iconStyle:
                          IconStyle(iconData: Icons.check, color: Colors.white),
                    ),
                    beforeLineStyle: LineStyle(
                      color:
                          (index == 0) ? AppColors.primaryColor : Colors.grey,
                      thickness: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
