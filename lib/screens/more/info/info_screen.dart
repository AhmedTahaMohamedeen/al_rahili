import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlparser;

import '../../../main.dart';
import '../../../models/media_model.dart';

class InfoScreen extends StatefulWidget {
  static const String route='InfoScreen/';
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
Media? info;
  getInfo() async {
    var url = Uri.parse('https://api-al-rehaili.shomol.net/public/api/sira/2');
    http.Response? response = await http.get(url);
    Map<String,dynamic>  data;


    if (response.statusCode == 404) {
      debugPrint('Response status: ${response.statusCode}');
    }
    else {
      data = json.decode(response.body);
    setState((){info=Media.fromJson(data['data']['posts'][0]);});

      //debugPrint(data.toString());
      debugPrint(info!.description.toString());
      debugPrint(info!.title.toString());

    }

  }

@override
initState(){
    super.initState();
    getInfo();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ترجمه الشيخ')),


      body: info==null?const Center(child:  CircularProgressIndicator(color: color4),)


          :

      SingleChildScrollView(child:Html(data:   info!.description,),),
    );


  }
}