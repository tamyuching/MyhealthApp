import 'package:firebase_auth/firebase_auth.dart';
import 'package:myhealthapps/app/ToastUtil.dart';
import 'package:myhealthapps/app/register_page.dart';
import 'package:myhealthapps/app/service/firebase_service.dart';
import 'package:myhealthapps/app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'SpTools.dart';
import 'home_page2.dart';

class SignInPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  login(BuildContext context) async {
    if (emailController.text == '') {
      ToastUtil.showToast('please input account');
      return;
    }
    if (pwController.text == '') {
      ToastUtil.showToast('please input password');
      return;
    }
    try {
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
          email: emailController.text, password: pwController.text);
      print('user:$user');
      SpTools.putString('account', emailController.text);
      SpTools.putString('name', '${user.user!.displayName}');
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return HomePage();
      }));
    } catch (e) {
      print('e:$e');
      ToastUtil.showToast('Login Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    OutlineInputBorder border = OutlineInputBorder(
        borderSide: BorderSide(color: Constants.kBorderColor, width: 3.0));
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Constants.kPrimaryColor,
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset("images/healthcareSignIn.png"),
          SizedBox(height: 30),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: Constants.textSignInTitle,
                    style: TextStyle(
                      color: Constants.kBlackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 26.0,
                    )),
              ])),
          SizedBox(height: size.height * 0.01),
          Text(
            Constants.textSmallSignIn,
            style: TextStyle(color: Constants.kDarkGreyColor),
          ),
          GoogleSignIn(),
          buildRowDivider(size: size),
          Padding(padding: EdgeInsets.only(bottom: size.height * 0.02)),
          SizedBox(
            width: size.width * 0.8,
            child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    enabledBorder: border,
                    focusedBorder: border)),
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          SizedBox(
            width: size.width * 0.8,
            child: TextField(
              controller: pwController,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                enabledBorder: border,
                focusedBorder: border,
                suffixIcon: Padding(
                  child: FaIcon(
                    FontAwesomeIcons.eye,
                    size: 15,
                  ),
                  padding: EdgeInsets.only(top: 15, left: 15),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: size.height * 0.05)),
          SizedBox(
            width: size.width * 0.8,
            child: OutlinedButton(
              onPressed: () async {
                login(context);
              },
              child: Text(Constants.textSignIn),
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Constants.kPrimaryColor),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Constants.kBlackColor),
                  side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
            ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return register_page();
                }));
              },
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: Constants.textAcc,
                        style: TextStyle(
                          color: Constants.kDarkGreyColor,
                        )),
                    TextSpan(
                        text: Constants.textSignUp,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Constants.kDarkBlueColor,
                        )),
                  ]))),
        ])));
  }

  Widget buildRowDivider({required Size size}) {
    return SizedBox(
      width: size.width * 0.8,
      child: Row(children: <Widget>[
        Expanded(child: Divider(color: Constants.kDarkGreyColor)),
        Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: Text(
              "Or",
              style: TextStyle(color: Constants.kDarkGreyColor),
            )),
        Expanded(child: Divider(color: Constants.kDarkGreyColor)),
      ]),
    );
  }
}

class GoogleSignIn extends StatefulWidget {
  GoogleSignIn({Key? key}) : super(key: key);

  @override
  _GoogleSignInState createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return !isLoading
        ? SizedBox(
            width: size.width * 0.8,
            child: OutlinedButton.icon(
              icon: FaIcon(FontAwesomeIcons.google),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                FirebaseService service = new FirebaseService();
                try {
                  service.signInwithGoogle().then((value) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, Constants.homeNavigate, (route) => false);
                  });
                } catch (e) {
                  if (e is FirebaseAuthException) {
                    showMessage(e.message!);
                  }
                }
                setState(() {
                  isLoading = false;
                });
              },
              label: Text(
                Constants.textSignInGoogle,
                style: TextStyle(
                    color: Constants.kBlackColor, fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Constants.kGreyColor),
                  side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
            ),
          )
        : CircularProgressIndicator();
  }

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
