import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import '../../res/app_color.dart';
import '../../view_model/searchresult_viewmodel.dart';

class TourVisionViewV2 extends StatefulWidget {
  const TourVisionViewV2({super.key});

  @override
  State<TourVisionViewV2> createState() => _TourVisionViewV2State();
}

class _TourVisionViewV2State extends State<TourVisionViewV2> {
  final Completer<GoogleMapController> _controller = Completer();
  final SearchResultViewModel _searchResultViewModel = SearchResultViewModel();
  final CameraPosition _kGooglepPlex =
      const CameraPosition(target: LatLng(10.7725, 106.6980), zoom: 14);
  List<Map<String, String>> samples = [
    {
      'name': 'Cho Ben Thanh',
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/9/91/Ben_Thanh_market_2.jpg',
    },
    {
      'name': 'Emart Sala',
      'image': 'https://offer.rever.vn/hubfs/Emart3.png',
    },
    {
      'name': 'Landmark 81',
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRdDH0os3QPAna447GB_aG-9j_a9sxp_YgeWl2XK_8L4fQ0iyPYhMT0tgcycILNsbCq5XY&usqp=CAU',
    },
    {
      'name': 'SaiGon Zoo',
      'image':
          'https://statics.vinpearl.com/saigon-zoo-and-botanical-gardens-01_1676987129.jpg',
    },
    {
      'name': 'Independence Place',
      'image':
          'https://dulichvietnam.com.vn/vnt_upload/news/04_2023/dinh_doc_lap7.jpg',
    },
  ];

  static var _options = [
    "Open time",
    "Traffic",
    "Distance",
    "Weather",
    "Rating",
  ];

  final _items = _options.map((e) => MultiSelectItem<String>(e, e)).toList();

  @override
  void initState() {
    super.initState();

    loadData();
  }

  loadData() async {
    //await _searchResultViewModel.loadMarkerData();
    setState(() {});
  }

  void _showMultiSelect(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
            items: _items, initialValue: _options, onConfirm: (values) {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _showMultiSelect(context);
              },
              icon: const Icon(Icons.check_box))
        ],
      ),
      body: GoogleMap(
        polylines: _searchResultViewModel.getSamplePolylines(),
        markers: Set.of(_searchResultViewModel.markers),
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _kGooglepPlex,
        onMapCreated: (controller) {
          _controller.complete(controller);
        },
      ),
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
                  'Places',
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
    );
  }
}
