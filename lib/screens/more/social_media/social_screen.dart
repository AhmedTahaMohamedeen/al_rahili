import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';

class SocialScreen extends StatefulWidget {
  static const String route='SocialScreen/';
  const SocialScreen({Key? key}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    if(MediaQuery.of(context).orientation==Orientation.landscape){
      height=MediaQuery.of(context).size.width;
      width=MediaQuery.of(context).size.height;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('السوشيال')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap:  () async{
              Uri url = Uri.parse('https://www.al-rehaili.net/');
              var launchMode=LaunchMode.externalApplication;
              if (Platform.isIOS) {

                if (await canLaunchUrl(url)) {await launchUrl( url,mode:launchMode );} else {throw 'Could not launch ';}
              }
              else {

                if (await canLaunchUrl(url)) {await launchUrl(url,mode:launchMode );} else {throw 'Could not launch $url';}


              }


            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                      elevation: 5,
                      color: color2,type: MaterialType.circle,

                      child: Image(image: const AssetImage('assets/images/homeImages/homeLogo.png') ,width: width*.4)),
                ),
                const Text('الموقع الرسمى',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 20),)
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Material(
                borderRadius: BorderRadius.circular(20),
                color: color2,
                elevation: 10,
                child: InkWell( onTap:  () async{
                  Uri url = Uri.parse('https://www.facebook.com/rehyli');
                  Uri url2 = Uri.parse('facebook://www.facebook.com/rehyli');
                  var launchMode=LaunchMode.externalApplication;
                  if (Platform.isIOS) {

                    if (await canLaunchUrl(url)) {await launchUrl( url,mode:launchMode );} else {throw 'Could not launch ';}
                  }
                  else {



                    if (await canLaunchUrl(url2)) {await launchUrl(url2,mode:launchMode );}
                    else if(await canLaunchUrl(url)) {await launchUrl(url,mode:launchMode );}

                    else {throw 'Could not launch $url2';}


                  }


                },

                  child: Image(image: const AssetImage('assets/images/icons/social/facebook.png') ,width: width*.2),
                ),
              ),
              InkWell(
                onTap:  () async{
                  Uri url = Uri.parse('https://www.youtube.com/user/rehyli');
                  Uri url2 = Uri.parse('youtube://www.youtube.com/user/rehyli');
                  var launchMode=LaunchMode.externalApplication;
                  if (Platform.isIOS) {

                    if (await canLaunchUrl(url)) {await launchUrl( url,mode:launchMode );} else {throw 'Could not launch ';}
                  }
                  else {
                    if (await canLaunchUrl(url2)) {await launchUrl(url,mode:launchMode);}
                    else if(await canLaunchUrl(url)) {await launchUrl(url,mode:launchMode );}
                    else {throw 'Could not launch $url & $url2';}
                  }


                },
                child: Image(image: const AssetImage('assets/images/icons/social/youtube2.png'),width: width*.2),
              ),
              Material(
                borderRadius: BorderRadius.circular(20),
                color: color2,
                elevation: 10,
                child: InkWell(
                  onTap:  () async{
                    Uri url = Uri.parse('https://twitter.com/rehyli');
                    Uri url2 = Uri.parse('twitter://twitter.com/rehyli');
                    var launchMode=LaunchMode.externalApplication;
                    if (Platform.isIOS) {

                      if (await canLaunchUrl(url)) {await launchUrl( url,mode:launchMode );} else {throw 'Could not launch ';}
                    }
                    else {

                      if (await canLaunchUrl(url2)) {await launchUrl(url2,mode:launchMode );}
                      else if(await canLaunchUrl(url)) {await launchUrl(url,mode:launchMode );}
                      else {throw 'Could not launch $url2  & $url';}
                    }


                  },
                  child: Image(image: const AssetImage('assets/images/icons/social/twitter.png'),width: width*.2),
                ),
              ),
            ],
          ),



        ],
      ),
    );
  }
}