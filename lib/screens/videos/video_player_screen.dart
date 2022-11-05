import 'package:flutter/material.dart';

import '../../models/media_model.dart';
import 'youtube_player_model.dart';

class VideoScreen extends StatefulWidget {
  final int index;

  final List<Media> videos;
  const VideoScreen({Key? key, required this.index, required this.videos}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body:
      MyYoutubePlayer(index:widget.index,videos: widget.videos)

      ,
    );
  }
}
