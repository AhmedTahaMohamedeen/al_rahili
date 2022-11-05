import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../models/media_model.dart';

class AdReview extends StatefulWidget {
  final Media ad;
  const AdReview({Key? key, required this.ad}) : super(key: key);

  @override
  State<AdReview> createState() => _AdReviewState();
}

class _AdReviewState extends State<AdReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ad.title!,style: TextStyle(fontSize: 14),),
      ),

      body:
     // Html(data:widget.ad.shortDescription),
      SelectableText(widget.ad.shortDescription!,textAlign: TextAlign.right,style: TextStyle(fontSize: 12),)
    );
  }
}
