import 'package:bota/screens/sounds/3qdia1.dart';
import 'package:flutter/material.dart';

import '../../constants/my_bottom.dart';
import '../../main.dart';
import 'all_sounds.dart';
import 'courses1.dart';

class SoundsScreen extends StatefulWidget {
  static const String route='/SoundsScreen';
  const SoundsScreen({Key? key}) : super(key: key);

  @override
  State<SoundsScreen> createState() => _SoundsScreenState();
}

class _SoundsScreenState extends State<SoundsScreen> {
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
        title: const Text('الصوتيات',style: TextStyle(fontSize: 20),),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              item(height: height, width: width, name: 'المحاضرات العلميه',onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const AllSoundsScreen(title:'المحاضرات العلميه' ,catId:'5' ,catName: 'lectures',),));}),
              item(height: height, width: width, name: 'الكلمات التوجيهيه', onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const AllSoundsScreen(title: 'الكلمات التوجيهيه',catId:'6' ,catName: 'kalemat',),));}),
              item(height: height, width: width, name: 'الدوره المنهجيه العقديه',onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const Eqdia1(),));} ),
              item(height: height, width: width, name: 'الدروس العلميه',onTap: (){Navigator.pushNamed(context, Courses1.route);} ),



            ],

          ),
        ),
      ),
      bottomNavigationBar:const MyBottom(index: 2),

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
                        child: Text(name,style: TextStyle(color: color8,fontSize: height*.027,fontWeight: FontWeight.bold,fontFamily: Theme.of(context).primaryTextTheme.titleLarge!.fontFamily),),
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
                    child:const Image(image:  AssetImage('assets/images/icons/soundcloud.png'),height: 40,width: 40,color: color4),

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



