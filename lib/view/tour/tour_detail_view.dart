import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/const/const.dart';
import 'package:etravel_mobile/models/feedback.dart';
import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/models/place_image.dart';
import 'package:etravel_mobile/view/booking/cart_view.dart';
import 'package:etravel_mobile/view_model/tour_detail_viewmodel.dart';

import '../../res/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import '../../services/local_storage_service.dart';
import '../successful/change_currency_popup.dart';

class TourDetailView extends StatefulWidget {
  final int id;
  final String name;
  final String description;
  final String image;
  final double price;
  final Map<String, double> exchanges;
  final List<Place> places;
  final List<PlaceImages> placeImages;
  final double rate;
  final List<FeedBacks> feedbacks;

  const TourDetailView({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.places,
    required this.placeImages,
    required this.price,
    required this.rate,
    required this.feedbacks,
    required this.exchanges,
  });
  @override
  State<StatefulWidget> createState() => _TourDetailViewState();
}

class _TourDetailViewState extends State<TourDetailView> {
  int _exchangeIndex = 0;
  bool isBooked = false;
  late Future<bool> isBookingItemData;

  final TourDetailViewModel tourDetailViewModel = TourDetailViewModel();

  @override
  void initState() {
    super.initState();
  }

  _onCurrencyChange() {
    showDialog<int>(
      context: context,
      builder: (context) {
        return ChangeCurrencyPopup(
          selectedIndex: _exchangeIndex,
        );
      },
    ).then((index) {
      if (index != null) {
        setState(() {
          _exchangeIndex = index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final exchangeKey = kCurrencies[_exchangeIndex]['key'] as String;
    final exchangePrice = widget.exchanges[exchangeKey] as double;
    final stringFormat = kCurrencies[_exchangeIndex]['format'] as String?;
    final decimal = kCurrencies[_exchangeIndex]['decimal'] as int;
    final exchangePriceString = stringFormat?.replaceAll(
            '{0}', exchangePrice.toStringAsFixed(decimal)) ??
        '';
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(alignment: AlignmentDirectional.bottomStart, children: [
                  TopImageSection(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    image: widget.image,
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 20 / 375),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        Row(
                          children: [
                            Text(
                              '${widget.rate}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const Icon(Icons.star_rounded,
                                size: 16, color: Color(0xFFFFB23F)),
                            Text(
                              '  .${widget.feedbacks.length} ${context.tr('reviews')}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
                InfoSection(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  description: widget.description,
                  places: widget.places,
                  placeImages: widget.placeImages,
                  rating: widget.rate,
                  feedbacks: widget.feedbacks,
                ),
              ],
            ),
          ),
          //),
          SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 20 / 375,
                    right: screenWidth * 20 / 375,
                    top: screenHeight * 40 / 812,
                  ),
                  child: Row(
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
                      GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const CartView())),
                          child: Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              width: 36,
                              height: 36,
                              child: const Icon(Icons.shopping_bag_outlined))),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _onCurrencyChange,
                        child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          width: 36,
                          height: 36,
                          child: Center(
                            child: Text(
                              exchangeKey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  height: screenHeight * 100 / 812,
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 30 / 375),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                '\$${widget.price}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                '/${context.tr('tour')}',
                                style: const TextStyle(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          if (_exchangeIndex != 0)
                            Row(
                              children: [
                                const Text(
                                  '(',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  exchangePriceString,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const Text(
                                  ')',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          await tourDetailViewModel.bookTour(
                              context, widget.places, widget.id, widget.price);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColors.primaryColor,
                          ),
                          width: screenWidth * 174 / 375,
                          height: screenHeight * 52 / 812,
                          alignment: Alignment.center,
                          child: Text(
                            context.tr('book_tour'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoSection extends StatelessWidget {
  const InfoSection({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.description,
    required this.places,
    required this.placeImages,
    required this.rating,
    required this.feedbacks,
  });

  final double screenWidth;
  final double screenHeight;
  final String description;
  final List<Place> places;
  final List<PlaceImages> placeImages;
  final double rating;
  final List<FeedBacks> feedbacks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 16 / 375,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 15 / 812),
          Row(
            children: [
              Text(
                context.tr('about'),
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.placeDetailTitleColor),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: screenHeight * 15 / 812),
          Text(
            description,
          ),
          SizedBox(height: screenHeight * 30 / 812),
          Row(
            children: [
              Text(
                context.tr('where_will_you_go'),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
            ],
          ),
          const Divider(),
          Column(
            children: List.generate(
              places.length,
              (index) => Container(
                margin: EdgeInsets.only(
                    top: index == 0 ? screenHeight * 20 / 812 : 0,
                    bottom: screenHeight * 20 / 812),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(places[index].image!),
                        ),
                      ),
                      width: screenWidth * 86 / 375,
                      height: screenWidth * 86 / 375,
                    ),
                    SizedBox(
                      width: screenWidth * 10 / 375,
                    ),
                    SizedBox(
                      height: screenHeight * 86 / 812,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            places[index].name!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
          SizedBox(height: screenHeight * 15 / 812),
          Row(
            children: [
              Text(
                context.tr('photos'),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: screenHeight * 15 / 812),
          Column(
            children: [
              StaggeredGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: [
                  Container(
                    width: screenWidth * 168 / 375,
                    height: screenHeight * 289 / 812,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            bottomLeft: Radius.circular(6)),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(placeImages[0].url!))),
                  ),
                  Container(
                    width: screenWidth * 168 / 375,
                    height: screenHeight * 144 / 812,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(6)),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(placeImages[1].url!))),
                  ),
                  Container(
                    width: screenWidth / 2,
                    height: screenHeight * 144 / 812,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(6)),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(placeImages[2].url!))),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 20 / 812),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    width: screenWidth * 156 / 375,
                    height: screenHeight * 42 / 812,
                    alignment: Alignment.center,
                    child: Text(
                      '${context.tr('see_all')} +${placeImages.length} ${context.tr('photos')}',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
              SizedBox(height: screenHeight * 30 / 812),
              feedbacks.isNotEmpty
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              context.tr('reviews'),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            const Spacer(),
                          ],
                        ),
                        Row(
                          children: [
                            Text('$rating'),
                            const Icon(Icons.star_rounded,
                                size: 16, color: Color(0xFFFFB23F)),
                            Text(
                                ' (${feedbacks.length} ${context.tr('reviews')})'),
                            const Spacer(),
                          ],
                        ),
                        SizedBox(height: screenHeight * 15 / 812),
                      ],
                    )
                  : Container(),
            ],
          ),
          Center(
            child: Column(
              children: List.generate(
                feedbacks.length,
                (index) => FeedbackItem(
                  firstName: feedbacks[index].firstName,
                  lastName: feedbacks[index].lastName,
                  image: feedbacks[index].image,
                  nationalImage: feedbacks[index].nationalImage,
                  content: feedbacks[index].content,
                  createTime: feedbacks[index].createTime,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  rating: rating,
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 50))
        ],
      ),
    );
  }
}

class FeedbackItem extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? image;
  final String? nationalImage;
  final String? content;
  final String? createTime;
  final double? rating;
  const FeedbackItem({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    this.firstName,
    this.lastName,
    this.image,
    this.nationalImage,
    this.content,
    this.createTime,
    this.rating,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  State<FeedbackItem> createState() => _FeedbackItemState();
}

class _FeedbackItemState extends State<FeedbackItem> {
  bool _isTranslating = false;
  @override
  void initState() {
    super.initState();
  }

  Future<String> translate(String originalContent) async {
    if (!_isTranslating) {
      return originalContent;
    }
    final account = await LocalStorageService.getInstance.getAccount();
    final translatingLanguage = account!.languageCode!.split('-')[0];

    final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.9);

    final List<IdentifiedLanguage> possibleLanguages =
        await languageIdentifier.identifyPossibleLanguages(originalContent);

    await languageIdentifier.close();

    final correctLanguage = possibleLanguages[0];

    final TranslateLanguage targetLanguage =
        BCP47Code.fromRawValue(translatingLanguage)!;

    final TranslateLanguage sourceLanguage =
        BCP47Code.fromRawValue(correctLanguage.languageTag)!;

    final onDeviceTranslator = OnDeviceTranslator(
        sourceLanguage: sourceLanguage, targetLanguage: targetLanguage);

    final response = await onDeviceTranslator.translateText(originalContent);

    await onDeviceTranslator.close();

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.screenHeight * 20 / 812),
      decoration: BoxDecoration(
        border: Border.all(
          width: .5,
          color: AppColors.searchBorderColor.withOpacity(.5),
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      width: widget.screenWidth * 327 / 375,
      height: widget.screenHeight * 199 / 812,
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(
            top: widget.screenHeight * 10 / 812,
            left: widget.screenWidth * 10 / 375,
            bottom: widget.screenHeight * 10 / 812),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(widget.image ??
                                  'https://images.unsplash.com/photo-1527980965255-d3b416303d12?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8YXZhdGFyfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60'))),
                      width: widget.screenWidth * 35 / 375,
                      height: widget.screenWidth * 35 / 375,
                    ),
                    Positioned(
                      child: SizedBox(
                        width: 20,
                        height: 15,
                        child: Image.network(
                          widget.nationalImage ??
                              'https://images.unsplash.com/photo-1527980965255-d3b416303d12?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8YXZhdGFyfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: widget.screenWidth * 10 / 375),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          (widget.firstName ?? 'Jack'),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(widget.lastName ?? ' Daniel',
                            style: const TextStyle(fontWeight: FontWeight.w500))
                      ],
                    ),
                    Row(
                      children: [
                        Row(children: [
                          Text('${widget.rating}'),
                          const Icon(Icons.star_rounded,
                              size: 16, color: Color(0xFFFFB23F))
                        ]),
                        SizedBox(width: widget.screenWidth * 10 / 375),
                        Text(widget.createTime != null
                            ? widget.createTime!.substring(0, 10)
                            : ' .23 July 2023'),
                      ],
                    ),
                  ],
                )
              ],
            ),
            FutureBuilder(
              future: translate(widget.content!),
              builder: (ctx, snapshot) => Text(
                (snapshot.hasData ? snapshot.data : widget.content!) ??
                    'Lorem ipsum dolor sit amet, consectetur \nadipiscing elit. Etiam tellus in pretium \ndignissim ',
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isTranslating = !_isTranslating;
                });
              },
              child: Text(
                _isTranslating
                    ? context.tr('view_source')
                    : context.tr('translate'),
                style: TextStyle(color: Colors.black.withOpacity(.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopImageSection extends StatelessWidget {
  const TopImageSection({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.image,
  });

  final double screenWidth;
  final double screenHeight;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(image),
        ),
      ),
      width: screenWidth,
      height: screenHeight * 324 / 812,
    );
  }
}
