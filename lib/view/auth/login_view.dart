import 'package:easy_localization/easy_localization.dart';
import 'package:etravel_mobile/res/app_color.dart';
import 'package:etravel_mobile/view/auth/register_view.dart';
import 'package:etravel_mobile/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late String phone;
  late String password;
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final TextStyle _infoStyle = const TextStyle(fontWeight: FontWeight.w600);

  final TextStyle _forgotPassStyle = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.blue);

  final TextStyle _signInStyle =
      const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

  final TextStyle _registerStyle =
      const TextStyle(fontWeight: FontWeight.bold, color: AppColors.blue);

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
        body: Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * .5,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/auth/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            //const Spacer(),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * .6,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Center(
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .55,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(child: _buildPhoneTextField(context)),
                      _buildPasswordTextField(context),
                      _buildForgotPass(context),
                      _buildSignInButton(context, authViewModel,
                          phoneController, passwordController),
                      _buildOthersSignIn(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        authViewModel.loading
            ? Stack(
                children: [
                  Container(color: Colors.black.withOpacity(.4)),
                  Center(
                    child: Lottie.asset('assets/images/auth/loading.json'),
                  ),
                ],
              )
            : Container(),
      ],
    ));
  }

  Widget _buildPhoneTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.tr('phone_number'), style: _infoStyle),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.searchBorderColor.withOpacity(.3))),
            child: TextFormField(
              decoration: InputDecoration.collapsed(
                  hintStyle:
                      const TextStyle(color: AppColors.searchBorderColor),
                  hintText: context.tr('enter_phone_number')),
              keyboardType: TextInputType.number,
              controller: phoneController,
              onChanged: (value) {
                setState(() {
                  phone = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordTextField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tr('password'), style: _infoStyle),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: AppColors.searchBorderColor.withOpacity(.3))),
          child: TextFormField(
            decoration: InputDecoration.collapsed(
                hintStyle: const TextStyle(color: AppColors.searchBorderColor),
                hintText: context.tr('enter_password')),
            controller: passwordController,
            obscureText: true,
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Row _buildForgotPass(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        GestureDetector(
          onTap: () {},
          child: Text(
            context.tr('forgot_password'),
            style: _forgotPassStyle,
          ),
        )
      ],
    );
  }

  GestureDetector _buildSignInButton(
      BuildContext context,
      AuthViewModel authViewModel,
      TextEditingController phoneController,
      TextEditingController passwordController) {
    return GestureDetector(
      onTap: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        Map<String, String> loginData = {
          'phone': phone,
          'password': password,
        };
        await authViewModel.login(
          loginData,
          context,
          phoneController,
          passwordController,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppColors.primaryColor,
        ),
        alignment: Alignment.center,
        height: 45,
        child: Text(style: _signInStyle, context.tr('sign_in')),
      ),
    );
  }

  Center _buildOthersSignIn(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            context.tr('or_sign_in_with'),
            style: _infoStyle,
          ),
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'https://banner2.cleanpng.com/20180521/ers/kisspng-google-logo-5b02bbe1d5c6e0.2384399715269058258756.jpg')),
              shape: BoxShape.circle,
            ),
            width: 31,
            height: 31,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.tr('donot_have_an_account'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterView(),
                    ),
                  );
                },
                child: Text(
                  context.tr('register_now'),
                  style: _registerStyle,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
