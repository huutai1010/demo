import 'package:flutter/material.dart';

class HistoryBookingTourDetailView extends StatelessWidget {
  const HistoryBookingTourDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Celebrated place images',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            4,
            (index) {
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
