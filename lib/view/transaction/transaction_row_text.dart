import 'package:flutter/material.dart';

import '../../const/const.dart';

class RowText extends StatelessWidget {
  final String content;
  const RowText(
    this.content, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      textAlign: TextAlign.right,
      overflow: TextOverflow.ellipsis,
      style: titleTextStyle,
    );
  }
}
