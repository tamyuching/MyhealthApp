import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myhealthapps/app/SpTools.dart';
import 'package:myhealthapps/app/ToastUtil.dart';
import 'package:myhealthapps/app/bean/PlanBean.dart';
import 'package:myhealthapps/app/video_page.dart';

class personal_page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return personal_page_state();
  }
}

class personal_page_state extends State<personal_page> {
  User? user = FirebaseAuth.instance.currentUser;
  bool isMellitus = false;
  bool isHighCholesterol = false;
  bool isHypertension = false;
  String? account = '';
  String? userName = '';
  TextEditingController nameC = TextEditingController();

  @override
  void initState() {
    super.initState();
    account = user!.email;

    isMellitus = SpTools.getBool('${account}_isMellitus', defValue: false)!;
    isHighCholesterol =
        SpTools.getBool('${account}_isHighCholesterol', defValue: false)!;
    isHypertension =
        SpTools.getBool('${account}_isHypertension', defValue: false)!;

    userName = '${user!.displayName}';
    nameC.text = '$userName';

    isMellitus = SpTools.getBool('${account}_isMellitus', defValue: false)!;
    isHighCholesterol =
        SpTools.getBool('${account}_isHighCholesterol', defValue: false)!;
    isHypertension =
        SpTools.getBool('${account}_isHypertension', defValue: false)!;
  }

  submit() {
    if (nameC.text == '') {
      ToastUtil.showToast('please input name');
      return;
    }

    SpTools.putBool('${account}_isMellitus', isMellitus);
    SpTools.putBool('${account}_isHighCholesterol', isHighCholesterol);
    SpTools.putBool('${account}_isHypertension', isHypertension);

    user!.updateDisplayName(nameC.text).then((value) {
      ToastUtil.showToast('update success');
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal'),
        backgroundColor: Color(0xff9f61d1),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(25),
            alignment: Alignment.center,
            color: Color(0xffbc92dd),
            child: (user!.photoURL == null || '${user!.photoURL}' == '')
                ? Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        image: DecorationImage(
                            image: AssetImage("images/sign-in.png"),
                            fit: BoxFit.fill)),
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(
                      user!.photoURL!,
                    ),
                    radius: 50,
                  ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(10),
            child: Text('Account: $account'),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Text('Name: '),
                Expanded(
                    child: Container(
                  child: TextField(
                    controller: nameC,
                  ),
                ))
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(10),
            child: Text('Disease Type:'),
          ),
          Row(
            children: [
              Checkbox(
                  value: isMellitus,
                  onChanged: (value) {
                    setState(() {
                      isMellitus = value!;
                    });
                  }),
              Text('High Mellitus')
            ],
          ),
          Row(
            children: [
              Checkbox(
                  value: isHighCholesterol,
                  onChanged: (value) {
                    setState(() {
                      isHighCholesterol = value!;
                    });
                  }),
              Text('High Cholesterol')
            ],
          ),
          Row(
            children: [
              Checkbox(
                  value: isHypertension,
                  onChanged: (value) {
                    setState(() {
                      isHypertension = value!;
                    });
                  }),
              Text('Hypertension')
            ],
          ),
          SizedBox(height: 30),
          GestureDetector(
              onTap: () => submit(),
              child: Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Color(0xffe4c2ff),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                alignment: Alignment.center,
                child: Text('SUBMIT',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ))
        ],
      ),
    );
  }
}
