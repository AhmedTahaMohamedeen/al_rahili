import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:bota/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';

import '../../constants/my_flush.dart';
import '../../models/album_model.dart';
import '../../models/database_helper.dart';
import '../../models/media_model.dart';
import '../more/favourites/albums_screen.dart';
import 'player_screen.dart';

class MySoundPlayer extends StatefulWidget {
  final List<Media> sounds;
  final int index;
  const MySoundPlayer({Key? key, required this.sounds, required this.index}) : super(key: key);

  @override
  State<MySoundPlayer> createState() => _MySoundPlayerState();
}

class _MySoundPlayerState extends State<MySoundPlayer> with WidgetsBindingObserver{
















  AudioMetadata? current;
  final _player = AudioPlayer();

 /* final _playlist = ConcatenatingAudioSource(children: [
    // Remove this audio source from the Windows and Linux version because it's not supported yet
    if (kIsWeb ||
        ![TargetPlatform.windows, TargetPlatform.linux]
            .contains(defaultTargetPlatform))

    AudioSource.uri(
      Uri.parse('widget.sound.mediaUrl!'),
      tag: AudioMetadata(
        album: "Science Friday",
        title: "A Salute To Head-Scratching Science",
        artwork:
        "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
      ),
    ),
    AudioSource.uri(
      Uri.parse("https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3"),
      tag: AudioMetadata(
        album: "Science Friday",
        title: "From Cat Rheology To Operatic Incompetence",
        artwork:
        "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
      ),
    ),
    AudioSource.uri(
      Uri.parse("https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3"),
      tag: AudioMetadata(
        album: "Science Friday",
        title: "From Cat Rheology To Operatic Incompetence",
        artwork:
        "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
      ),
    ),

  ]);*/
  //int _addedCount = 0;
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
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,

    ));
    _init();
  }

  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          debugPrint('A stream error occurred: $e');
        });
    // Try to load audio from a source and catch any errors.
    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      //await _player.setAudioSource(AudioSource.uri(Uri.parse(widget.sound.mediaUrl!)),preload: kIsWeb || defaultTargetPlatform != TargetPlatform.linux);
      await _player.setAudioSource(

        initialIndex: widget.index,
          ConcatenatingAudioSource(children:
          widget.sounds.map((e)  {
            return AudioSource.uri(
             Uri.parse(e.mediaUrl!),
             tag: AudioMetadata(
               album: e.shortDescription==null?'none':e.shortDescription!,
               title:e.title==null?'none':e.title!,
               artwork: "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",),
           );},).toList(),





            // Remove this audio source from the Windows and Linux version because it's not supported yet
          /*  if (kIsWeb || ![TargetPlatform.windows, TargetPlatform.linux].contains(defaultTargetPlatform))


              AudioSource.uri(
                Uri.parse(widget.sounds[widget.index].mediaUrl!),
                tag: AudioMetadata(
                  album: "Science Friday",
                  title: "A Salute To Head-Scratching Science",
                  artwork:
                  "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
                ),
              ),
            AudioSource.uri(
              Uri.parse("https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3"),
              tag: AudioMetadata(
                album: "Science Friday",
                title: "From Cat Rheology To Operatic Incompetence",
                artwork:
                "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
              ),
            ),
            AudioSource.uri(
              Uri.parse("https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3"),
              tag: AudioMetadata(
                album: "Science Friday",
                title: "From Cat Rheology To Operatic Incompetence",
                artwork:
                "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
              ),
            ),*/
          )








          ,





          preload: kIsWeb || defaultTargetPlatform != TargetPlatform.linux);

    } catch (e) {debugPrint("==================Error loading audio source: $e");}

