import 'package:bota/screens/videos/droos_screen.dart';
import 'package:bota/screens/videos/fatawy1_screen.dart';
import 'package:flutter/material.dart';

import '../../constants/my_bottom.dart';
import '../../main.dart';
import 'all_videos_screen.dart';
import 'courses_screen.dart';

class VideosScreen0 extends StatefulWidget {
  static const String route='/VideosScreen0';
  const VideosScreen0({Key? key}) : super(key: key);

  @override
  State<VideosScreen0> createState() => _VideosScreen0State();
}

class _VideosScreen0State extends State<VideosScreen0> {
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    if(MediaQuery.of(context).orientation==Orientation.landscape){
      height=MediaQuery.of(context).size.width;
      width=MediaQuery.of(context).size.height;
    }
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: const Text('المرئيات',style: TextStyle(fontSize: 20),),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
/*
              Center(
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                    child: Material(
                      elevation: 5,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: height*.05,
                        width: width*.9,

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            Text('بحث',style: TextStyle(fontFamily: Theme.of(context).primaryTextTheme.titleLarge!.fontFamily,color: Colors.black.withOpacity(.7)),),
                            Padding(
                              padding: const EdgeInsets.only(right: 5,left: 5),
                              child: Icon(Icons.search,color: Colors.black.withOpacity(.5)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
*/
              item(height: height, width: width, name: 'دروس مرئيه', onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const DroosVideosScreen(),));}),
              item(height: height, width: width, name: 'فوائد الدروس', onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AllVideosScreen(title:'فوائد الدروس',catId: '86'),));
              }),
              item(height: height, width: width, name: 'الفتاوى', onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const Fatawy1Screen(),));}),




            ],

          ),
        ),
      ),
      bottomNavigationBar:const MyBottom(index: 1),

    );
  }
  Widget item({required double height,required double width,required String name,required VoidCallback onTap}){
    return
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: InkWell(
          onTap:onTap,
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
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            topLeft:  Radius.circular(10),


                          )

                      ),
                      child: Padding(
                        padding:  const EdgeInsets.only(right: 10),
                        child: Text(name,style: TextStyle(color: color8,fontSize: height*.022,fontWeight: FontWeight.bold,fontFamily: Theme.of(context).primaryTextTheme.titleLarge!.fontFamily),),
                      ),


                    )),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration:const BoxDecoration(
                        color: color3,
                        borderRadius: BorderRadius.only(
                          bottomRight:  Radius.circular(10),
                          topRight:   Radius.circular(10),


                        )

                    ),
                    alignment: Alignment.center,
                    child:const Image(image:  AssetImage('assets/images/icons/youtube.png'),height: 50,width: 50,color: color4),

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
