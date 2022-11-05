import 'package:flutter/material.dart';

import '../../../constants/my_bottom.dart';
import '../../../constants/my_flush.dart';
import '../../../main.dart';
import '../../../models/album_model.dart';
import '../../../models/database_helper.dart';
import 'favourite_screen.dart';

class AlbumsScreen extends StatefulWidget {
  static const String route='/AlbumsScreen';
  const AlbumsScreen({Key? key}) : super(key: key);

  @override
  State<AlbumsScreen> createState() => _AlbumsScreenState();
}



class _AlbumsScreenState extends State<AlbumsScreen> {
  List<Album>?albums;
  List<Album>?soundsAlbums=[];
  List<Album>?videosAlbums=[];
  List<Album>?booksAlbums=[];

  final GlobalKey<FormState> _myKey=GlobalKey<FormState>();
  String? albumName;
  String? myFavouritesKind;

  getAllAlbums()async{
    var albums1=await DbHelper().getAlbums();
    setState((){
          albums=albums1;
          soundsAlbums=albums1.where((e) =>e.kind=='sounds' ).toList();
          videosAlbums=albums1.where((e) =>e.kind=='videos' ).toList();
          booksAlbums=albums1.where((e) =>e.kind=='books' ).toList();
          
          
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
    return DefaultTabController(
        length: 3,
        child: Scaffold(

          appBar: AppBar(
            bottom:const TabBar(
              tabs: [
                Tab(
                  icon: Image(image: AssetImage('assets/images/icons/soundcloud.png'),width: 25,color: Colors.white),
                  child: Text('الصوتيات'),

                ),
                Tab(
                  icon:  Image(image: AssetImage('assets/images/icons/youtube.png'),width: 25,color: Colors.white),
                  child: Text('المرئيات'),
                ),
                Tab(
                  icon:  Image(image: AssetImage('assets/images/icons/books.png'),width: 25,color: Colors.white),
                  child: Text('الكتب'),
                ),
              ],

              automaticIndicatorColorAdjustment: true,
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              unselectedLabelColor: Colors.black,
              labelColor: Colors.white,




            ),

            title: Text('المفضله'),

          ),



          body:albums==null ?const Center(child: CircularProgressIndicator(color: color4),): Padding(
            padding: const EdgeInsets.only(top: 8,right: 8,left: 8,bottom: 50),
            child: TabBarView(

              children: [
                ListView.builder(
                  itemBuilder: (context, i) => myTab(album:soundsAlbums![i] ),
                  itemCount:soundsAlbums!.length ,

                ) ,
                ListView.builder(
                  itemBuilder: (context, i) => myTab(album:videosAlbums![i] ),
                  itemCount:videosAlbums!.length ,

                ) ,
                ListView.builder(
                  itemBuilder: (context, i) => myTab(album:booksAlbums![i] ),
                  itemCount:booksAlbums!.length ,

                ) ,

              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
          floatingActionButton: FloatingActionButton(
              onPressed: ()async{
               await  showDialog(context: context, builder:(context)=>Dialog(
                  backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                  child:const AddAlbumDialog() ,

                )).then((value) =>  getAllAlbums());

              },
            backgroundColor: color6,
              child: const Icon(Icons.add),


          ),


          bottomNavigationBar:const MyBottom(index: 5),
        ));
  }
  
 Widget myTab({required Album album}){
   double height=MediaQuery.of(context).size.height;
   double width=MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => FavouriteScreen(album: album),));
      },
      onLongPress: ()async{
        await showDialog(context: context, builder:(context)=>Dialog(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
          child:Material(
            color: Colors.white.withOpacity(0),

            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: height*.2,

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children:const [
                         Center(child:  Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('مسح القائمه ؟',style: TextStyle(color: Colors.white)),
                        )),
                         Divider(height:  1,color: color1,thickness: 1,),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                          onPressed: ()async{
                            await DbHelper().deleteAlbum(album: album).whenComplete(() =>  MyFlush().showDoneFlush(context: context, text: 'تم الحذف'));

                          },
                        style:ButtonStyle(backgroundColor:MaterialStateProperty.all(color6)) ,
                          child:const Padding(
                            padding:  EdgeInsets.symmetric(vertical: 8.0,horizontal: 24),
                            child: Text('مسح',style: TextStyle(color: color1,fontWeight: FontWeight.bold)),
                          ),


                      ),
                    )
                  ],
                ),
              ),
            ),
          ) ,

        )).whenComplete(() => getAllAlbums() );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 3,
          color: color4,
          child:SizedBox(
            height:height*.1 ,
            width: width*.8,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Icon(Icons.arrow_back_ios,color: color1),
                  Expanded(
                    child: Text(
                        album.name!

                        ,style:const TextStyle(color: Colors.white,fontSize: 18),textAlign: TextAlign.right),

                  ),
                ],
              ),
            ),
          ) ,),
      ),
    );
    
  }


}


class AddAlbumDialog extends StatefulWidget {
  const AddAlbumDialog({Key? key}) : super(key: key);

