import 'package:flutter/material.dart';

import '../../constants/my_bottom.dart';
import '../../main.dart';
import '../../models/child_model.dart';
import '3qdia2.dart';

class Eqdia1 extends StatefulWidget {
  static const String route='/Eqdia1';

  const Eqdia1({Key? key}) : super(key: key);

  @override
  State<Eqdia1> createState() => _Eqdia1State();
}

class _Eqdia1State extends State<Eqdia1> {
  List<MyChild>? children;
  getChildren()async{
    var children1=await MyChild().getChildren(url2: 'munahaj_eaqdi/84');
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
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title:  const Text( ' أقسام المناهج العقديه}',style: TextStyle(fontSize: 20),),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              children==null?const SizedBox(): Column(
                children:
                  children!.map((e) => item(height: height, width: width, name: e.name!,id: e.id!), )


                      .toList(),
              ),





            ],

          ),
        ),
      ),
      bottomNavigationBar:const MyBottom(index: 2),

    );
  }



  Widget item({required double height,required double width,required String name,required String id}){
    return
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: InkWell(
          onTap:(){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Eqdia2(title:name,catId: id, )));//id=cat_id
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
