import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myhealthapps/app/SpTools.dart';
import 'package:myhealthapps/app/ToastUtil.dart';
import 'package:myhealthapps/app/bean/PlanBean.dart';
import 'package:myhealthapps/app/bean/RecordBean.dart';
import 'package:myhealthapps/app/video_page.dart';

class add_record_page extends StatefulWidget {
  String currentDate;
  List<RecordBean> list;
  add_record_page(this.currentDate, this.list);

  @override
  State<StatefulWidget> createState() {
    return add_record_page_state();
  }
}

class add_record_page_state extends State<add_record_page> {
  TextEditingController weightController = TextEditingController();
  TextEditingController bloodPressureController = TextEditingController();
  TextEditingController glucose_levelController = TextEditingController();
  TextEditingController cholesterol_levelController = TextEditingController();
  TextEditingController take_medicineController = TextEditingController();
  TextEditingController anyController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  late List<RecordBean> list;

  @override
  void initState() {
    super.initState();
    list = widget.list;
  }

  addPlan() async {
    if (weightController.text == '') {
      ToastUtil.showToast('please input weight');
      return;
    }
    if (bloodPressureController.text == '') {
      ToastUtil.showToast('please input blood pressure');
      return;
    }
    if (glucose_levelController.text == '') {
      ToastUtil.showToast('please input glucose level');
      return;
    }
    if (cholesterol_levelController.text == '') {
      ToastUtil.showToast('please input cholesterol level');
      return;
    }
    if (take_medicineController.text == '') {
      ToastUtil.showToast('please input take medicine');
      return;
    }
    if (anyController.text == '') {
      ToastUtil.showToast('please input any record');
      return;
    }

    String? account = user!.email;
    RecordBean recordBean = RecordBean(
        account: '$account',
        date: '${widget.currentDate}',
        weight: weightController.text,
        blood_pressure: bloodPressureController.text,
        glucose_level: glucose_levelController.text,
        cholesterol_level: cholesterol_levelController.text,
        take_medicine: take_medicineController.text,
        any: anyController.text);
    list.add(recordBean);

    CollectionReference users =
        FirebaseFirestore.instance.collection('${account}');
    users.doc('record').set({'data': RecordBean.encode(list)}).then((value) {
      ToastUtil.showToast('save success');
      Navigator.pop(context, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Record'),
        backgroundColor: Color(0xff9f61d1),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text('Weight(kg)'),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text('Blood pressure'),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: bloodPressureController,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text('Glucose level'),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: glucose_levelController,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text('Cholesterol level'),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: cholesterol_levelController,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text('Take medicine'),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: take_medicineController,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text('Any record'),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: anyController,
            ),
          ),
          SizedBox(height: 15),
          GestureDetector(
              onTap: () => addPlan(),
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(0xff9f61d1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                alignment: Alignment.center,
                child: Text('SUBMIT', style: TextStyle(color: Colors.white)),
              ))
        ],
      )),
    );
  }
}
