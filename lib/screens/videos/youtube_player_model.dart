import 'dart:io';

import 'package:bota/constants/my_flush.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../main.dart';
import '../../models/album_model.dart';
import '../../models/database_helper.dart';
import '../../models/media_model.dart';
import '../more/favourites/albums_screen.dart';
import '../sounds/player_model.dart';

class MyYoutubePlayer extends StatefulWidget {
  final int index;

  final List<Media> videos;
  const MyYoutubePlayer({Key? key, required this.index, required this.videos}) : super(key: key);

  @override
  State<MyYoutubePlayer> createState() => _MyYoutubePlayerState();
}

class _MyYoutubePlayerState extends State<MyYoutubePlayer> {

  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
 // double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  List<String>?idsList;
  getIdsList(){
    List<String>?idsList1=[];
    for (var video in widget.videos){
      idsList1.add(YoutubePlayer.convertUrlToId(video.mediaUrl!)!);
    }
    setState((){idsList=idsList1;});

  }


  List favouritesListIds=[];
  getFavouritesIds()async{

    var favouritesList1=await DbHelper().getFav();
    List favouritesListIds1=[];
    for (var e in favouritesList1) {favouritesListIds1.add(e.id!); }
  setState(() {
    favouritesListIds=favouritesListIds1;
  });
  }
  @override
  void initState() {

    super.initState();
    getFavouritesIds();
    Wakelock.enable();

    getIdsList();
    debugPrint(idsList!.toString());
    _controller = YoutubePlayerController(
      initialVideoId:  YoutubePlayer.convertUrlToId(idsList![widget.index])!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
        hideControls: false,
        controlsVisibleAtStart: true,
      ),
    )..addListener(listener);



    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;

  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });

    }

  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    Wakelock.disable();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onEnterFullScreen:(){SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);} ,
      onExitFullScreen: () {// The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);},


      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),


        ],



        onReady: () {_isPlayerReady = true;},

        onEnded: (data) {_controller.load( YoutubePlayer.convertUrlToId(idsList![((idsList!).indexOf(data.videoId) + 1) % (idsList!).length])!);
          _showSnackBar('Next Video Started!');},

      ),
      builder: (context, player) => Scaffold(
        backgroundColor: color4,
        appBar: AppBar(
          title: Text( _videoMetaData.title,style: TextStyle(fontSize: 12),),
        ),
        body: ListView(
          children: [
            //SizedBox(height: 200),
            player,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _space,
                //  _text('Title', _videoMetaData.title),

                  _space,
                  Material(
                    elevation: 3,
                    color: color4,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous,color: Colors.white),
                            onPressed: _isPlayerReady
                                ? () => _controller.load(idsList![
                            (idsList!.indexOf(_controller.metadata.videoId) -
                                1) %
                                idsList!.length])
                                : null,
                          ),
                          IconButton(
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,color: Colors.white,
                            ),
                            onPressed: _isPlayerReady
                                ? () {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                              setState(() {});
                            }
                                : null,
                          ),
                          IconButton(
                            icon: Icon(_muted ? Icons.volume_off : Icons.volume_up,color: Colors.white),
                            onPressed: _isPlayerReady
                                ? () {
                              _muted
                                  ? _controller.unMute()
                                  : _controller.mute();
                              setState(() {
                                _muted = !_muted;
                              });
                            }
                                : null,
                          ),

                          IconButton(
                            icon: const Icon(Icons.skip_next,color: Colors.white),
                            onPressed: _isPlayerReady
                                ? () => _controller.load(idsList![
                            (idsList!.indexOf(_controller.metadata.videoId) +
                                1) %
                                idsList!.length])
                                : null,
                          ),


                          _playerState == PlayerState.unknown||idsList==null||!idsList!.contains(_controller.metadata.videoId)?const SizedBox():  IconButton(
                            icon:  Icon(Icons.favorite,color:favouritesListIds.contains(widget.videos[(idsList!.indexOf(_controller.metadata.videoId))].id)? Colors.redAccent:color1,),
                            onPressed: ()async{


                              print(widget.videos[(idsList!.indexOf(_controller.metadata.videoId))].id);
                              await  showDialog(context: context, builder:(context)=>Dialog(
                                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                                child: AddVideoFavDialog(media: widget.videos[(idsList!.indexOf(_controller.metadata.videoId))]) ,

                              ));

                            }
                          ),




                          _playerState == PlayerState.unknown?const SizedBox():  IconButton(
                            icon: const Image(image: AssetImage('assets/images/icons/youtube.png'),color: Colors.red,height: 25,),
                            onPressed: ()async{
                              Uri url = Uri.parse('https://www.youtube.com/watch?v=${_videoMetaData.videoId}');
                              Uri url2 = Uri.parse('youtube://www.youtube.com/watch?v=${_videoMetaData.videoId}');
                              var launchMode=LaunchMode.externalApplication;

                              if (Platform.isIOS) {

                                if (await canLaunchUrl(url)) {await launchUrl( url,mode:launchMode );} else {throw 'Could not launch ';}
                              }
                              else {


                                if (await canLaunchUrl(url2)) {await launchUrl(url2,mode:launchMode );}
                                else if(await canLaunchUrl(url)) {await launchUrl(url,mode:launchMode );}
                                else {throw 'Could not launch $url';}


                              }
                            },
                          ),



                        /*  FullScreenButton(
                              controller: _controller,color: Colors.white
                          ),*/
                        ],
                      ),
                    ),
                  ),
                  _space,





                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }


  Widget get _space => const SizedBox(height: 10);


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: color3,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}



