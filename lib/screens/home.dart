
import 'package:bota/main.dart';
import 'package:bota/screens/sounds/sounds_screen.dart';
import 'package:bota/screens/videos/videos_screen0.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:marquee/marquee.dart';


import '../test_screen.dart';
import 'books/books_screen.dart';
import 'more/live_stream/live_screen.dart';
import 'more/mores_screen.dart';
class Home extends StatefulWidget {
  static const String route='/Home';
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>with WidgetsBindingObserver {




  @override

  @override
  Widget build(BuildContext context) {

    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;


    return Scaffold(


      body: Stack(


        children:  [
           const Positioned(
             top: 0,right: 0,bottom: 0,left: 0,
             child: Image(image: AssetImage('assets/images/homeImages/homeBackgriund.png'),fit: BoxFit.fill),),




          Positioned(
            top: height*.18,right: width*.05,bottom: 0,left: width*.05,
            child: Column(
              children:  [




                SizedBox(
                    height: height*.12,
                    width: height*.12,
                    child: const Image(image: AssetImage('assets/images/homeImages/homeLogo.png'),fit: BoxFit.fill)),
                SizedBox(
                    height: height*.08,
                    width: width*.6,


                    child: const Image(image: AssetImage('assets/images/homeImages/homeLogo2.png'),fit: BoxFit.fill)),
                SizedBox(height: height*.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    item(
                        height: height,
                        width: width,
                        name: 'مرئيات',
                        borderRadius: const BorderRadius.only(bottomRight:  Radius.circular(20)),
                      iconImage: 'assets/images/icons/youtube.png',
                      isUp: true,
                      onTap: (){Navigator.pushNamed(context, VideosScreen0.route);}

                    ),
                    item(
                        height: height,
                        width: width,
                        name: 'صوتيات',
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20)),
                        iconImage: 'assets/images/icons/soundcloud.png',
                        isUp: true,
                        onTap: (){Navigator.pushNamed(context, SoundsScreen.route);}

                    ),




                  ],
                ),

                Row( mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    item(
                        height: height,
                        width: width,
                        name: 'البث المياشر',
                        borderRadius: const BorderRadius.only(topRight:  Radius.circular(20)),

                        iconImage: 'assets/images/icons/broadCast.png',
                        isUp: false,
                        onTap: (){Navigator.pushNamed(context, LiveScreen.route);}

                    ),
                    item(
                        height: height,
                        width: width,
                        name: 'الكتب والرسائل',
                        borderRadius: const BorderRadius.only(topLeft:  Radius.circular(20)),

                        iconImage: 'assets/images/icons/books.png',
                        isUp: false,
                        onTap: (){Navigator.pushNamed(context, BooksScreen.route);}

                    )
                  ],
                ),

                moreItem(
                    height: height,
                    width: width,

                    iconImage:'assets/images/icons/more.png',
                name: 'المزيد'
                )

              ],
            ),),
            Positioned(
              top: 45,
             left: 30,
             right: 30,
             // width: width,
              //height: 100,
              child:
            Container(

              decoration: BoxDecoration(
                color: color2,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color3,width: 2)
              ),
              height: height*.05,
              width: width*.8,

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Marquee(
                  text: ' سبحان الله وبحمده سبحان الله العظيم',
                  style: TextStyle(fontWeight: FontWeight.w600,color: color7,fontFamily: Theme.of(context).primaryTextTheme.titleLarge!.fontFamily,),
                  scrollAxis: Axis.horizontal,
                  showFadingOnlyWhenScrolling: false,
                  blankSpace: 50,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  velocity: 30.0,
                  startPadding: 100,
                  textDirection: TextDirection.rtl,



                ),
              ),
            ),),




        ],
      ),

     /* floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, Testo.route);


        },
      ),*/



    );
  }

  // double _opacity=0;
  // final Duration _duration=const Duration(seconds: 5);

  Widget item({required double height,required double width,required  String iconImage,required String name,required BorderRadius borderRadius,required bool isUp,required VoidCallback onTap}){
    return
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
              onTap: onTap,
              child: Container(
                height: height*.14,
                width: width*.4,
                decoration: BoxDecoration(
                  borderRadius: borderRadius
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                       decoration:isUp? const BoxDecoration(
                         color: color3,

                       ):BoxDecoration(
                         color: color3,
                  borderRadius: borderRadius
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

                          decoration:isUp? BoxDecoration(
                            color: color4,
                            borderRadius: borderRadius
                          ):const BoxDecoration(
                              color: color4,

                          ),
                          child: Text(name,style: TextStyle(color: color8,fontSize: height*.025,fontWeight: FontWeight.bold,fontFamily: Theme.of(context).primaryTextTheme.titleLarge!.fontFamily) ,),


                        )),
                  ],
                ),
              ),
          ),
        ),
      )
      ;
  }

  Widget moreItem({required double height,required double width,required  String iconImage,required String name}){
    return
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: (){Navigator.pushNamed(context, MoreScreen.route);},
          child: SizedBox(
            height: height*.08,
            width: width,

            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      height: height,
                      width: height,
                      alignment: Alignment.centerRight,

                      decoration:const BoxDecoration(
                        color: color4,

                      ),
                      child: Padding(
                        padding:  const EdgeInsets.only(right: 10),
                        child: Text(name,style: TextStyle(color: color8,fontSize: height*.027,fontWeight: FontWeight.bold,fontFamily: Theme.of(context).primaryTextTheme.titleLarge!.fontFamily),),
                      ),


                    )),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration:const BoxDecoration(
                        color: color3,

                    ),
                    alignment: Alignment.center,
                    child: Image(image: AssetImage(iconImage),height: 40,width: 40,color: color5),

                  ),
                ),

              ],
            ),
          ),
        ),
      )
      ;
  }

}
