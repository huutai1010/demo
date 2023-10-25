import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/feedback.dart';
import '../../models/place.dart';
import '../../models/place_image.dart';
import '../../res/app_color.dart';
import '../tour/tour_detail_view.dart';
import '../../view_model/place_detail_viewmodel.dart';
import 'package:flutter/material.dart';

const currencies = [
  {'key': 'USD', 'name': 'USD', 'icon': 'usd'},
  {'key': 'VND', 'name': 'VND', 'icon': 'vnd'},
  {'key': 'JPY', 'name': 'JPY', 'icon': 'jpy'},
  {'key': 'CNH', 'name': 'CNH', 'icon': 'cnh'},
];

class PlaceDetailView extends StatefulWidget {
  final int id;
  final String name;
  final String description;
  final double price;
  final Map<String, double> exchanges;
  final double entryTicket;
  final double rate;
  final String openTime;
  final String endTime;
  final List<PlaceImages> placeImages;
  final List<FeedBacks> feedbacks;

  const PlaceDetailView({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.exchanges,
    required this.entryTicket,
    required this.rate,
    required this.openTime,
    required this.endTime,
    required this.placeImages,
    required this.feedbacks,
    super.key,
  });

  @override
  State<PlaceDetailView> createState() => _PlaceDetailViewState();
}

class _PlaceDetailViewState extends State<PlaceDetailView> {
  final Completer<GoogleMapController> _controller = Completer();
  final PlaceDetailViewModel placeDetailViewModel = PlaceDetailViewModel();
  String _selectedCurrency = currencies[0]['key']!;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        colorFilter: const ColorFilter.mode(
                            Colors.black12, BlendMode.darken),
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.placeImages[0].url!),
                      ),
                    ),
                    width: screenWidth,
                    height: screenHeight * 324 / 812,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 16 / 375),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 15 / 812),
                        Row(
                          children: [
                            Text(
                              widget.name,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.placeDetailTitleColor),
                            ),
                            const Spacer(),
                            DropdownButton(
                              items: currencies.map((currency) {
                                final value = currency['key']!;
                                return DropdownMenuItem(
                                  key: ValueKey(value),
                                  value: value,
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/currency/${currency['icon']}.jpg',
                                        width: 30,
                                        height: 30,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(currency['name']!)
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCurrency = value!;
                                });
                              },
                              value: _selectedCurrency,
                            ),
                          ],
                        ),
                        Text(
                          'Ho Chi Minh City',
                          style: TextStyle(
                              color: AppColors.grayTextColor.withOpacity(.5)),
                        ),
                        SizedBox(height: screenHeight * 15 / 812),
                        Row(
                          children: [
                            Text(
                              '\$${widget.price}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppColors.placeDetailTitleColor,
                              ),
                            ),
                            Text(
                              '/${context.tr('voice')}',
                              style: TextStyle(
                                  color:
                                      AppColors.grayTextColor.withOpacity(.5)),
                            ),
                            if (_selectedCurrency != 'USD') ...[
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '(',
                                style: TextStyle(
                                    color: AppColors.grayTextColor
                                        .withOpacity(.5)),
                              ),
                              Text(
                                '${widget.exchanges[_selectedCurrency]} ${NumberFormat.simpleCurrency(name: _selectedCurrency).currencySymbol}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.placeDetailTitleColor,
                                ),
                              ),
                              Text(
                                ')',
                                style: TextStyle(
                                    color: AppColors.grayTextColor
                                        .withOpacity(.5)),
                              ),
                            ]
                          ],
                        ),
                        Text(
                          widget.description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          style: TextStyle(
                              color: AppColors.grayTextColor.withOpacity(.5)),
                        ),
                        SizedBox(height: screenHeight * 5 / 375),
                        Row(
                          children: [
                            SizedBox(
                              width: screenWidth * 38 / 375,
                              height: screenWidth * 38 / 375,
                              child: Image.asset(
                                  'assets/images/place/location.png'),
                            ),
                            SizedBox(
                              width: screenWidth * 15 / 375,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Viet Nam',
                                  style: TextStyle(
                                      color: AppColors.grayTextColor
                                          .withOpacity(.5)),
                                ),
                                const Text(
                                  'District 1, HCM City',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.placeTimeTextColor),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: screenHeight * 5 / 375),
                        Row(
                          children: [
                            SizedBox(
                              width: screenWidth * 38 / 375,
                              height: screenWidth * 38 / 375,
                              child:
                                  Image.asset('assets/images/place/time.png'),
                            ),
                            SizedBox(
                              width: screenWidth * 15 / 375,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Open',
                                  style: TextStyle(
                                      color: AppColors.grayTextColor
                                          .withOpacity(.5)),
                                ),
                                Text(
                                  widget.openTime,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.placeTimeTextColor),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: screenHeight * 5 / 375),
                        Row(
                          children: [
                            SizedBox(
                              width: screenWidth * 38 / 375,
                              height: screenWidth * 38 / 375,
                              child:
                                  Image.asset('assets/images/place/time.png'),
                            ),
                            SizedBox(
                              width: screenWidth * 15 / 375,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.tr('ticket'),
                                  style: TextStyle(
                                      color: AppColors.grayTextColor
                                          .withOpacity(.5)),
                                ),
                                Text(
                                  '\$${widget.entryTicket}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.placeTimeTextColor),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 5 / 375),
                  Center(
                    child: SizedBox(
                      width: screenWidth * 324 / 375,
                      height: screenHeight * 201 / 812,
                      child: GoogleMap(
                        markers: {
                          const Marker(
                              markerId: MarkerId('points'),
                              position: LatLng(10.7725, 106.6980))
                        },
                        initialCameraPosition: const CameraPosition(
                            target: LatLng(10.7725, 106.6980), zoom: 14),
                        onMapCreated: (controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 25 / 375),
                  Center(
                    child: Column(
                      children: List.generate(
                        widget.feedbacks.length,
                        (index) => FeedbackItem(
                            firstName: widget.feedbacks[index].firstName,
                            lastName: widget.feedbacks[index].lastName,
                            image: widget.feedbacks[index].image,
                            nationalImage:
                                widget.feedbacks[index].nationalImage,
                            content: widget.feedbacks[index].content,
                            createTime: widget.feedbacks[index].createTime,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 90 / 812,
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 45 / 812,
              left: screenWidth * 20 / 375,
              right: screenWidth * 20 / 375,
            ),
            child: SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          width: screenWidth * 36 / 375,
                          height: screenWidth * 36 / 375,
                          child: const Icon(Icons.arrow_back),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        width: screenWidth * 36 / 375,
                        height: screenWidth * 36 / 375,
                        child: const Icon(
                          Icons.favorite_border,
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      await placeDetailViewModel.addPlaceToCart(
                        Place(
                          image: widget.placeImages[0].url,
                          description: widget.description,
                          price: widget.price,
                          name: widget.name,
                          id: widget.id,
                        ),
                        context,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.primaryColor,
                      ),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(
                        bottom: screenHeight * 40 / 812,
                      ),
                      width: screenWidth * 278 / 375,
                      height: screenHeight * 43 / 812,
                      child: Text(
                        context.tr('add_to_tour'),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
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
    );
  }
}