  @override
  State<AddAlbumDialog> createState() => _AddAlbumDialogState();
}

class _AddAlbumDialogState extends State<AddAlbumDialog> {
  final GlobalKey<FormState> _myKey=GlobalKey<FormState>();
  String? albumName;
  String? myFavouritesKind=favouritesKinds[0];
  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Material(
      color: Colors.white.withOpacity(0),

      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: height*.35,

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: height*.025),
                    Material(
                      color:color3,
                      elevation: 2,
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(10),
                          elevation: 5,
                          alignment: Alignment.center,
                          underline: const SizedBox(),

                          dropdownColor:color3,
                          items: favouritesKinds .map((e) =>
                              DropdownMenuItem(
                                value: e,
                                child: Text(favouritesKindsArabic[favouritesKinds.indexOf(e)],style:  const TextStyle(fontSize: 12,color: Colors.black),),)).toList(),


                          value:myFavouritesKind,

                          onChanged: (Object? value) {



                            setState(() {
                              myFavouritesKind=value.toString();
                            });



                          } ,




                        ),
                      ),
                    ),
                    SizedBox(height: height*.025),


                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:  Form(
                          key: _myKey,
                          child: AddAlbumTextField(
                            label: 'إسم القائمه',
                            vFuntion: (v){if(v!.isEmpty){return'أدخل اسم القائمه';}return null;},
                            sFuntion: (s){setState(() {albumName=s;});return null;},
                            input: TextInputType.name,
                            icon: const Icon(Icons. photo_album,color: color2,),

                          ),
                        ),//name,
                      ),
                    ),

                    const Divider(height:  1,color: color1,thickness: 1,),
                  ],
                ),

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: ()async{

                          if(!_myKey.currentState!.validate()){return;}
                          else {
                            _myKey.currentState!.save();
                            await DbHelper()
                                .addAlbum(album: Album(
                              name: albumName, kind: myFavouritesKind,))
                                .whenComplete(() {Navigator.pop(context);});
                            MyFlush().showDoneFlush(context: context, text: 'تمت إضافه قائمه جديده');
                          }

                        },
                        style:ButtonStyle(backgroundColor:MaterialStateProperty.all(color6)) ,
                        child:const Padding(
                          padding:  EdgeInsets.symmetric(vertical: 0.0,horizontal: 18),
                          child: Text('إنشاء',style: TextStyle(color: color1,fontWeight: FontWeight.bold)),
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
                          padding:  EdgeInsets.symmetric(vertical: 0.0,horizontal: 18),
                          child: Text('إلغاء',style: TextStyle(color: color1,fontWeight: FontWeight.bold)),
                        ),


                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddAlbumTextField extends StatelessWidget {

  double borderWidth = 1;
  Color borderColor = Colors.white.withOpacity(.3);
  Color fillColor = Colors.white.withOpacity(.1);
  double borderRadus = 50;


  TextEditingController? myController ;
  final String label;
  final Icon icon;
  final bool obsecure;
  final TextInputType input;


  final String? Function(String?) vFuntion;
  final  String? Function(String?) sFuntion;

  //Function ontapFunction;

  AddAlbumTextField({Key? key,
    required this.label,
    this.obsecure = false,
    required this.icon,
    required this.vFuntion,
    required this.sFuntion,
    this.myController,
    required this.input,



  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    OutlineInputBorder _outlineInputBorder=OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadus),
      borderSide: BorderSide(color: borderColor, width: borderWidth),
    );

    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    if(MediaQuery.of(context).orientation==Orientation.landscape){
      height=MediaQuery.of(context).size.width;
      width=MediaQuery.of(context).size.height;
    }

    return  TextFormField(
      style: TextStyle(color: Colors.white,fontSize:height*.019 ),
      decoration: InputDecoration(
        //fillColor: Theme.of(context).primaryColor,
        // counterStyle: TextStyle(color: Theme.of(context).canvasColor,fontSize: height*.015),
        //filled: true,
          isCollapsed: true,
          enabled: true,
          contentPadding:  EdgeInsets.all(height*.015),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: label,
          labelStyle: TextStyle(color:color1,fontWeight: FontWeight.normal,fontSize:height*.015 ),


          prefixIcon: icon,

          enabledBorder: _outlineInputBorder,
          disabledBorder:_outlineInputBorder,
          focusedBorder: _outlineInputBorder,
          errorBorder: _outlineInputBorder,
          focusedErrorBorder: _outlineInputBorder
      ),

      obscureText: obsecure,
      textInputAction: TextInputAction.done,
      keyboardType: input,
      enabled: true,
      minLines: 1,
      maxLines: 1,
      // maxLength: 20,
      // initialValue: 'bota',

      validator:vFuntion ,
      onSaved:sFuntion ,

      controller: myController,
    );
  }

/*
  validator:( String v){
  if(v.isEmpty){return 'wrong';}
  return  null;
  }
   */
/*
 onPressed:(){if (!formKey.currentState.validate()) {return;}
                    formKey.currentState.save();
                    }
 */
}