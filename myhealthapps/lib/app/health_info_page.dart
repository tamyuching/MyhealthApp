import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myhealthapps/app/video_page.dart';

class health_info_page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return health_info_page_state();
  }
}

class health_info_page_state extends State<health_info_page> {
  List<String> imgs = [
    'images/V1.PNG',
    'images/V2.PNG',
    'images/V3.PNG',
    'images/V4.PNG',
    'images/V5.PNG'
  ];
  List<String> urls = [
    'https://www.youtube.com/watch?v=q_391Bf9J40',
    'https://www.youtube.com/watch?v=da8iw9hvQX4',
    'https://www.youtube.com/watch?v=Ap1FXfy91d4',
    'https://www.youtube.com/watch?v=c91ggTlEGv8&t=12s',
    'https://www.youtube.com/watch?v=wyI7mtSFLdo'
  ];
  List<String> titles = ['What is Chronic Disease?  ',
    'Chronic Diseases: Everyone’s Business',
    'The BETTER approach to preventing chronic diseases',
    'Chronic Disease',
    'EHealth animated video - Chronic Disease Management'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Infomation'),
        backgroundColor: Color(0xff9f61d1),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            getItem(0),
            getItem(1),
            getItem(2),
            getItem(3),
            getItem(4)
          ],
        ),
      ),
    );
  }

  getItem(int index) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return video_page(url: urls[index], title: titles[index]);
          }));
        },
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                    image: AssetImage(imgs[index]), fit: BoxFit.fill),
                border: Border.all(color: Colors.grey.withOpacity(0.3))),
            alignment: Alignment.bottomLeft,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Color(0xffe9cdfe),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Text(titles[index],
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            )));
  }
}
