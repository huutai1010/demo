import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/view/booking/booking_detail_view.dart';
import 'package:flutter/material.dart';

class BookingHistoryView extends StatefulWidget {
  const BookingHistoryView({super.key});

  @override
  State<StatefulWidget> createState() => _BookingHistoryViewState();
}

class _BookingHistoryViewState extends State<BookingHistoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        toolbarHeight: 70,
        title: Text(
          context.tr('booking_history'),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
            children: List.generate(5, (index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const BookingDetailView()));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              height: 181,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFFFF4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.center,
                      width: 154,
                      height: 30,
                      child: const Text(
                        'Booking completed',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF00AB56),
                        ),
                      ),
                    ),
                    _getAddressAndTime(),
                    Row(
                      children: [
                        Text(
                          '13 ${context.tr('places')}',
                          style: _getTextInfoStyle(),
                        ),
                        const Spacer(),
                        Text(
                          '${(index + 1) * 10} USD',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        })),
      ),
    );
  }

  Column _getAddressAndTime() {
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on_rounded,
              color: Color(0xFF1A94FF),
            ),
            const SizedBox(width: 5),
            Text(
              '${context.tr('booking')} 1190-4202-3420-0020',
              style: _getTextInfoStyle(),
            )
          ],
        ),
        const Divider(color: Color(0xFFEBEBF0)),
        Row(
          children: [
            const Icon(
              Icons.access_time_filled_sharp,
              color: Color(0xFFFC820A),
            ),
            const SizedBox(width: 5),
            Text(
              '19/04/2023, 4:20',
              style: _getTextInfoStyle(),
            ),
          ],
        ),
      ],
    );
  }

  TextStyle _getTextInfoStyle() {
    return const TextStyle(fontWeight: FontWeight.w400);
  }
}
