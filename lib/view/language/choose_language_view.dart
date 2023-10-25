import 'package:easy_localization/easy_localization.dart';
import '../../models/language.dart';
import '../../res/app_color.dart';
import '../confirm/confirm_access_location.dart';
import '../../view_model/language_viewmodel.dart';
import '../../view_model/main_app_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseLanguageView extends StatefulWidget {
  final bool isFromProfile;

  const ChooseLanguageView({super.key, this.isFromProfile = false});

  @override
  State<ChooseLanguageView> createState() => _ChooseLanguageViewState();
}

class _ChooseLanguageViewState extends State<ChooseLanguageView> {
  Language? selectedValue;
  late Future _languagesFuture;

  void changeLanguage(BuildContext ctx, int id, String language) {
    final languageProvider = Provider.of<MainAppViewModel>(ctx, listen: false);
    languageProvider.changeLanguage(ctx, id, language);
  }

  Future _getLanguagesFuture() =>
      Provider.of<LanguageViewModel>(context, listen: false).getLanguages();

  @override
  void initState() {
    _languagesFuture = _getLanguagesFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/background/permission.png'),
          ),
        ),
        width: screenWidth,
        height: screenHeight,
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
          ),
          width: screenWidth * 320 / 375,
          height: screenHeight * 420 / 812,
          child: Column(children: [
            Container(
              margin: EdgeInsets.only(top: screenHeight * 15 / 812),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/confirm/confirm.png'),
                ),
              ),
              width: screenWidth * 150 / 375,
              height: screenHeight * 110 / 812,
            ),
            SizedBox(height: screenHeight * 15 / 812),
            Text(
              context.tr('choose_language'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: screenHeight * 10 / 812),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 20 / 375),
              child: Row(
                children: [
                  Text(context.tr("i_speak")),
                  const Spacer(),
                ],
              ),
            ),
            FutureBuilder(
              future: _languagesFuture,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Consumer<LanguageViewModel>(
                  builder: (c, languagesVm, _) {
                    final data = languagesVm.languages;
                    return DropdownButton(
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value!;
                          if (selectedValue != null) {
                            changeLanguage(
                                context, value.id!, value.languageCode ?? 'en');
                          }
                        });
                      },
                      value: selectedValue,
                      items: List.generate(
                        data.length,
                        (index) => DropdownMenuItem(
                          value: data.isNotEmpty
                              ? data[index]
                              : Language(
                                  name: 'English',
                                  icon:
                                      'https://firebasestorage.googleapis.com/v0/b/capstoneetravel-d42ad.appspot.com/o/Language%2Fengland_language.jpg?alt=media&token=828cd40b-68a4-4908-9472-77096b633b7a',
                                ),
                          child: Container(
                            margin:
                                EdgeInsets.only(left: screenWidth * 15 / 375),
                            width: screenWidth * 256 / 375,
                            height: screenHeight * 29 / 812,
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(data[index].icon!),
                                    ),
                                  ),
                                  width: screenWidth * 17 / 375,
                                  height: screenHeight * 10 / 812,
                                ),
                                SizedBox(width: screenWidth * 15 / 375),
                                Text(data[index].name!),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                if (widget.isFromProfile) {
                  Navigator.pop(context);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConfirmAcessLocation(),
                    ),
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.only(bottom: screenHeight * 25 / 812),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(25)),
                width: screenWidth * 250 / 375,
                height: screenHeight * 45 / 812,
                alignment: Alignment.center,
                child: Text(
                  context.tr('continue'),
                  style: const TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
