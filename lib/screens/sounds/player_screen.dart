import 'package:bota/constants/my_bottom.dart';
import 'package:flutter/material.dart';

import '../../models/media_model.dart';
import 'player_model.dart';

class PlayerScreen extends StatefulWidget {
  static const String route='/PlayerScreen';

  final List<Media> sounds;
  final int index;
  const PlayerScreen({Key? key, required this.sounds, required this.index}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,

      appBar: AppBar(title: Text(
        widget.sounds[widget.index].title!,style: TextStyle(fontSize: 18),

      )),

      body:


      SingleChildScrollView(child: MySoundPlayer(sounds: widget.sounds,index:widget.index))

      ,





      bottomNavigationBar:    const MyBottom(index: 2),
    );
  }
}
