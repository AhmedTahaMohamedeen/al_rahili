import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'routs.dart';
import 'screens/home.dart';
void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
 // await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp ]);
//await Auth().loginAnonymously();


  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterNativeSplash.remove();
   // func();

  }

  @override

  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'الرحيلى',

      routes: routes,
        initialRoute:Home.route,

















        theme: ThemeData(

          backgroundColor: color1,
          scaffoldBackgroundColor: color1,



          appBarTheme:  AppBarTheme(
              backgroundColor: color4,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(fontFamily: GoogleFonts.tajawal().fontFamily,fontSize:25,fontWeight: FontWeight.w900,color: Colors.black )


          ),



        primaryTextTheme:TextTheme(titleLarge:TextStyle(fontFamily: GoogleFonts.tajawal().fontFamily) ) ,


        textTheme:const TextTheme() ,
        primaryColor: Colors.blue
    ),
      themeMode: ThemeMode.light,





    );
  }
}


const color1=Color(0xffACD0CD);
const color2=Color(0xff7EBEBD);
const color3=Color(0xff55BCBB);
const color4=Color(0xff007E7D);
const color5=Color(0xff216160);
const color6=Color(0xff0F3433);
const color7=Color(0xff000000);
const color8=Color(0xffF3D148);

