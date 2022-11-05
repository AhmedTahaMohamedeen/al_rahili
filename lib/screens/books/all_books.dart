import 'package:bota/constants/my_bottom.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/media_model.dart';
import '../sounds/all_sounds.dart';
import 'book_review.dart';

class AllBookScreen extends StatefulWidget {
  static const String route='/AllBookScreen';
  const AllBookScreen({Key? key}) : super(key: key);

  @override
  State<AllBookScreen> createState() => _AllBookScreenState();
}

class _AllBookScreenState extends State<AllBookScreen> {



  List<Media>?books;
  String moreUrl='';
  getAllBooks()async{
    Map<String, dynamic> myMap=await Media().getAllBooks(url2:'books/7');
    List<Media> books1=myMap['media'];
    setState((){
      books=books1;
      moreUrl=myMap['moreUrl'];
    });
    // debugPrint(sounds1[0].toString());
  }


  getMoreMedia()async{
    print(moreUrl);
    if(moreUrl.isNotEmpty){
      Map<String, dynamic> moreMap=await Media().getMoreMedia(moreUrl: moreUrl);
      List<Media> moreMedia=moreMap['media'];
      setState(() {
        books!.addAll(moreMedia);
        moreUrl=moreMap['moreUrl'];
      });

    }

  }

  @override
  initState(){
    super.initState();
    getAllBooks();
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
        title: const Text('الكتب',style: TextStyle(fontSize: 20),),
      ),
      body:books==null?const Center(child: CircularProgressIndicator(color: color4,)):


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
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 50),
            sliver: SliverGrid(
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: height*.0008,

              ),
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return searchedBookItem(width: width,height: height,book:searchedMedia[index]);
                },
                childCount: searchedMedia.length,

              ),
            ),
          ),

          SliverGrid(
            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: height*.0008,

            ),
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if(index==books!.indexOf(books!.last)){
                      getMoreMedia();
                    }

                return bookItem(width: width,height: height,book:books![index]);
              },
              childCount: books!.length,

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
      ),









      bottomNavigationBar: const MyBottom(index: 3),
    );
  }
  Widget bookItem({required double height,required double width,required Media book}){
return
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
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
      ),
    );


  }
  Widget searchedBookItem({required double height,required double width,required Media book}){
return
    InkWell(
      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) =>  BookReview(book:book ),));},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: color1,
          elevation: 5,
          borderRadius: BorderRadius.circular(10),

          child:Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children:  [
                Expanded(
                  flex: 1,
                  child: Icon(Icons.search,color: Colors.black.withOpacity(.3)),
                ),
                Expanded(
                  flex: 6,
                    child:
                    Container(decoration: const BoxDecoration(image:DecorationImage(image: AssetImage('assets/images/homeImages/homeLogo.png'),scale: 10,opacity: .4) ,),
                  foregroundDecoration: BoxDecoration(image: DecorationImage(image:CachedNetworkImageProvider(book.image!) )),
                   // Image(image:CachedNetworkImageProvider(book.image!),
                  //  AssetImage('assets/images/homeImages/homeLogo.png'),
                    )),
                Expanded(
                  flex: 3,


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
    for(var x in books!){
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
