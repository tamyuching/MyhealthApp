import 'dart:ui';

import 'package:flutter/services.dart';

class Constants {
  static const kPrimaryColor = Color(0xFFFFFFFF);
  static const kGreyColor = Color(0xFFEEEEEE);
  static const kBlackColor = Color(0xFF000000);
  static const kDarkGreyColor = Color(0xFF9E9E9E);
  static const kDarkBlueColor = Color(0xFF6057FF);
  static const kBorderColor = Color(0xFFEFEFEF);

  //text
  static const title = "Google Sign In";
  static const textIntro = "Manage your health \n in a ";
  static const textIntroDesc1 = "easier ";
  static const textIntroDesc2 = "way!!";
  static const textSmallSignUp = "Let's start from sign in!";
  static const textSignIn = "Sign In";
  static const textStart = "Get Started";
  static const textSignInTitle = "Welcome to MyHealth app!";
  static const textSmallSignIn = "Choose a method to sign in!";
  static const textSignInGoogle = "Sign In With Google";
  static const textAcc = "Don't have an account? ";
  static const textSignUp = "Sign Up here";
  static const textHome = "Home";

  //navigate
  static const signInNavigate = '/sign-in';
  static const homeNavigate = '/home';

  static const statusBarColor = SystemUiOverlayStyle(
      statusBarColor: Constants.kPrimaryColor,
      statusBarIconBrightness: Brightness.dark);
}