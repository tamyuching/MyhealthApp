import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myhealthapps/app/video_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SpTools.dart';
import 'ToastUtil.dart';
import 'add_consultation_page.dart';
import 'bean/PlanBean.dart';

class consultation_page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return consultation_page_state();
  }
}

class consultation_page_state extends State<consultation_page> {
  List<PlanBean> list = [];
  String? account = '';
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    account = user!.email;

    getPlanList();
  }

  getPlanList() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('$account');
    users.doc('consultation').get().then((value) {
      print('getPlanList:${value}');
      if (value.get('data') != null) {
        list = PlanBean.decode('${value.get('data')}');
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
              .doc('consultation')
              .set({'data': PlanBean.encode(list)}).then((value) {
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
        title: Text('Consultation'),
        backgroundColor: Color(0xff9f61d1),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return add_consultation_page(list: list);
              })).then((value) {
                if (value == 1) {
                  getPlanList();
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
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return buildItem(index);
        },
      ),
    );
  }

  Widget buildItem(int index) {
    //slidable delete
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

  getItem(PlanBean planBean) {
    return GestureDetector(
        onTap: () {},
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Color(0xff9f61d1))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('title: ${planBean.title}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('date: ${planBean.date}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('plan: ${planBean.plan}', style: TextStyle(fontSize: 16))
            ],
          ),
        ));
  }
}
