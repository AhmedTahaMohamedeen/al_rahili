import 'package:bota/models/media_model.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../models/child_model.dart';
import 'ad_review.dart';

class AdsScreen extends StatefulWidget {
  static const String route='AdsScreen/';
  const AdsScreen({Key? key}) : super(key: key);

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {

  List<Media>? ads;
  getAds()async{
    var ads1=await Media().getAllAds();
    setState((){ads=ads1;});
  }
  @override
  initState(){
    super.initState();
    getAds();
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
      appBar: AppBar(title: const Text('الاعلانات')),

      body:ads==null?Center(child: CircularProgressIndicator(color: color4),):

          ListView.builder(itemBuilder: (context, i) => item(height: height, width: width,  ad: ads![i]),itemCount: ads!.length,)
    );

  }



  Widget item({required double height,required double width,required Media ad}){
    return
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: InkWell(
          onTap:(){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AdReview(ad:ad ,)));//id=cat_id
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
                      child: Text(ad.title!,style: TextStyle(color: color8,fontSize: height*.018,fontWeight: FontWeight.bold,fontFamily: Theme.of(context).primaryTextTheme.titleLarge!.fontFamily),textAlign: TextAlign.end),
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
