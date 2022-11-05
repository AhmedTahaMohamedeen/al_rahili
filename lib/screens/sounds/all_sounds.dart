import 'dart:convert';
import 'dart:io';

import 'package:bota/constants/my_bottom.dart';
import 'package:bota/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/media_model.dart';
import 'player_screen.dart';

class AllSoundsScreen extends StatefulWidget {
  static const String route='/AllSoundsScreen';
  final String title;
  final String catId;
  final String catName;
  const AllSoundsScreen({Key? key, required this.title, required this.catId, required this.catName}) : super(key: key);

  @override
  State<AllSoundsScreen> createState() => _AllSoundsScreenState();
}

class _AllSoundsScreenState extends State<AllSoundsScreen> {



  List<Media>?sounds;
  List<String>?idsList;
  String moreUrl='';


  getAllSounds()async{
    Map<String, dynamic> myMap=await Media().getAllSounds(url2:'${widget.catName}/${widget.catId}');
    var sounds1= myMap['media'] ;
    setState((){
      sounds=sounds1;
      moreUrl=myMap['moreUrl'];
    });
    debugPrint(sounds1[0].title.toString());
    debugPrint(sounds1[0].shortDescription.toString());
  }

  getMoreMedia()async{
    print(moreUrl);
    if(moreUrl.isNotEmpty){
      Map<String, dynamic> moreMap=await Media().getMoreMedia(moreUrl: moreUrl);
      List<Media> moreMedia=moreMap['media'];
      setState(() {
        sounds!.addAll(moreMedia);
        moreUrl=moreMap['moreUrl'];
      });

    }

  }

  @override
  initState(){
    super.initState();
    getAllSounds();
    myController.addListener(() {myListener();});

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
        title:  Text(widget.title,style: const TextStyle(fontSize: 20),),
      ),
      body:

      sounds==null?const Center(child: CircularProgressIndicator(color: color4,),):
      CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: const SizedBox(),
            toolbarHeight:  height*.1,
            flexibleSpace:  Center(
              child:  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: MySearchMediaTextField(


                  myController: myController,
                  onChange: (s){search();},),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => searchedSoundItem(width: width,height: height,index: index),
                childCount: searchedMedia.length,


              ),






            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if(index==sounds!.indexOf(sounds!.last)){
                      getMoreMedia();
                    }


