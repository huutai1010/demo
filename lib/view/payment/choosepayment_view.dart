// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:etravel_mobile/models/place.dart';
import 'package:etravel_mobile/repository/booking_repository.dart';
import 'package:etravel_mobile/view/payment/payment_processing_view.dart';

import '../../res/app_color.dart';

class ChoosePaymentView extends StatefulWidget {
  int? tourId;
  List<Place> places;
  bool isCustomTour;
  double price;
  ChoosePaymentView({
    Key? key,
    this.tourId,
    required this.places,
    this.isCustomTour = false,
    required this.price,
  }) : super(key: key);

  @override
  State<ChoosePaymentView> createState() => _ChoosePaymentViewState();
}

class _ChoosePaymentViewState extends State<ChoosePaymentView> {
  PaymentOption? _paymentOption = PaymentOption.paypal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FractionallySizedBox(
            widthFactor: .75,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr('payment'),
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 20),
                ),
                const Spacer(),
              ],
            ),
          ),
          const SizedBox(height: 15),
          _getOptionPayment(),
          const SizedBox(height: 15),
          _getOptionPayment(isCardPaymentOption: true, isSecond: true),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('total'),
                    style: TextStyle(color: Colors.grey.withOpacity(.5)),
                  ),
                  Text('\$${widget.price}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18)),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  if (_paymentOption == PaymentOption.paypal) {
                    final mockDataExistingTour = widget.isCustomTour
                        ? {
                            "isExistingTour": false,
                            "paymentMethod": 1,
                            "bookingPlaces": List.generate(
                              widget.places.length,
                              (index) => {
                                "placeId": widget.places[index].id,
                                "ordinal": (index + 1),
                              },
                            )
                          }
                        : {
                            "isExistingTour": true,
                            "tourId": widget.tourId,
                            "paymentMethod": 1,
                            "bookingPlaces": List.generate(
                              widget.places.length,
                              (index) => {
                                "placeId": widget.places[index].id,
                                "ordinal": (index + 1),
                              },
                            )
                          };

                    await BookingRepository()
                        .postBooking(mockDataExistingTour)
                        .then((response) {
                      final approvalLink = response['href'];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentProcessingView(
                            paymentUrl: approvalLink,
                          ),
                        ),
                      );
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppColors.primaryColor,
                  ),
                  width: 150,
                  height: 50,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wallet, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          context.tr('pay_now'),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        )
                      ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getOptionPayment(
      {bool isCardPaymentOption = false, bool isSecond = false}) {
    return FractionallySizedBox(
      widthFactor: .75,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(.1),
          borderRadius: BorderRadius.circular(12),
        ),
        height: 70,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Radio<PaymentOption>(
            toggleable: true,
            value: isSecond ? PaymentOption.card : PaymentOption.paypal,
            groupValue: _paymentOption,
            activeColor: Colors.black,
            onChanged: (value) {
              setState(() {
                _paymentOption = value;
              });
            },
          ),
          Text(
            isCardPaymentOption
                ? context.tr('credit_card')
                : context.tr('online_payment'),
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
          isCardPaymentOption
              ? Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Visa_Inc._logo.svg/2560px-Visa_Inc._logo.svg.png'),
                        ),
                      ),
                      width: 40,
                      height: 30,
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/MasterCard_early_1990s_logo.svg/200px-MasterCard_early_1990s_logo.svg.png'),
                        ),
                      ),
                      width: 40,
                      height: 30,
                    )
                  ],
                )
              : Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://imgsrv2.voi.id/AB0I4tQ4k2K9kZR9Uj5Ya-OE7Gny2KI3ZuHo3Pd_lFk/auto/1200/675/sm/1/bG9jYWw6Ly8vcHVibGlzaGVycy8xODY1NTYvMjAyMjA3MDUxMTQyLW1haW4uY3JvcHBlZF8xNjU2OTk2MTUxLmpwZWc.jpg'),
                    ),
                  ),
                  width: 70,
                  height: 30,
                )
        ]),
      ),
    );
  }
}

enum PaymentOption { paypal, card }
