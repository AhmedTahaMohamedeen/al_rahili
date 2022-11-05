import 'package:bota/models/child_model.dart';
import 'package:bota/screens/videos/all_videos_screen.dart';
import 'package:flutter/material.dart';

import '../../constants/my_bottom.dart';
import '../../main.dart';

class CoursesScreen extends StatefulWidget {
  static const String route='/CoursesScreen';
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {

  String title='المحاضرات المرئيه';
  List<MyChild>? children;
  getChildren()async{
    var children1=await MyChild().getChildren(url2: 'video/181');
    debugPrint('children length= ${children1.length}');
    setState(
        (){
          children=children1;
        }
    );
    
  }
  
  @override
  initState(){
    super.initState();
    getChildren();
    
  }
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
        title: Text(title),
      ),


      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              children==null?const SizedBox():
              Column(
                children: children!.map((e) =>          item(height: height, width: width, name: e.name!,id: e.id!)//id=cat_id
                ).toList(),
              ),




            ],

          ),
        ),
      ),
      bottomNavigationBar:const MyBottom(index: 1),




    );
  }


  Widget item({required double height,required double width,required String name,required String id}){
    return
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: InkWell(
          onTap:(){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AllVideosScreen(title: title,catId: id,)));//id=cat_id
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:  height*.09
            ),
            child: Container(
             // height: height*.08,
              width: width,
              decoration:const BoxDecoration(
                  color: color4,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topLeft:  Radius.circular(10),


                  )

              ),
              padding: const EdgeInsets.symmetric(vertical: 5),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back_ios,color: Colors.white),
                  ),
                  Expanded(
                    child: Padding(
                      padding:  const EdgeInsets.only(right: 10),
                      child: Text(name,style: TextStyle(color: color8,fontSize: height*.018,fontWeight: FontWeight.bold,fontFamily: Theme.of(context).primaryTextTheme.titleLarge!.fontFamily),textAlign: TextAlign.end),
                    ),
                  ),



                ],
              ),
            ),
          ),
        ),
      )
    ;
  }

}