class AddVideoFavDialog extends StatefulWidget {

  final Media media;
  const AddVideoFavDialog({Key? key, required this.media}) : super(key: key);

  @override
  State<AddVideoFavDialog> createState() => _AddVideoFavDialogState();
}

class _AddVideoFavDialogState extends State<AddVideoFavDialog> {

  String? albumName;



  List<Album>?videosAlbums=[];
  getAllAlbums()async{
    var albums1=await DbHelper().getAlbums();
    setState((){

      videosAlbums=albums1.where((e) =>e.kind=='videos' ).toList().reversed.toList();



    });

  }


  @override
  void initState() {
    super.initState();
    getAllAlbums();
  }

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return SizedBox(
      child: Material(
        color: Colors.white.withOpacity(0),

        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: height*.02),
                  const Center(child: Text('إختر قائمه',style: TextStyle(color: color1,fontSize: 16),)),
                  const Divider(height: 10,color: color1,thickness: 1,),
                  SizedBox(height: height*.02),
                  Material(
                    color: color4,
                    elevation: 5,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight:height*.35,
                          maxHeight: height*.35
                      ),


                      child: ListView.separated(




                          itemBuilder: (context, i) =>albumItem(name:videosAlbums![i].name! ,index: i),
                          separatorBuilder:(context, index) =>const Divider(height: 1,thickness: 1),
                          itemCount: videosAlbums!.length),

                    ),
                  ),


                ],
              ),
              SizedBox(
                height: height*.025,
              ),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: ()async{



                        await DbHelper()
                            .addFavourite(
                            media: Media(
                                kind: 'videos',//////
                                album: videosAlbums![currentIndex].name,//////

                                title: widget.media.title,
                                image: widget.media.image,
                                id: widget.media.id,
                                catId: widget.media.catId,
                                mediaUrl: widget.media.mediaUrl,
                                description: widget.media.description,
                                fileUrl: widget.media.fileUrl,
                                likes: widget.media.likes,
                                shortDescription: widget.media.shortDescription,
                                shortTitle: widget.media.shortTitle
                            )

                        )
                            .whenComplete(
                                () {
                              Navigator.pop(context);
                              MyFlush().showDoneFlush(context: context, text: 'تمت الإضافه الى المفضله');

                            }
                        );


                      },
                      style:ButtonStyle(backgroundColor:MaterialStateProperty.all(color6)) ,
                      child:const Padding(
                        padding:  EdgeInsets.symmetric(vertical: 8.0,horizontal: 8),
                        child: Text('إضافه',style: TextStyle(color: color1,fontWeight: FontWeight.bold)),
                      ),


                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: ()async{
                        Navigator.pop(context);

                      },
                      style:ButtonStyle(backgroundColor:MaterialStateProperty.all(color6)) ,
                      child:const Padding(
                        padding:  EdgeInsets.symmetric(vertical: 8.0,horizontal: 8),
                        child: Text('إلغاء',style: TextStyle(color: color1,fontWeight: FontWeight.bold)),
                      ),


                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: ()async{
                        await  showDialog(context: context, builder:(context)=>Dialog(
                          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                          child: const AddAlbumDialog() ,

                        )).then((value)async {
                          await getAllAlbums();

                          // setState((){currentIndex=soundsAlbums!.length-1;});

                        }  );
                      },
                      style:ButtonStyle(backgroundColor:MaterialStateProperty.all(color6)) ,
                      child:const Padding(
                        padding:  EdgeInsets.symmetric(vertical: 8.0,horizontal: 8),
                        child: Text('إنشاء قائمه',style: TextStyle(color: color1,fontWeight: FontWeight.bold)),
                      ),


                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  int currentIndex=0;

  albumItem({required String name,required int index}){
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;

    return InkWell(
      onTap: ()async{
        setState((){currentIndex=index;});
      },
      child: Container(
        decoration: BoxDecoration(
            color: index==currentIndex?Colors.white.withOpacity(.2):Colors.white.withOpacity(0),
            borderRadius: BorderRadius.circular(0)
        ),
        height:height*.05 ,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
          child: Row(

            children: [
              Icon(index==currentIndex?Icons.radio_button_checked_outlined
                  :Icons.radio_button_off,
                color:index==currentIndex?Colors.white:color5 ,),
              Expanded(child:
              Text(
                name

                ,
                style: TextStyle(color: index==currentIndex?Colors.white:Colors.black ,fontSize: 18),
                textAlign: TextAlign.right,))

            ],
          ),
        ),
      ),
    );
  }
}