setState((){ current=_player.audioSource!.sequence[_player.currentIndex!].tag;});


  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    Wakelock.disable();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
      Wakelock.disable();
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    if(MediaQuery.of(context).orientation==Orientation.landscape){
      height=MediaQuery.of(context).size.width;
      width=MediaQuery.of(context).size.height;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Display play/pause button and volume/speed sliders.
        SizedBox(height: height*.1),
        Image(image:
        const AssetImage('assets/images/homeImages/homeLogo.png'),

          width: width*.7,height:height*.2 ),
        SizedBox(height: height*.1),

       current==null?
       const SizedBox()
           :Text(current!.title,style: TextStyle(fontSize: height*.019,fontWeight: FontWeight.bold)),
        SizedBox(height: height*.1),

        StreamBuilder<PositionData>(
          stream: _positionDataStream,
          builder: (context, snapshot) {
            final positionData = snapshot.data;
            return SeekBar(
              duration: positionData?.duration ?? Duration.zero,
              position: positionData?.position ?? Duration.zero,
              bufferedPosition:
              positionData?.bufferedPosition ?? Duration.zero,
              onChangeEnd: _player.seek,
            );
          },
        ),

        _controlButtons(player:_player),
        SizedBox(height: height*.05),
        Row(
          children: [
            const Expanded(
                flex: 3,
                child:  Divider(height: 5,thickness: 1,color: color4,indent: 10,endIndent: 25,)),

             Expanded(
               flex: 1,
               child: InkWell(
                onTap: ()async{

                  await  showDialog(context: context, builder:(context)=>Dialog(
                    backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                    child: AddSoundFavDialog(media: widget.sounds[_player.currentIndex!]) ,

                  ));
                },
                child:  Padding(
                  padding: EdgeInsets.all(8.0),
                  child:_player.currentIndex!=null? Icon(Icons.favorite,
                    color: favouritesListIds.contains(widget.sounds[_player.currentIndex!].id)? Colors.redAccent:color4,):CircularProgressIndicator(color: color4),
                ),
            ),
             ),

            Expanded(
              flex: 1,

              child: InkWell(
                onTap: ()async{
                  final mediaUrl=widget.sounds[_player.currentIndex!].mediaUrl;
                  debugPrint(mediaUrl);
                  await Share.share( mediaUrl!);
                  },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.share_sharp,color: color4,),
                ),
              ),
            ),




            Expanded(
              flex: 1,
              child: InkWell(
                onTap: ()async{
                  final url=Uri.parse(widget.sounds[_player.currentIndex!].mediaUrl!);
                  var launchMode=LaunchMode.externalApplication;

                  if (await canLaunchUrl(url)) {await launchUrl( url,mode:launchMode );} else {throw 'Could not launch ';}
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.cloud_download,color: color4,),
                ),
              ),
            ),


            const Expanded(
                flex: 3,
                child: Divider(height: 5,thickness: 1,color: color4,endIndent: 10,indent: 25,)),


          ],
        ),
        SizedBox(height: height*.05),


      ],
    );
  }



  _controlButtons({ required AudioPlayer player}){

    return
      Container(
        decoration: BoxDecoration(
            color: color4,
            borderRadius: BorderRadius.circular(30)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(

                icon: const Icon(Icons.skip_previous,size: 40,color: color1),
                onPressed: (){
                  player.seekToPrevious();
                  setState((){ current=_player.audioSource!.sequence[_player.currentIndex!].tag;});




                },

              ),//  skip previous
              IconButton(

                icon: const Icon(Icons.keyboard_double_arrow_left_rounded,size: 40,color: color1,),
                onPressed: (){
                  Duration targetPosition=player.position - const Duration(seconds: 15);


                  if(targetPosition<const Duration(seconds: 1)){targetPosition=const Duration(seconds: 0);player.seek(targetPosition );}
                  else{player.seek(targetPosition );}



                },

              ),//  >> next 15


              /// This StreamBuilder rebuilds whenever the player state changes, which
              /// includes the playing/paused state and also the
              /// loading/buffering/ready state. Depending on the state we show the
              /// appropriate button or loading indicator.
              StreamBuilder<PlayerState>(
                stream: player.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final processingState = playerState?.processingState;
                  final playing = playerState?.playing;
                  if (processingState == ProcessingState.loading ||
                      processingState == ProcessingState.buffering) {
                    return const CircularProgressIndicator(color: color1);
                  } else if (playing != true) {
                    return IconButton(
                      icon: const Icon(Icons.play_arrow,color:color1),
                      iconSize: 35.0,
                      onPressed: player.play,
                    );
                  } else if (processingState != ProcessingState.completed) {
                    return IconButton(
                      icon: const Icon(Icons.pause,color: color1),
                      iconSize: 35.0,
                      onPressed: player.pause,
                    );
                  } else {
                    return IconButton(
                      icon: const Icon(Icons.replay,color: color1),
                      iconSize: 35.0,
                      onPressed: () => player.seek(Duration.zero),
                    );
                  }
                },
              ),




              IconButton(

                icon: const Icon(Icons.keyboard_double_arrow_right_rounded,size: 40,color: color1,),
                onPressed: (){
                  Duration targetPosition=player.position + const Duration(seconds: 15);
                  if(targetPosition>player.duration!){targetPosition=player.duration!;player.seek(targetPosition );}
                  else{player.seek(targetPosition );}



                },

              ),// <<  previous 15

              IconButton(

                icon: const Icon(Icons.skip_next,size: 40,color: color1,),
                onPressed: (){
                  player.seekToNext();
                  setState((){ current=_player.audioSource!.sequence[_player.currentIndex!].tag;});




                },

              ),//  skip next


              // Opens speed slider dialog
              /*    SizedBox(width: 20),
            StreamBuilder<double>(
              stream: player.speedStream,
              builder: (context, snapshot) => IconButton(
                icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                    style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                onPressed: () {
                  showSliderDialog(
                    context: context,
                    title: "Adjust speed",
                    divisions: 10,
                    min: 0.5,
                    max: 1.5,
                    value: player.speed,
                    stream: player.speedStream,
                    onChanged: player.setSpeed,
                  );
                },
              ),
            ),

*/
            ],
          ),
        ),
      )

      ;
  }
}







