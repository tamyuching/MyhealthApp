import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myhealthapps/app/video_page.dart';
import 'package:r_calendar/r_calendar.dart';

import 'SpTools.dart';
import 'ToastUtil.dart';
import 'add_consultation_page.dart';
import 'add_record_page.dart';
import 'bean/PlanBean.dart';
import 'bean/RecordBean.dart';

class health_record_page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return health_record_page_state();
  }
}

class health_record_page_state extends State<health_record_page> {
  List<RecordBean> list = [];
  String? account = '';
  String? currentDate = '';
  late RCalendarController controller;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now().toString().substring(0, 11);
    account = user!.email;

    getRecordList();
    controller = RCalendarController.single(
        selectedDate: DateTime.now(), mode: RCalendarMode.month)
      ..addListener(() {
        currentDate = controller.selectedDate.toString().substring(0, 11);
        print('currentDate:${currentDate}');
        getRecordList();
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  getRecordList() async {
    CollectionReference? users =
        FirebaseFirestore.instance.collection('$account');
    users.doc('record').get().then((value) {
      if (value.get('data') != null) {
        list = RecordBean.decode('${value.get('data')}');
      } else {
        list = [];
      }
      setState(() {});
    });
  }

  showDeleteDialog(BuildContext context, int index) {
    //pop up window
    showDialog(
      context: context,
      builder: (BuildContext context) {
        //button
        Widget cancelButton = FlatButton(
          child: Text("no"),
          onPressed: () {
            Navigator.pop(context, false);
          },
        );
        Widget continueButton = FlatButton(
          child: Text("yes"),
          onPressed: () {
            Navigator.pop(context, true);
          },
        );

        //pop up window
        AlertDialog alert = AlertDialog(
          title: Text("Are you sure to delete"),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
        return alert;
      },
    ).then((value) {
      if (value) {
        setState(() {
          list.removeAt(index);
          CollectionReference users =
              FirebaseFirestore.instance.collection('${account}');
          users
              .doc('record')
              .set({'data': RecordBean.encode(list)}).then((value) {
            ToastUtil.showToast('delete success');
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Record'),
        backgroundColor: Color(0xff9f61d1),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return add_record_page('$currentDate', list);
              })).then((value) {
                if (value == 1) {
                  setState(() {
                    getRecordList();
                  });
                }
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          RCalendarWidget(
            controller: controller,
            customWidget: DefaultRCalendarCustomWidget(),
            firstDate: DateTime(1970, 1, 1), //smallest number
            lastDate: DateTime.now(), // greatest number
          ),
          Expanded(
              child: Container(
                  child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return buildItem(index);
            },
          )))
        ],
      ),
    );
  }

  Widget buildItem(int index) {
    return Slidable(
      key: ValueKey("$index"),
      direction: Axis.horizontal,
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            showDeleteDialog(context, index);
          },
          closeOnTap: true,
        ),
      ],
      actionPane: SlidableScrollActionPane(),
      child: getItem(list[index]),
    );
  }

  getItem(RecordBean recordBean) {
    if (currentDate != recordBean.date) {
      return Container();
    }
    return GestureDetector(
        onTap: () {},
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Color(0xfff6ecfe),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Color(0xffcb8ffa))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Weight(kg): ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('${recordBean.weight}', style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Blood pressure: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('${recordBean.blood_pressure}',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Glucose level: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('${recordBean.glucose_level}',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Cholesterol level: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('${recordBean.cholesterol_level}',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Take medicine: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('${recordBean.take_medicine}',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Any record: ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('${recordBean.any}', style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
        ));
  }
}
