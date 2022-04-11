import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myhealthapps/app/SpTools.dart';
import 'package:myhealthapps/app/personal_page.dart';
import 'package:myhealthapps/app/service/firebase_service.dart';
import 'package:myhealthapps/app/utils/constants.dart';

import 'consultation_page.dart';
import 'health_info_page.dart';
import 'health_record_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  var _scaffoldkey = new GlobalKey<ScaffoldState>();
  String? userName = '';
  late Timer timer;

  @override
  void initState() {
    super.initState();
    String account = SpTools.getString('account', defValue: '')!;
    userName = '${user!.displayName}';
    Timer.periodic(Duration(seconds: 1), (t) {
      timer = t;
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xff9f61d1),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldkey.currentState!.openDrawer();
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () async {
                FirebaseService service = new FirebaseService();
                await service.signOutFromGoogle();
                Navigator.pushReplacementNamed(
                    context, Constants.signInNavigate);
              },
            )
          ],
          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.blue),
          title: Text("Home"),
        ),
        drawer: Drawer(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xffe0cdef),
                  child: Column(
                    children: [
                      SizedBox(height: 60),
                      user!.photoURL == ''
                          ? Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "images/healthcareSignIn.png"),
                                      fit: BoxFit.fill)),
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(
                                '${user!.photoURL}',
                              ),
                              radius: 50,
                            ),
                      SizedBox(height: 15),
                      Text('$userName', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                getItem2(-1, 'Personal information'),
                getItem2(0, 'My health Record'),
                getItem2(1, 'My Consultation'),
                getItem2(2, 'Health Information'),
              ],
            ),
          ),
        ),
        body: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Colors.grey, Colors.black]),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TODAY',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                            '${DateTime.now().toString().substring(0, 19)}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
                getItem(0, 'My health Record', 'Record Your Daily Life',
                    Color(0xffdbc1f0)),
                getItem(1, 'My Consultation', 'Make Your Consultation record',
                    Color(0xffe9e0f0)),
                getItem(2, 'Health Information',
                    'Learn more about chronic disease', Color(0xffdbc1f0)),
              ],
            )));
  }

  getItem(int index, String txt, String str2, Color color) {
    IconData iconData = Icons.person;
    switch (index) {
      case 0:
        iconData = Icons.accessibility_new;
        break;
      case 1:
        iconData = Icons.access_time_filled;
        break;
      case 2:
        iconData = Icons.ad_units;
        break;
      default:
    }
    return GestureDetector(
        onTap: () {
          switch (index) {
            case -1:
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return personal_page();
              })).then((value) {
                setState(() {
                  user = FirebaseAuth.instance.currentUser;
                  userName = '${user!.displayName}';
                });
              });
              break;
            case 0:
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return health_record_page();
              }));
              break;
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return consultation_page();
              }));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return health_info_page();
              }));
              break;
            default:
          }
        },
        child: Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.only(left: 5, right: 5, top: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            children: [
              Icon(iconData, size: 35),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(txt,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text(str2,
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ],
              ),
            ],
          ),
        ));
  }

  getItem2(int index, String txt) {
    IconData iconData = Icons.person;
    switch (index) {
      case -1:
        iconData = Icons.person;
        break;
      case 0:
        iconData = Icons.library_books;
        break;
      case 1:
        iconData = Icons.library_books;
        break;
      case 2:
        iconData = Icons.audio_file_outlined;
        break;
      default:
    }
    return GestureDetector(
        onTap: () {
          switch (index) {
            case -1:
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return personal_page();
              })).then((value) {
                setState(() {
                  user = FirebaseAuth.instance.currentUser;
                  userName = '${user!.displayName}';
                });
              });
              break;
            case 0:
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return health_record_page();
              }));
              break;
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return consultation_page();
              }));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return health_info_page();
              }));
              break;
            default:
          }
        },
        child: Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.only(left: 5, right: 5, top: 15),
          alignment: Alignment.center,
          child: Row(
            children: [
              Icon(iconData),
              SizedBox(width: 15),
              Text(txt,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ));
  }

  @override
  Widget build_try(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text('Home Page'),
          centerTitle: true,
          elevation: 10.0,
          actions: <Widget>[
            FlatButton(
              onPressed: () {},
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text('Testing',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                accountEmail: Text('Testing@google.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: null,
                ),
              ),
              ListTile(
                title: Text(
                  'My Record',
                  textAlign: TextAlign.right,
                ),
                trailing: Icon(
                  Icons.message,
                  color: Colors.black12,
                  size: 22.0,
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                title: Text(
                  'My Medicine',
                  textAlign: TextAlign.right,
                ),
                trailing: Icon(
                  Icons.message,
                  color: Colors.black12,
                  size: 22.0,
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                title: Text(
                  'My consultation',
                  textAlign: TextAlign.right,
                ),
                trailing: Icon(
                  Icons.message,
                  color: Colors.black12,
                  size: 22.0,
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                title: Text(
                  'Extra Information',
                  textAlign: TextAlign.right,
                ),
                trailing: Icon(
                  Icons.message,
                  color: Colors.black12,
                  size: 22.0,
                ),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
