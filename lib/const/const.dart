import 'package:flutter/material.dart';

var accessToken =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiIxMiIsImZpcnN0bmFtZSI6IlBpZXJyZSIsImxhc3RuYW1lIjoiTWFydGluIiwiaW1hZ2UiOiJodHRwczovL2ZpcmViYXNlc3RvcmFnZS5nb29nbGVhcGlzLmNvbS92MC9iL2NhcHN0b25lZXRyYXZlbC1kNDJhZC5hcHBzcG90LmNvbS9vL0FjY291bnQlMkZ2aXNpdG9yNi5qcGc_YWx0PW1lZGlhJnRva2VuPTNjZTgwNzI3LThmZjctNDdjMi1iNDAyLTRjNjM3MDI2NDZkNCIsImVtYWlsIjoicGllcnJlLm1hcnRpbkBnbWFpbC5jb20iLCJsYW5ndWFnZV9pZCI6IjMiLCJsYW5ndWFnZV9jb2RlIjoiRW4iLCJyb2xlIjoiMyIsIm5iZiI6MTY5MzQ5NDM0MSwiZXhwIjoxNjk0MDk5MTQxLCJpYXQiOjE2OTM0OTQzNDEsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMCJ9.7EjRkCCKvRnl4s55XQe0rtKmjE262mhi9FbCXV9KYR4";

var iosFcmToken =
    "d_JWOEQ91UWbr0VRH2EXam:APA91bHGnIrJrzMmNoMytV7xmv1m4gC5kua0vcM4Y7tTvK8iT9RV5mTqP8FRbruTSX6byl9jNquMzihoS4FcXaNsAEP2c_4ls7BOkyjSFMdKtinP5aUBBZ9eO-H2OxAoZLAhB7Amd6P7";

const titleTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
);

List<Widget> generateRowItem(
  Widget leftContent,
  Widget rightContent, {
  double spacing = 0,
}) {
  return [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: leftContent,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(flex: 1, child: rightContent),
      ],
    ),
    SizedBox(
      height: spacing,
    )
  ];
}

const kDateFormat = 'dd-MM-yyyy';
const kDateTimeFormat = 'HH:mm:ss dd/MM/yyyy';

const kGender = [
  'Male',
  'Female',
];

const kDefaultImage =
    'https://images.unsplash.com/photo-1599566150163-29194dcaad36?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8YXZhdGFyfGVufDB8fDB8fHww&auto=format&fit=crop&w=800&q=60';

const kCurrencies = [
  {
    'key': 'USD',
    'name': 'United States Dollar',
    'image': 'usa',
    'format': '\${0}',
    'decimal': 2,
  },
  {
    'key': 'VND',
    'name': 'Vietnamese Dong',
    'image': 'vietnam',
    'format': '{0} VND',
    'decimal': 0,
  },
  {
    'key': 'JPY',
    'name': 'Japanese Yen',
    'image': 'japan',
    'format': '{0} ¥',
    'decimal': 2,
  },
  {
    'key': 'CNH',
    'name': 'Chinese Yuan',
    'image': 'chinese',
    'format': '{0} ￥',
    'decimal': 2,
  }
];
