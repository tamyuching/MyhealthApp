import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myhealthapps/app/SpTools.dart';
import 'package:myhealthapps/app/ToastUtil.dart';
import 'package:myhealthapps/app/bean/PlanBean.dart';
import 'package:myhealthapps/app/video_page.dart';

class register_page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return register_page_state();
  }
}

class register_page_state extends State<register_page> {
  TextEditingController userController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController pwController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  addPlan() async {
    if (userController.text == '') {
      ToastUtil.showToast('please input user name');
      return;
    }
    if (accountController.text == '') {
      ToastUtil.showToast('please input account');
      return;
    }
    if (pwController.text == '') {
      ToastUtil.showToast('please input password');
      return;
    }
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: accountController.text, password: pwController.text);
      user.user!.updateDisplayName(userController.text);
      print('user:$user');
      ToastUtil.showToast('Register Success');
      Navigator.pop(context);
    } catch (e) {
      print('e:$e');
      ToastUtil.showToast('Register Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Color(0xff9f61d1),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text('User Name'),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: userController,
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(10),
            child: Text('Account(Use Email,Be sure to add@)'),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: accountController,
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(10),
            child: Text('Password'),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: pwController,
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
              onTap: () => addPlan(),
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                alignment: Alignment.center,
                child: Text('OK'),
              ))
        ],
      ),
    );
  }
}
