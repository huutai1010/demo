import 'package:etravel_mobile/res/app_color.dart';
import 'package:etravel_mobile/view/voice/voice_view.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TourTrackingViewV2 extends StatefulWidget {
  const TourTrackingViewV2({super.key});

  @override
  State<TourTrackingViewV2> createState() => _TourTrackingViewV2State();
}

class _TourTrackingViewV2State extends State<TourTrackingViewV2> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.7950, 106.7218),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('Track journey'),
        leading: const BackButton(),
      ),
      backgroundColor: Colors.grey,
      body: Stack(
        children: [
          const GoogleMap(initialCameraPosition: _kGooglePlex),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .6,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Journey 1',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          const Spacer(),
                          Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryColor),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const VoiceView(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.music_video,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      const Text(
                        '4 places . 4hr 30 mins . 20km',
                        style: TextStyle(color: Color(0xFFA0A5BA)),
                      ),
                      const Divider(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              5,
                              (index) => TimelineTile(
                                isFirst: (index == 0) ? true : false,
                                alignment: TimelineAlign.manual,
                                lineXY: 0.03,
                                endChild: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: index == 0
                                      ? const Row(
                                          children: [
                                            Text('Content'),
                                            Spacer(),
                                            Text(
                                              '12:10 AM',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        )
                                      : const Text('Content'),
                                ),
                                indicatorStyle: IndicatorStyle(
                                  color: (index == 0)
                                      ? AppColors.primaryColor
                                      : Colors.grey,
                                  iconStyle: IconStyle(
                                      iconData: Icons.check,
                                      color: Colors.white),
                                ),
                                beforeLineStyle: LineStyle(
                                  color: (index == 0)
                                      ? AppColors.primaryColor
                                      : Colors.grey,
                                  thickness: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(8)),
                          alignment: Alignment.center,
                          height: 50,
                          child: const Text(
                            'Start Journey',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
