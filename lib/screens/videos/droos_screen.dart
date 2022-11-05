import 'package:flutter/material.dart';

import '../../constants/my_bottom.dart';
import '../../main.dart';
import 'all_videos_screen.dart';
import 'courses_screen.dart';

class DroosVideosScreen extends StatefulWidget {
  static const String route='/VideosScreen';
  const DroosVideosScreen({Key? key}) : super(key: key);

  @override
  State<DroosVideosScreen> createState() => _DroosVideosScreenState();
}

class _DroosVideosScreenState extends State<DroosVideosScreen> {
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
        title: const Text('دروس مرئيه',style: TextStyle(fontSize: 20),),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              item(height: height, width: width, name: 'الدورات العلميه المرئيه', onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const CoursesScreen(),));}),
              item(height: height, width: width, name: 'المحاضرات المرئيه', onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const AllVideosScreen(title:'المحاضرات المرئيه',catId: '182'),));}),
              item(height: height, width: width, name: 'الكلمات التوجيهيه المرئيه', onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const AllVideosScreen(title:'الكلمات التوجيهيه المرئيه',catId: '183'),));}),




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
