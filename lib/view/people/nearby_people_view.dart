import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/account.dart';
import '../../repository/people_repository.dart';

import '../../widgets/account_item.dart';

class NearbyPeopleView extends StatefulWidget {
  const NearbyPeopleView({super.key});

  @override
  State<NearbyPeopleView> createState() => _NearbyPeopleViewState();
}

class _NearbyPeopleViewState extends State<NearbyPeopleView> {
  late Future<dynamic> _recentPeopleFuture;
  Map<int, bool> _idsToSend = {};

  get canSend => _idsToSend.containsValue(true);

  @override
  void initState() {
    _recentPeopleFuture = PeopleRepository().getRecentPeopleApi();
    super.initState();
  }

  Future<void> sendRequests() async {
    final ids = _idsToSend.keys;
    for (var element in ids) {
      PeopleRepository().sendNotificationApi(1, element);
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Requests sent.'),
        ),
      );
    }
    setState(() {
      _idsToSend = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('recent_people'),
          style: const TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !canSend
          ? null
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
              ),
              onPressed: () => sendRequests(),
              child: Container(
                padding: const EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width * .5,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text(
                          context.tr('add_request'),
                          textAlign: TextAlign.center,
                        )),
                    const Icon(Icons.arrow_circle_right_sharp)
                  ],
                ),
              )),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: FutureBuilder(
              future: _recentPeopleFuture,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.error != null) {
                  return Center(
                    child: Text('An error occurred! ${snapshot.error}'),
                  );
                }
                final responseData = snapshot.data['accounts'] as List;
                return ListView.builder(
                  itemCount: responseData.length,
                  itemBuilder: (c, index) {
                    final account = responseData[index];
                    return AccountItem(
                      selected: _idsToSend[account['id']] ?? false,
                      onSelected: (value) {
                        setState(() {
                          if (!value!) {
                            _idsToSend.remove(account['id']);
                            return;
                          }
                          _idsToSend[account['id']] = value;
                        });
                      },
                      account: account,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
