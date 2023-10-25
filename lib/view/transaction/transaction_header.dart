import 'package:etravel_mobile/services/local_storage_service.dart';
import 'package:flutter/material.dart';

import 'transaction_header_item.dart';

class TransactionHeader extends StatelessWidget {
  const TransactionHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 0,
        bottom: 30,
      ),
      // color: Colors.grey,
      width: double.infinity,
      child: FutureBuilder(
        future: LocalStorageService.getInstance.getAccount(),
        builder: (ctx, snapshot) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TransactionHeaderItem(
                content:
                    '${snapshot.data?.firstName} ${snapshot.data?.lastName}',
                icon: snapshot.data?.image != null
                    ? Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          image: snapshot.data?.image != null
                              ? DecorationImage(
                                  image:
                                      NetworkImage(snapshot.data?.image ?? ''),
                                )
                              : null,
                        ),
                      )
                    : Container(
                        width: 40,
                        height: 40,
                        color: Colors.grey,
                      ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TransactionHeaderItem(
                content: 'placeholder',
                icon: snapshot.data?.image != null
                    ? Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          image: snapshot.data?.image != null
                              ? DecorationImage(
                                  image:
                                      NetworkImage(snapshot.data?.image ?? ''),
                                )
                              : null,
                        ),
                      )
                    : Container(
                        width: 40,
                        height: 40,
                        color: Colors.grey,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
