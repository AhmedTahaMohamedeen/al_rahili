import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:bota/screens/more/ads/ads_screen.dart';
import 'package:bota/screens/more/favourites/favourite_screen.dart';
import 'package:bota/screens/more/info/info_screen.dart';
import 'package:bota/screens/more/rate/rate_screen.dart';
import 'package:bota/screens/more/share/share_screen.dart';
import 'package:bota/screens/more/social_media/social_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/my_bottom.dart';
import '../../main.dart';
import 'favourites/albums_screen.dart';
import 'live_stream/live_screen.dart';
import 'monthly/monthly_screen.dart';

class MoreScreen extends StatefulWidget {
  static const String route='/MoreScreen';
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    if(MediaQuery.of(context).orientation==Orientation.landscape){
      height=MediaQuery.of(context).size.width;
      width=MediaQuery.of(context).size.height;
    }
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('المزيد',style: TextStyle(fontSize: 20),),
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Row(
              children: [
                item(
                  height: height, width: width,
                  name: 'ترجمه الشيخ',
                  onTap: ()async{
                    Navigator.pushNamed(context, InfoScreen.route);

                    },
                  iconImage: 'assets/images/icons/details.png'


                ),
                item(
                    height: height, width: width,
                    name: 'الكلمات الشهريه',
                    onTap: (){Navigator.pushNamed(context, MonthlyScreen.route);},
                    iconImage: 'assets/images/icons/notes.png'


                ),
              ],
            ),
            Row(
              children: [
                item(
                  height: height, width: width,
                  name: 'المفضله',
                  onTap: (){Navigator.pushNamed(context, AlbumsScreen.route);},
                  iconImage: 'assets/images/icons/favourites.png'


                ),
                item(
                    height: height, width: width,
                    name: 'الإعلانات',
                    onTap: (){Navigator.pushNamed(context, AdsScreen.route);},
                    iconImage: 'assets/images/icons/broadCast.png'


                ),
              ],
            ),
            Row(
              children: [
                item(
                  height: height, width: width,
                  name: 'البث المباشر',
                  onTap: (){Navigator.pushNamed(context,LiveScreen.route);},
                  iconImage: 'assets/images/icons/liveStream.png'


                ),
                item(
                    height: height, width: width,
                    name: 'مشاركه التطبيق',
                    onTap: (){Navigator.pushNamed(context, ShareScreen.route);},
                    iconImage: 'assets/images/icons/share.png'


                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

               Expanded(
                   flex: 1,
                   child: SizedBox()),
                item(
                  height: height, width: width,
                  name: 'قيم التطبيق',
                  onTap: (){Navigator.pushNamed(context, RateScreen.route);},
                  iconImage: 'assets/images/icons/star.png'


                ),
                Expanded(
                  flex: 1,

                    child: SizedBox()),

              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  socialItem(image: 'site',myUrl: 'https://www.al-rehaili.net/'),
                  socialItem(image: 'facebook',myUrl: 'https://www.facebook.com/rehyili'),
                  socialItem(image: 'telegram',myUrl: 'https://t.me/rehyli'),
                  socialItem(image: 'twitter',myUrl: 'https://twitter.com/rehyli'),
                  socialItem(image: 'whatsapp',myUrl: 'https://api.whatsapp.com/send/?phone=966583088912' //'whatsapp://send?phone=+966583088912'
                  ),
                  socialItem(image: 'youtube2',myUrl: 'https://www.youtube.com/channel/UCBc5AoNVZ4dIz-WFJogM-Ww'),
                ],
              ),
            )




          ],

        ),
      ),
      bottomNavigationBar:const MyBottom(index: 5),

    );
  }

  socialItem({required String image,required String myUrl}){
    return  Expanded(

      child: InkWell(
        onTap:  () async{
          Uri url = Uri.parse(myUrl);
          var launchMode=LaunchMode.externalApplication;
          if (Platform.isIOS) {

            if (await canLaunchUrl(url)) {await launchUrl( url,mode:launchMode );} else {throw 'Could not launch ';}
          }
          else {
            if (await canLaunchUrl(url)) {await launchUrl(url,mode:launchMode );} else {throw 'Could not launch $url';}


          }


        },
        child: Roulette(

          infinite: true,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage('assets/images/icons/social/$image.png'),
              color: color4,

            ),
          ),
        ),
      ),
    );
  }


  Widget item({required double height,required double width,required  String iconImage,required String name,required VoidCallback onTap}){
    return
      Expanded(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: height*.15,
              width: width*.4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)
            ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration:const BoxDecoration(
                          color: color3,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10) )
                      ),
                      alignment: Alignment.center,
                      child: Image(image: AssetImage(iconImage),height: 40,width: 40,color: color5,),

                    ),
                  ),
                  Expanded(
                      child: Container(
                        height: height,
                        width: height,
                        alignment: Alignment.center,

                        decoration:const BoxDecoration(
                          color: color4,
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10) )

                        ),
                        child: Text(name,style: TextStyle(color: color8,fontSize: height*.022,fontWeight: FontWeight.bold,fontFamily: Theme.of(context).primaryTextTheme.titleLarge!.fontFamily) ,),


                      )),
                ],
              ),
            ),
          ),
        ),
      )
    ;
  }

}
