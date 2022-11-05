//https://www.al-rehaili.net/online?parent=9

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/my_bottom.dart';
import '../../../main.dart';


class LiveScreen extends StatefulWidget {
  static const String route='/LiveScreen';
  const LiveScreen({Key? key}) : super(key: key);

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {

  String streamUrl='<iframe src=\"https://mixlr.com/rehyli/embed\" width=\"100%\" height=\"180px\" scrolling=\"no\" frameborder=\"no\" marginheight=\"0\" marginwidth=\"0\"></iframe><small><a href=\"http://mixlr.com/rehyli\" style=\"color:#1a1a1a;text-align:left; font-family:Helvetica, sans-serif; font-size:11px;\">rehyli is on Mixlr</a></small>';
  @override
  Widget build(BuildContext context) {

    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    if(MediaQuery.of(context).orientation==Orientation.landscape){
      height=MediaQuery.of(context).size.width;
      width=MediaQuery.of(context).size.height;
    }
    return Scaffold(

      appBar: AppBar(title:Text('البث المباشر')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(

              height: height*.5,
                width: width,

                child: Html(
                    data: streamUrl,),





            ),

            Material(
              color: color3,
              borderRadius: BorderRadius.circular(20),
              elevation: 3,
              child: InkWell(
                onTap: ()async{
                  Uri url = Uri.parse('https://www.al-rehaili.net/online?parent=9');
                  var launchMode=LaunchMode.inAppWebView;
                  if (Platform.isIOS) {

                    if (await canLaunchUrl(url)) {await launchUrl( url,mode:launchMode );} else {throw 'Could not launch ';}
                  }
                  else {

                    if (await canLaunchUrl(url)) {await launchUrl(url,mode:launchMode );} else {throw 'Could not launch $url';}


                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: SizedBox(
                    child: Text('فتح فى المتصفح'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),



      bottomNavigationBar: const MyBottom(index: 4),

    );
  }
}
