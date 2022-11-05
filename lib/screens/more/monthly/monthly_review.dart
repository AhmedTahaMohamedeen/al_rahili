import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../main.dart';
import 'package:html/parser.dart' as htmlparser;
class MonthlyReview extends StatefulWidget {
  final String title;
  final String post;
  const MonthlyReview({Key? key, required this.title, required this.post}) : super(key: key);

  @override
  State<MonthlyReview> createState() => _MonthlyReviewState();
}

class _MonthlyReviewState extends State<MonthlyReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(widget.title),backgroundColor: color3),
      body:  SingleChildScrollView(
        child: Html.fromDom(

         document: htmlparser.parse(widget.post)


        ),

       //Html( data:widget.post ,)
      ),

    );
  }
}
