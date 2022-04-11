import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class video_page extends StatefulWidget {
  String url;
  String title;

  video_page({required this.url, required this.title});

  @override
  State<StatefulWidget> createState() {
    return video_page_state();
  }
}

class video_page_state extends State<video_page> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
        backgroundColor: Color(0xff9f61d1),
      ),
      body: Container(
        child: WebView(
          initialUrl: '${widget.url}',
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