                    return  soundItem(width: width,height: height,index: index);},
              childCount: sounds!.length,


            ),






          ),
          SliverList(
              delegate:SliverChildListDelegate(

                  [
                    moreUrl.isNotEmpty?Center(child: CircularProgressIndicator(color: color5,))

                        : const SizedBox()


                  ]
              )










          ),
        ],
      ),



      bottomNavigationBar: const MyBottom(index: 2),
    );
  }

  soundItem({required double height,required double width,required int index}){
   // debugPrint('  \n \n \n soundCloud url: ${jsonDecode(sound.shortDescription!)} \n \n \n');

bool soundCloud=sounds![index].mediaUrl=='null'?true:false;


  return
    InkWell(
      onTap: ()async{
        if(soundCloud){

          var des=sounds![index].shortDescription;
          int? x=des?.indexOf('src="');
          int? y=des?.indexOf('"><');
          var src=des!.substring(x!+5,y);
         // debugPrint(x.toString());
         // debugPrint(y.toString());
          debugPrint(src.toString());

          debugPrint('going to soundCloud');
         // debugPrint('${sound.shortDescription}');

          Uri url = Uri.parse(src);
          var launchMode=LaunchMode.externalApplication;

          if (Platform.isIOS) {

            if (await canLaunchUrl(url)) {await launchUrl( url,mode:launchMode );} else {throw 'Could not launch ';}
        }
        else {

        if (await canLaunchUrl(url)) {await launchUrl(url,mode:launchMode );} else {throw 'Could not launch $url';}


        }



        }
        else{


          Navigator. push(context,  MaterialPageRoute<void>(builder: (context) =>  PlayerScreen(sounds: sounds!,index: index),),

          )
          ;}

      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
        child: Material(
          color: color1,
          elevation: 3,
          child: SizedBox(

            height: height*.08,
            width: width,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                const Expanded(
                    flex: 1,

                    child: Icon(Icons.play_circle_fill)),
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
                            child: SizedBox(
                                child: Text(sounds![index].title!,
                                  style: TextStyle(fontSize: height*.016,fontWeight: FontWeight.bold,color: Colors.black.withOpacity(.7)),maxLines: 2,textAlign: TextAlign.right,)),
                          ),
                        ),

                         Expanded(
                            flex: 1,
                            child: Image(image:  AssetImage(soundCloud?'assets/images/icons/soundcloud.png':'assets/images/icons/mp3.png'),
                              height: 25,width: 25,color: soundCloud?Colors.deepOrange:color4,)),],
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

  searchedSoundItem({required double height,required double width,required int index}){

    bool soundCloud=sounds![index].mediaUrl=='null'?true:false;


    return
      InkWell(
        onTap: ()async{
          if(soundCloud){

            var des=searchedMedia[index].shortDescription;
            int? x=des?.indexOf('src="');
            int? y=des?.indexOf('"><');
            var src=des!.substring(x!+5,y);
            // debugPrint(x.toString());
            // debugPrint(y.toString());
            debugPrint(src.toString());

            debugPrint('going to soundCloud');
            // debugPrint('${sound.shortDescription}');

            Uri url = Uri.parse(src);
            var launchMode=LaunchMode.externalApplication;

            if (Platform.isIOS) {

              if (await canLaunchUrl(url)) {await launchUrl( url,mode:launchMode );} else {throw 'Could not launch ';}
            }
            else {

              if (await canLaunchUrl(url)) {await launchUrl(url,mode:launchMode );} else {throw 'Could not launch $url';}


            }



          }
          else{


            Navigator. push(context,  MaterialPageRoute<void>(builder: (context) =>  PlayerScreen(sounds: searchedMedia,index: index),),

            )
            ;}

        },
        child: Material(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: height*.08,
              width: width,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Expanded(
                      flex: 1,

                      child: Icon(Icons.play_circle_fill)),
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
                              child: SizedBox(
                                  child: Text(searchedMedia[index].title!,
                                    style: TextStyle(fontSize: height*.016,fontWeight: FontWeight.bold),maxLines: 2,textAlign: TextAlign.right,)),
                            ),
                          ),

                          Expanded(
                              flex: 1,
                              child: Image(image:  AssetImage(soundCloud?'assets/images/icons/soundcloud.png':'assets/images/icons/mp3.png'),
                                height: 25,width: 25,color: soundCloud?Colors.deepOrange:color4,)),
                        Expanded(
                          child: Icon(Icons.search,color: Colors.black.withOpacity(.3),),
                        )],
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




List<Media>searchedMedia=[];
  String mySearchText='';
  TextEditingController myController=TextEditingController();
  myListener(){
    setState(() {
      mySearchText=myController.text;

    });
  }

  search(){

    searchedMedia.clear();
    if(mySearchText==''){return;}
    for(var x in sounds!){
      if(x.title!.contains(mySearchText))
      {

        setState(() {
          searchedMedia.add(x);
        });

      }
    }
    debugPrint('searchedMedia${searchedMedia.length}');
    debugPrint(mySearchText);

  }




}




class MySearchMediaTextField extends StatelessWidget {

  double borderWidth = 1;
  Color borderColor = Colors.white.withOpacity(0);
  Color fillColor = Colors.white.withOpacity(1);
  double borderRadus = 10;

  TextStyle inputTextStyle=TextStyle(color: Colors.black, fontSize:16);
  TextStyle labelTextStyle=TextStyle(color: Colors.black.withOpacity(.4), fontSize:16,);




  TextEditingController? myController ;
  //final String label;
  // final Icon icon;
 // final bool obsecure;
 // final TextInputType input;


 // final String? Function(String?) vFuntion;
 // final  String? Function(String?) sFuntion;
  final   Function(String?) onChange;

  //Function ontapFunction;

  MySearchMediaTextField({Key? key,
    //required this.label,
   // this.obsecure = false,
    required this.onChange ,
    // required this.icon,
   // required this.vFuntion,
   // required this.sFuntion,
    this.myController,
   // required this.input


  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: inputTextStyle,
      onChanged: onChange,

      decoration: InputDecoration(
          fillColor:fillColor,



          filled: true,
          isCollapsed: true,
          contentPadding: const EdgeInsets.only(bottom: 10,top: 10,left: 5,right: 5),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
         // labelText: 'بحث',
          // labelStyle: labelTextStyle,
           prefixIcon: Icon(Icons.search),
          hintText: 'بحث',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadus),
            borderSide: BorderSide(color: borderColor, width: borderWidth),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadus),
            borderSide: BorderSide(color: borderColor, width: borderWidth),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadus),
            borderSide: BorderSide(color: borderColor, width: borderWidth),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadus),
            borderSide: BorderSide(color: borderColor, width: borderWidth),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadus),
            borderSide: BorderSide(color: borderColor, width: borderWidth),
          )),

      //obscureText: obsecure,
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
      enabled: true,


     // validator:vFuntion ,
     // onSaved:sFuntion ,
      // onTap: ontapFunction,
      controller: myController,
    );
  }

/*
  validator:( String v){
  if(v.isEmpty){return 'wrong';}
  return  null;
  }
   */
/*
 onPressed:(){if (!formKey.currentState.validate()) {return;}
                    formKey.currentState.save();
                    }
 */
}
