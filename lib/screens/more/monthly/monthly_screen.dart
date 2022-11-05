import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../constants/my_bottom.dart';
import '../../../main.dart';
import '../../../models/media_model.dart';
import 'monthly_review.dart';

class MonthlyScreen extends StatefulWidget {
  static const String route='MonthlyScreen/';
  const MonthlyScreen({Key? key}) : super(key: key);

  @override
  State<MonthlyScreen> createState() => _MonthlyScreenState();
}

class _MonthlyScreenState extends State<MonthlyScreen> {

  List<Media>? monthlyWords;


  getAllMonthlyWords()async{
    var monthlyWords1=await Media().getAllMonthlyWords(url2:'monthly/8');
    setState((){
      monthlyWords=monthlyWords1.reversed.toList();
    });
    // debugPrint(sounds1[0].toString());
  }



  @override
  initState(){
    super.initState();
    getAllMonthlyWords();

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
        title:  const Text('الكلمات الشهريه',style: TextStyle(fontSize: 20),),
      ),
      body: monthlyWords==null?const SizedBox():ListView.separated(
        itemBuilder: (context, index) => monthlyItem(width: width,height: height,index: index),
        itemCount: monthlyWords!.length,
        separatorBuilder:(context,i2)=>const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(height: 10,thickness: .5,color: Colors.black,),
        ),




      ),



      bottomNavigationBar: const MyBottom(index: 5),
    );
  }

  monthlyItem({required double height,required double width,required int index}){
    // debugPrint('  \n \n \n soundCloud url: ${jsonDecode(sound.shortDescription!)} \n \n \n');



    return
      InkWell(
        onTap: ()async{


            Navigator.push(context, MaterialPageRoute(builder: (context) =>  MonthlyReview(title:monthlyWords![index].title!,post: monthlyWords![index].description!, ),));

        },
        child: Padding(
          padding: const EdgeInsets.all( 8),
          child: Material(
            elevation: 3,
            color: color2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Expanded(
                      flex: 1,

                      child: Icon(Icons.arrow_back_ios_new,color: color5,)),
                  Expanded(
                    flex: 8,

                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Column(
                                children: [
                                  SizedBox(
                                      child:
                                      Text(monthlyWords![index].title!, style: TextStyle(fontSize: height*.016,fontWeight: FontWeight.bold),maxLines: 1,textAlign: TextAlign.right,)),


                        ],
                              ),
                            ),
                          ),

                         ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      )
    ;









  }
}
