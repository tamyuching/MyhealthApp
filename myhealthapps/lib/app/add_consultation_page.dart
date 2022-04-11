import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myhealthapps/app/SpTools.dart';
import 'package:myhealthapps/app/ToastUtil.dart';
import 'package:myhealthapps/app/bean/PlanBean.dart';
import 'package:myhealthapps/app/video_page.dart';

class add_consultation_page extends StatefulWidget {
  List<PlanBean> list;

  add_consultation_page({required this.list});

  @override
  State<StatefulWidget> createState() {
    return add_consultation_page_state();
  }
}

class add_consultation_page_state extends State<add_consultation_page> {
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController planController = TextEditingController();
  late List<PlanBean> list;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    list = widget.list;
  }

  addPlan() async {
    if (titleController.text == '') {
      ToastUtil.showToast('please input title');
      return;
    }
    if (dateController.text == '') {
      ToastUtil.showToast('please input date');
      return;
    }
    if (planController.text == '') {
      ToastUtil.showToast('please input plan');
      return;
    }

    String? account = user!.email;
    PlanBean planBean = PlanBean(
        account: '$account',
        date: dateController.text,
        plan: planController.text,
        title: titleController.text);
    list.add(planBean);

    CollectionReference users =
        FirebaseFirestore.instance.collection('${account}');
    users
        .doc('consultation')
        .set({'data': PlanBean.encode(list)}).then((value) {
      ToastUtil.showToast('save success');
      Navigator.pop(context, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Consultation'),
        backgroundColor: Color(0xff9f61d1),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text('Title', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: titleController,
            ),
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(10),
            child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: dateController,
              keyboardType: TextInputType.datetime,
            ),
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(10),
            child: Text('Plan', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: planController,
            ),
          ),
          SizedBox(height: 50),
          GestureDetector(
              onTap: () => addPlan(),
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(0xffe4c2ff),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                alignment: Alignment.center,
                child: Text('SUBMIT',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ))
        ],
      )),
    );
  }
}
