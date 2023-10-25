import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../res/app_color.dart';

class TourVisionView extends StatefulWidget {
  const TourVisionView({super.key});

  @override
  State<TourVisionView> createState() => _TourVisionViewState();
}

class _TourVisionViewState extends State<TourVisionView> {
  final Set<Polyline> _polyline = {};

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.7950, 106.7218),
    zoom: 14.4746,
  );

  final List<Marker> _listSampleMarker = const [
    // Chợ Bến Thành
    Marker(
      markerId: MarkerId("1"),
      position: LatLng(10.7725, 106.6980),
      infoWindow: InfoWindow(title: 'My current location'),
    ),
    // Dinh Độc Lập
    Marker(
      markerId: MarkerId("2"),
      position: LatLng(10.7770, 106.6953),
      infoWindow: InfoWindow(title: 'My current location'),
    ),
    // Thảo cầm viên Sài Gòn
    Marker(
      markerId: MarkerId("3"),
      position: LatLng(10.7875, 106.7053),
      infoWindow: InfoWindow(title: 'My current location'),
    ),
    // Landmark 81
    // Marker(
    //   markerId: MarkerId("4"),
    //   position: LatLng(10.7950, 106.7218),
    //   infoWindow: InfoWindow(title: 'My current location'),
    // ),
    // Bao tang chien tranh
    Marker(
      markerId: MarkerId("5"),
      position: LatLng(10.779509, 106.692091),
      infoWindow: InfoWindow(title: 'My current location'),
    ),
    // Dinh Doc Lap
    Marker(
      markerId: MarkerId("6"),
      position: LatLng(10.776988, 106.695299),
      infoWindow: InfoWindow(title: 'My current location'),
    ),
  ];

  List<Map<String, String>> samples = [
    {
      'name': 'Independence Place',
      'image':
          'https://dulichvietnam.com.vn/vnt_upload/news/04_2023/dinh_doc_lap7.jpg',
    },
    {
      'name': 'Cho Ben Thanh',
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/9/91/Ben_Thanh_market_2.jpg',
    },
    {
      'name': 'Ho Con Rua',
      'image':
          'https://cdn3.ivivu.com/2022/10/h%E1%BB%93-con-r%C3%B9a-ivivu-12.jpg',
    },
    {
      'name': 'Katinat Cafe',
      'image':
          'https://1.bp.blogspot.com/-ICSdCAUxjW0/YFgYLCpcigI/AAAAAAAAKIE/6YhFpo3n8NMnCB4OhzxHUkgh1qDPQEp3QCLcBGAsYHQ/w1200-h630-p-k-no-nu/1.jpg',
    },
  ];

  @override
  void initState() {
    List<LatLng> listPosition = [];
    for (var i = 0; i < _listSampleMarker.length; i++) {
      listPosition.add(_listSampleMarker[i].position);
    }
    _polyline.add(Polyline(
      polylineId: PolylineId('1'),
      points: listPosition,
      color: Colors.orange,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: FractionallySizedBox(
        heightFactor: .65,
        widthFactor: .6,
        child: Drawer(
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mange place order',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: FractionallySizedBox(
                    widthFactor: .9,
                    child: ListView.builder(
                      itemCount: samples.length,
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(samples[index]['image']!),
                                ),
                              ),
                              margin: const EdgeInsets.only(bottom: 15),
                            ),
                            const SizedBox(width: 15),
                            Flexible(
                              child: Text(samples[index]['name']!, maxLines: 2),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.primaryColor,
                  ),
                  alignment: Alignment.center,
                  width: 150,
                  height: 40,
                  child: const Text(
                    'CONFIRM',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.of(_listSampleMarker),
        polylines: _polyline,
      ),
    );
  }
}
