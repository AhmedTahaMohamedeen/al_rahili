import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/my_flush.dart';
import '../../main.dart';
import '../../models/album_model.dart';
import '../../models/database_helper.dart';
import '../../models/media_model.dart';
import '../more/favourites/albums_screen.dart';


class BookReview extends StatefulWidget {
  final Media book;
  const BookReview({Key? key, required this.book}) : super(key: key);

  @override
  State<BookReview> createState() => _BookReviewState();
}

class _BookReviewState extends State<BookReview> {

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
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
  }

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    if(MediaQuery.of(context).orientation==Orientation.landscape){
      height=MediaQuery.of(context).size.width;
      width=MediaQuery.of(context).size.height;
    }
   // Uri x=Uri.parse('gs://shoppy-160bc.appspot.com/book.pdf');
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.book.title!,style: TextStyle(fontSize: 12,color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon:  Icon(
              Icons.favorite,
              color: favouritesListIds.contains(widget.book.id)? Colors.redAccent:color1,

            ),
            onPressed: ()async{
              await  showDialog(context: context, builder:(context)=>Dialog(
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                child: AddBookFavDialog(media:widget.book) ,

              ));
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.add_to_drive_rounded,
              color: Colors.white,

            ),
            onPressed: () async{
              Uri url = Uri.parse(widget.book.mediaUrl!);
              var launchMode=LaunchMode.externalApplication;
              if (Platform.isIOS) {

                if (await canLaunchUrl(url)) {await launchUrl( url,mode:launchMode );} else {throw 'Could not launch ';}
              }
              else {

                if (await canLaunchUrl(url)) {await launchUrl(url,mode:launchMode );} else {throw 'Could not launch $url';}


              }


            },
          ),
        /*  IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),*/

        ],
      ),
      body:



       SfPdfViewer.network(
       widget.book.mediaUrl! ,
        key: _pdfViewerKey,
        canShowPasswordDialog: false,
        canShowPaginationDialog: false,
        enableTextSelection: false,
        pageLayoutMode:  PdfPageLayoutMode.single,
         scrollDirection:PdfScrollDirection.horizontal ,
      ),
    );
  }









}




class AddBookFavDialog extends StatefulWidget {

  final Media media;
  const AddBookFavDialog({Key? key, required this.media}) : super(key: key);

  @override
  State<AddBookFavDialog> createState() => _AddBookFavDialogState();
}

class _AddBookFavDialogState extends State<AddBookFavDialog> {

  String? albumName;



  List<Album>?booksAlbums=[];
  getAllAlbums()async{
    var albums1=await DbHelper().getAlbums();
    setState((){

      booksAlbums=albums1.where((e) =>e.kind=='books' ).toList().reversed.toList();



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




                          itemBuilder: (context, i) =>albumItem(name:booksAlbums![i].name! ,index: i),
                          separatorBuilder:(context, index) =>const Divider(height: 1,thickness: 1),
                          itemCount: booksAlbums!.length),

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
                                kind: 'books',//////
                                album: booksAlbums![currentIndex].name,//////

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