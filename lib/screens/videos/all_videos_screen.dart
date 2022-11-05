
import 'package:bota/constants/my_bottom.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../main.dart';
import '../../models/media_model.dart';
import '../sounds/all_sounds.dart';
import 'video_player_screen.dart';

class AllVideosScreen extends StatefulWidget {
  static const String route='/AllVideosScreen';
  final String title;
  final String catId;

  const AllVideosScreen({Key? key, required this.title, required this.catId,}) : super(key: key);

  @override
  State<AllVideosScreen> createState() => _AllVideosScreenState();
}

class _AllVideosScreenState extends State<AllVideosScreen> {

  List<Media>?videos;
  String moreUrl='';

  getAllVideos()async{
    Map<String, dynamic> myMap=await Media().getAllVideos(catId: widget.catId);
   List<Media> videos1=myMap['media'] ;



    setState((){
      videos=videos1;
      moreUrl=myMap['moreUrl'];
    });
    debugPrint(videos1[0].title);

  }

  getMoreMedia()async{
    print(moreUrl);
    if(moreUrl.isNotEmpty){
      Map<String, dynamic> moreMap=await Media().getMoreMedia(moreUrl: moreUrl);
      List<Media> moreMedia=moreMap['media'];
      setState(() {
        videos!.addAll(moreMedia);
        moreUrl=moreMap['moreUrl'];
      });

    }

  }



  @override
  initState(){
    super.initState();
    getAllVideos();
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
      body:videos==null?const Center(child: CircularProgressIndicator(color: color5,),):

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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index)
                       {


                         return


                           searchedVideoItem(width: width,height: height,url:searchedMedia[index].mediaUrl!,title: searchedMedia[index].title!,index: index);},
                childCount: searchedMedia.length,


              ),






            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index)
                    {
                      if(index==videos!.indexOf(videos!.last)){
                        getMoreMedia();
                     }



                        return  videoItem(width: width,height: height,url:videos![index].mediaUrl!,title: videos![index].title!,index: index);


                 },
              childCount: videos!.length,


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
      )
        ,

      bottomNavigationBar: const MyBottom(index: 1),
    );
  }


  videoItem({required double height,required double width,required String url,required String title,required int index}){

    String? id=YoutubePlayer.convertUrlToId(url);
    String? image=YoutubePlayer.getThumbnail(videoId: id!,quality:ThumbnailQuality.standard );
    //String image='https://img.youtube.com/vi/$id/hqdefault.jpg';
    return InkWell(
      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) =>  VideoScreen(index: index,videos: videos!),));},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                  padding: const EdgeInsets.only(right: 15,left: 8),
                  child: Text(title,style:  TextStyle(fontWeight: FontWeight.bold,color: Colors.black.withOpacity(.8)),maxLines: 3,overflow:TextOverflow.clip ),
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
  searchedVideoItem({required double height,required double width,required String url,required String title,required int index}){

    String? id=YoutubePlayer.convertUrlToId(url);
    String? image=YoutubePlayer.getThumbnail(videoId: id!,quality:ThumbnailQuality.standard );
    //String image='https://img.youtube.com/vi/$id/hqdefault.jpg';
    return InkWell(
      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) =>  VideoScreen(index: index,videos: searchedMedia),));},
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
                          image:   AssetImage('assets/images/icons/youtube2.png',),opacity:.5

                      )
                  ),

                ),
              ),
              Expanded(
                child: Icon(Icons.search,color: Colors.black.withOpacity(.3),),
              )
            ],
          ),
        ),
      ),
    );
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
    for(var x in videos!){
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




