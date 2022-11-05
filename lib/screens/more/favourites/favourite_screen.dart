import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../constants/my_bottom.dart';
import '../../../constants/my_flush.dart';
import '../../../main.dart';
import '../../../models/album_model.dart';
import '../../../models/database_helper.dart';
import '../../../models/media_model.dart';
import '../../books/book_review.dart';
import '../../sounds/player_screen.dart';
import '../../videos/video_player_screen.dart';

class FavouriteScreen extends StatefulWidget {
  static const String route='FavouriteScreen/';

  final Album album;

  const FavouriteScreen({Key? key, required this.album}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<Media>? favourites;
  getAllFav()async{
    var favourites1=await DbHelper().getFavByAlbum(kind: widget.album.kind!, album:widget.album.name!);
     setState((){
       favourites=favourites1;
     });

  }


  @override
  void initState() {
    super.initState();
    getAllFav();
  }

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return
      favourites ==null ?Scaffold(
      appBar: AppBar(title:  Text(widget.album.name!)),
          body:const Center(child: CircularProgressIndicator(color: color3),)
      ):


      Scaffold(
        appBar: AppBar(title:  Text(widget.album.name!)),



        body:widget.album.kind=='books'?GridView.builder(
          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: height*.0008,

          ),
          itemBuilder: (context, index) => bookItem(book:favourites![index] ),
          itemCount: favourites!.length,
          padding: const EdgeInsets.all(10),



        ):

        ListView.separated(
          itemBuilder: (context, index) =>item(media:favourites![index],index: index ) ,
          itemCount: favourites!.length,
          separatorBuilder:(context,i2)=>const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: .5,thickness: .5,color: Colors.black,),
          ),
        ) ,



        bottomNavigationBar:const MyBottom(index: 5),
      );


  }





  Widget videoItem({required String url,required String title,required int index}){
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    String? id=YoutubePlayer.convertUrlToId(url);
    String? image=YoutubePlayer.getThumbnail(videoId: id!,quality:ThumbnailQuality.standard );
    //String image='https://img.youtube.com/vi/$id/hqdefault.jpg';
    return InkWell(
      onLongPress: ()async{
       await showDialog(context: context, builder:(context)=>Dialog(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
          child:Material(
            color: Colors.white.withOpacity(0),

            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: height*.2,

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children:const [
                        Center(child:  Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('مسح ؟',style: TextStyle(color: Colors.white)),
                        )),
                        Divider(height:  1,color: color1,thickness: 1,),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: ()async{
                          await DbHelper().deleteFav(id:int.parse( favourites![index].id!)).whenComplete(() => Navigator.pop(context));
                          MyFlush().showDoneFlush(context: context, text: 'تم الحذف');

                        },
                        style:ButtonStyle(backgroundColor:MaterialStateProperty.all(color6)) ,
                        child:const Padding(
                          padding:  EdgeInsets.symmetric(vertical: 8.0,horizontal: 24),
                          child: Text('مسح',style: TextStyle(color: color1,fontWeight: FontWeight.bold)),
                        ),


                      ),
                    )
                  ],
                ),
              ),
            ),
          ) ,

        )).whenComplete(() => getAllFav());
      },
      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) =>  VideoScreen(index: index,videos: favourites!),));},
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(

          height: height*.1,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color3,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                flex: 3,

                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Text(title,style: const TextStyle(fontWeight: FontWeight.bold),maxLines: 3,overflow:TextOverflow.clip ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: height*.1,
                  width: width*.2,
                  foregroundDecoration:BoxDecoration(
                      image: DecorationImage(
                        image:  CachedNetworkImageProvider(image),

                      )
                  ),
                  decoration:  const BoxDecoration(
                      image:  DecorationImage(
                          image:   AssetImage('assets/images/icons/youtube.png',),opacity:.5

                      )
                  ),

                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget soundItem({required int index}){
    // debugPrint('  \n \n \n soundCloud url: ${jsonDecode(sound.shortDescription!)} \n \n \n');

    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;


    return
      InkWell(
        onLongPress: ()async{
        await   showDialog(context: context, builder:(context)=>Dialog(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
            child:Material(
              color: Colors.white.withOpacity(0),

              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: height*.2,

                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children:const [
                          Center(child:  Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('مسح ؟',style: TextStyle(color: Colors.white)),
                          )),
                          Divider(height:  1,color: color1,thickness: 1,),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: ()async{
                            await DbHelper().deleteFav(id:int.parse( favourites![index].id!)).whenComplete(() =>Navigator.pop(context));
                            MyFlush().showDoneFlush(context: context, text: 'تم الحذف');
                          },
                          style:ButtonStyle(backgroundColor:MaterialStateProperty.all(color6)) ,
                          child:const Padding(
                            padding:  EdgeInsets.symmetric(vertical: 8.0,horizontal: 24),
                            child: Text('مسح',style: TextStyle(color: color1,fontWeight: FontWeight.bold)),
                          ),


                        ),
                      )
                    ],
                  ),
                ),
              ),
            ) ,

          )).whenComplete(() =>  getAllFav());
        },
        onTap: ()async{



            Navigator. push(context,  MaterialPageRoute<void>(builder: (context) =>  PlayerScreen(sounds: favourites!,index: index),),);

        },
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
                                child: Text(favourites![index].title!,
                                  style: TextStyle(fontSize: height*.016,fontWeight: FontWeight.bold),maxLines: 2,textAlign: TextAlign.right,)),
                          ),
                        ),

                        Expanded(
                            flex: 1,
                            child: Image(image:  AssetImage('assets/images/icons/mp3.png'),
                              height: 25,width: 25,color: color4,)),],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    ;









  }
  Widget bookItem({required Media book}){

    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return
      InkWell(
        onLongPress: ()async{
        await  showDialog(context: context, builder:(context)=>Dialog(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
            child:Material(
              color: Colors.white.withOpacity(0),

              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: height*.2,

                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children:const [
                          Center(child:  Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('مسح ؟',style: TextStyle(color: Colors.white)),
                          )),
                          Divider(height:  1,color: color1,thickness: 1,),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: ()async{
                            await DbHelper().deleteFav(id:int.parse( book.id!)).whenComplete(() => Navigator.pop(context));
                            MyFlush().showDoneFlush(context: context, text: 'تم الحذف');
                          },
                          style:ButtonStyle(backgroundColor:MaterialStateProperty.all(color6)) ,
                          child:const Padding(
                            padding:  EdgeInsets.symmetric(vertical: 8.0,horizontal: 24),
                            child: Text('مسح',style: TextStyle(color: color1,fontWeight: FontWeight.bold)),
                          ),


                        ),
                      )
                    ],
                  ),
                ),
              ),
            ) ,

          )).whenComplete(() => getAllFav());
        },
        onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) =>  BookReview(book:book ),));},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: color2,
            elevation: 5,
            borderRadius: BorderRadius.circular(10),

            child:Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children:  [
                  Expanded(
                      flex: 4,
                      child:
                      Container(decoration: const BoxDecoration(image:DecorationImage(image: AssetImage('assets/images/homeImages/homeLogo.png'),scale: 10,opacity: .4) ,),
                        foregroundDecoration: BoxDecoration(image: DecorationImage(image:CachedNetworkImageProvider(book.image!) )),
                        // Image(image:CachedNetworkImageProvider(book.image!),
                        //  AssetImage('assets/images/homeImages/homeLogo.png'),
                      )),
                  Expanded(
                      flex: 1,


                      child: SizedBox(
                          child: Center(child: Text(book.title!,maxLines: 2,textAlign: TextAlign.center,style: TextStyle(fontSize: height*.016,fontWeight: FontWeight.bold),))
                      ))
                ],
              ),
            ) ,
          ),
        ),
      );


  }

  Widget item({required int index ,required Media media}){
    if(widget.album.kind=='videos'){return videoItem(url: media.mediaUrl!, title: media.title!, index: index);}
    else {return soundItem(index: index) ;}



}








}