//Displays the play/pause button and volume/speed sliders.
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    if(MediaQuery.of(context).orientation==Orientation.landscape){
      height=MediaQuery.of(context).size.width;
      width=MediaQuery.of(context).size.height;
    }
    return Container(
      decoration: BoxDecoration(
        color: color4,
        borderRadius: BorderRadius.circular(30)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(

              icon: const Icon(Icons.skip_previous,size: 40,color: Colors.white),
              onPressed: (){
                player.seekToPrevious();



              },

            ),//  skip previous
            IconButton(

              icon: const Icon(Icons.keyboard_double_arrow_left_rounded,size: 40,color: Colors.white,),
              onPressed: (){
                Duration targetPosition=player.position - const Duration(seconds: 15);


                if(targetPosition<const Duration(seconds: 1)){targetPosition=const Duration(seconds: 0);player.seek(targetPosition );}
                else{player.seek(targetPosition );}



              },

            ),//  >> next 15


            /// This StreamBuilder rebuilds whenever the player state changes, which
            /// includes the playing/paused state and also the
            /// loading/buffering/ready state. Depending on the state we show the
            /// appropriate button or loading indicator.
            StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    width: 40.0,
                    height: 40.0,
                    child: const CircularProgressIndicator(),
                  );
                } else if (playing != true) {
                  return IconButton(
                    icon: const Icon(Icons.play_arrow,color: Colors.white),
                    iconSize: 40.0,
                    onPressed: player.play,
                  );
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                    icon: const Icon(Icons.pause,color: Colors.white),
                    iconSize: 40.0,
                    onPressed: player.pause,
                  );
                } else {
                  return IconButton(
                    icon: const Icon(Icons.replay,color: Colors.white),
                    iconSize: 40.0,
                    onPressed: () => player.seek(Duration.zero),
                  );
                }
              },
            ),




            IconButton(

              icon: const Icon(Icons.keyboard_double_arrow_right_rounded,size: 40,color: Colors.white,),
              onPressed: (){
                Duration targetPosition=player.position + const Duration(seconds: 15);
                if(targetPosition>player.duration!){targetPosition=player.duration!;player.seek(targetPosition );}
                else{player.seek(targetPosition );}



                },

            ),// <<  previous 15

            IconButton(

              icon: const Icon(Icons.skip_next,size: 40,color: Colors.white,),
              onPressed: (){
               player.seekToNext();



                },

            ),//  skip next


            // Opens speed slider dialog
        /*    SizedBox(width: 20),
            StreamBuilder<double>(
              stream: player.speedStream,
              builder: (context, snapshot) => IconButton(
                icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                    style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                onPressed: () {
                  showSliderDialog(
                    context: context,
                    title: "Adjust speed",
                    divisions: 10,
                    min: 0.5,
                    max: 1.5,
                    value: player.speed,
                    stream: player.speedStream,
                    onChanged: player.setSpeed,
                  );
                },
              ),
            ),

*/
          ],
        ),
      ),
    );
  }
}







