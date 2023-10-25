import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/models/feedback.dart';
import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/models/place_image.dart';
import 'package:etravel_mobile/repository/place_repository.dart';
import 'package:etravel_mobile/res/app_color.dart';
import 'package:etravel_mobile/view/booking/cart_view.dart';
import 'package:etravel_mobile/view/successful/change_currency_popup.dart';
import 'package:etravel_mobile/view_model/place_detail_viewmodel.dart';
import 'package:etravel_mobile/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hidable/hidable.dart';
import 'package:readmore/readmore.dart';

import '../../const/const.dart';
import '../../widgets/feedback_list.dart';

// ignore: must_be_immutable
class PlaceDetailsViewV2 extends StatefulWidget {
  int placeId;
  PlaceDetailsViewV2({
    required this.placeId,
    super.key,
  });

  @override
  State<PlaceDetailsViewV2> createState() => _PlaceDetailsViewV2State();
}

class _PlaceDetailsViewV2State extends State<PlaceDetailsViewV2> {
  double _exchangePrice = 0;
  int _exchangeIndex = 0;
  bool isBooked = false;
  final Completer<GoogleMapController> _controller = Completer();
  final ScrollController scrollController = ScrollController();
  final PageController controller = PageController();
  final placeDetailViewModel = PlaceDetailViewModel();
  late Future<Place?> placeData;
  late Future<bool> isBookingItemData;
  late Place place;
  int pageValue = 0;
  var style1 = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  var style2 = const TextStyle(color: AppColors.placeDetailTitleColor);
  var style4 = const TextStyle(fontSize: 10, color: AppColors.grayTextColor);
  var style5 = const TextStyle(fontWeight: FontWeight.bold);
  var style6 = const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  var space1 = const SizedBox(height: 5);
  var space2 = const SizedBox(height: 20);
  var space3 = const SizedBox(height: 10);
  var style3 = const TextStyle(
    fontSize: 12,
    color: AppColors.placeDetailTitleColor,
  );
  var style8 = const TextStyle(
    color: AppColors.primaryColor,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );
  var style9 = const TextStyle(color: AppColors.primaryColor, fontSize: 12);
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.7950, 106.7218),
    zoom: 14,
  );

  void _toggleFavorite(int placeId) async {
    await PlaceRepository().postFavoritePlace(placeId);
    setState(() {
      place.isFavorite = !(place.isFavorite ?? false);
    });
  }

  @override
  void initState() {
    placeData = placeDetailViewModel.getPlaceDetails(widget.placeId);
    isBookingItemData = placeDetailViewModel.isBookingPlace(widget.placeId);
    placeData.then((value) {
      if (value != null) {
        place = value;
        loadData();
      }
    });

    isBookingItemData.then((value) => isBooked = value);
    super.initState();
  }

  void _onCurrencyChange(int selectedExchangeIndex) {
    setState(() {
      _exchangeIndex = selectedExchangeIndex;
      if (_exchangeIndex != 0) {
        _exchangePrice =
            place.exchanges![kCurrencies[selectedExchangeIndex]['key']]!;
      }
    });
  }

  void loadData() async {
    await placeDetailViewModel.loadMarkerData(place, context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Place?>(
        future: placeData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    _buildAppBar(
                      context,
                      place.placeImages!,
                      place.isFavorite ?? false,
                      () => _toggleFavorite(place.id!),
                      (selectedIndex) => _onCurrencyChange(selectedIndex),
                    ),
                    _buildPlaceInfos(
                      place.name!,
                      place.entryTicket!,
                      place.description!,
                      place.openTime!,
                      place.endTime!,
                      place.rate ?? 0.0,
                      place.feedBacks!,
                      placeDetailViewModel.markers,
                    ),
                    FeedbackList(
                      feedbacks: place.feedBacks ?? [],
                    ),
                  ],
                ),
                _buildBookingButton(
                    place.price!, _exchangePrice, _exchangeIndex),
              ],
            );
          } else {
            return const LoadingIndicator();
          }
        },
      ),
    );
  }

  Column _buildBookingButton(
      double price, double exchangePrice, int exchangeIndex) {
    final stringFormat = kCurrencies[exchangeIndex]['format'] as String?;
    final decimal = kCurrencies[exchangeIndex]['decimal'] as int;
    final exchangePriceString = stringFormat?.replaceAll(
            '{0}', exchangePrice.toStringAsFixed(decimal)) ??
        '';

    final exchangePriceTextStyle =
        style8.copyWith(color: Colors.black, fontSize: 14);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Hidable(
          preferredWidgetSize: const Size.fromHeight(74),
          controller: scrollController,
          child: Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                offset: const Offset(0, -2),
                color: Colors.grey.withOpacity(.5),
                spreadRadius: 1,
                blurRadius: 3,
              ),
            ]),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('\$$price', style: style8),
                            Text('/Voice', style: style9),
                          ],
                        ),
                        if (exchangeIndex != 0 &&
                            exchangePriceString.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('(', style: exchangePriceTextStyle),
                              Text(exchangePriceString,
                                  style: exchangePriceTextStyle),
                              Text(')', style: exchangePriceTextStyle),
                            ],
                          )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FutureBuilder<bool>(
                        future: isBookingItemData,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return GestureDetector(
                              onTap: isBooked
                                  ? null
                                  : () async {
                                      await placeDetailViewModel.addPlaceToCart(
                                          place, context);
                                      isBooked = true;
                                      setState(() {});
                                    },
                              child: Container(
                                margin: const EdgeInsets.only(right: 20),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: isBooked
                                      ? Colors.grey
                                      : AppColors.primaryColor,
                                ),
                                width: 173,
                                height: 52,
                                child: Text('Book Place',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: isBooked
                                          ? Colors.black
                                          : Colors.white,
                                    )),
                              ),
                            );
                          }
                          return const CircularProgressIndicator();
                        }),
                  )
                ]),
          ),
        ),
      ],
    );
  }

  SliverList _buildPlaceInfos(
    String name,
    double entryTicket,
    String description,
    String openTime,
    String closeTime,
    double rate,
    List<FeedBacks> listFeedbacks,
    List<Marker> markers,
  ) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 1,
        (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: style1),
                    const Spacer(),
                  ],
                ),
                space1,
                Text('Ho Chi Minh City', style: style2),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(entryTicket > 0 ? '\$50' : context.tr('free_ticket'),
                        style: style1),
                    Text(entryTicket > 0 ? '/${context.tr('ticket')}' : '',
                        style: style2),
                  ],
                ),
                space1,
                ReadMoreText(description,
                    trimLines: 5,
                    style: style3,
                    trimCollapsedText: context.tr('read_all')),
                space2,
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: AppColors.gray7,
                      ),
                      width: 38,
                      height: 38,
                      child: const Icon(Icons.location_on_rounded,
                          color: AppColors.primaryColor),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Viet Nam', style: style4),
                        Text('District 1, HCM City', style: style5)
                      ],
                    )
                  ],
                ),
                space3,
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: AppColors.gray7,
                      ),
                      width: 38,
                      height: 38,
                      child: const Icon(Icons.access_time_filled,
                          color: AppColors.primaryColor),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.tr('open'), style: style4),
                        Text(openTime, style: style5)
                      ],
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.tr('close'), style: style4),
                        Text(closeTime, style: style5)
                      ],
                    )
                  ],
                ),
                Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(context.tr('location'), style: style6)),
                SizedBox(
                  height: 200,
                  child: GoogleMap(
                    markers: Set.of(markers),
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(place.latitude!, place.longitude!),
                      zoom: 14,
                    ),
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
                listFeedbacks.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(top: 20, bottom: 5),
                              child:
                                  Text(context.tr('reviews'), style: style6)),
                          Row(
                            children: [
                              Text('$rate'),
                              const Icon(Icons.star_rounded,
                                  size: 16, color: Color(0xFFFFB23F)),
                              Text(
                                  '  (${listFeedbacks.length} ${context.tr('reviews')})',
                                  style: style2),
                            ],
                          ),
                        ],
                      )
                    : const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  SliverAppBar _buildAppBar(
      BuildContext context,
      List<PlaceImages> listPlaceImages,
      bool isFavorite,
      Function() onToggleFavorite,
      Function(int) onCurrencyChange) {
    return SliverAppBar(
      pinned: false,
      backgroundColor: Colors.white38,
      leading: const BackButton(),
      actions: [
        IconButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const CartView())),
            icon: const Icon(Icons.shopping_bag_outlined)),
        IconButton(
          onPressed: onToggleFavorite,
          icon: isFavorite
              ? const Icon(
                  Icons.favorite,
                  color: Colors.red,
                )
              : const Icon(Icons.favorite_outline_outlined),
        ),
        GestureDetector(
          onTap: () {
            showDialog<int>(
              context: context,
              builder: (context) {
                return ChangeCurrencyPopup(
                  selectedIndex: _exchangeIndex,
                );
              },
            ).then((index) {
              if (index != null) {
                onCurrencyChange(index);
              }
            });
          },
          child: Center(
            child: Text(
              kCurrencies[_exchangeIndex]['key'] as String,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
      ],
      flexibleSpace: FlexibleSpaceBar(
          background: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          PageView(
            controller: controller,
            onPageChanged: (value) {
              pageValue = value;
              setState(() {});
            },
            children: List.generate(
              listPlaceImages.length,
              (index) => ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Colors.grey.withOpacity(.5), BlendMode.darken),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(listPlaceImages[index].url!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10, bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white54),
            child: Text('${pageValue + 1}/${listPlaceImages.length}',
                style: const TextStyle(fontSize: 16)),
          )
        ],
      )),
      expandedHeight: MediaQuery.of(context).size.height * .4,
    );
  }
}