class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar({
    Key? key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);

  @override
  SeekBarState createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SliderTheme(
          data: _sliderThemeData.copyWith(
            thumbShape: HiddenThumbComponentShape(),
            activeTrackColor: color3,
            inactiveTrackColor: Colors.grey.shade300,
          ),
          child: ExcludeSemantics(
            child: Slider(thumbColor: color4,

              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: min(widget.bufferedPosition.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble()),
              onChanged: (value) {
                setState(() {
                  _dragValue = value;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd!(Duration(milliseconds: value.round()));
                }
                _dragValue = null;
              },
            ),
          ),
        ),
        SliderTheme(
          data: _sliderThemeData.copyWith(
            inactiveTrackColor: Colors.transparent,
          ),
          child: Slider(thumbColor: color4,activeColor: color2,
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              setState(() {
                _dragValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(Duration(milliseconds: value.round()));
              }
            },
            onChangeEnd: (value) {
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd!(Duration(milliseconds: value.round()));
              }
              _dragValue = null;
            },
          ),
        ),
      /*  Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch("$_remaining")?.group(1) ?? '$_remaining'

              ,
              style: Theme.of(context).textTheme.caption),
        ),*/
        Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch("$_fullDuration")?.group(1) ?? '$_fullDuration'

              ,
              style: Theme.of(context).textTheme.caption),
        ),
        Positioned(
          left: 16.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch("$_current")?.group(1) ?? '$_current'

              ,
              style: Theme.of(context).textTheme.caption),
        ),
      ],
    );
  }

 // Duration get _remaining => widget.duration - widget.position;
  Duration get _current => widget.position;
  Duration get _fullDuration => widget.duration;
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  // TODO: Replace these two by ValueStream.
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => SizedBox(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: const TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

T? ambiguate<T>(T? value) => value;
class AudioMetadata {
  final String album;
  final String title;
  final String artwork;

  AudioMetadata({
    required this.album,
    required this.title,
    required this.artwork,
  });
}






class AddSoundFavDialog extends StatefulWidget {

  final Media media;
  const AddSoundFavDialog({Key? key, required this.media}) : super(key: key);

  @override
  State<AddSoundFavDialog> createState() => _AddSoundFavDialogState();
}

class _AddSoundFavDialogState extends State<AddSoundFavDialog> {

  String? albumName;
  String? myFavouritesKind=favouritesKinds[0];



  List<Album>?soundsAlbums=[];
  getAllAlbums()async{
    var albums1=await DbHelper().getAlbums();
    setState((){

      soundsAlbums=albums1.where((e) =>e.kind=='sounds' ).toList().reversed.toList();



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




                          itemBuilder: (context, i) =>albumItem(name:soundsAlbums![i].name! ,index: i),
                          separatorBuilder:(context, index) =>const Divider(height: 1,thickness: 1),
                          itemCount: soundsAlbums!.length),

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
                                kind: 'sounds',//////
                                album: soundsAlbums![currentIndex].name,//////

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


