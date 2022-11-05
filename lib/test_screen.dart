
import 'package:bota/models/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import 'main.dart';



class Testo extends StatefulWidget {
  static const String route='/Testo';
  const Testo({Key? key}) : super(key: key);

  @override
  State<Testo> createState() => _TestoState();
}

class _TestoState extends State<Testo> {

  DbHelper helper=DbHelper();
  @override
  initState(){
    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }
 Widget image(){
    return const Padding(
      padding:  EdgeInsets.all(8.0),
      child:  Image(
        image: AssetImage('assets/images/icons/social/twitter.png'),height: 50,
        color: color4,

      ),
    );
 }
double x=0;
  String word='سبحان الله';
  List list=['سبحان الله','الله أكبر','الحمد لله'];

  @override
  Widget build(BuildContext context) {


    return SafeArea(

      child:

      Scaffold(
        backgroundColor: color6,
        body:
        Center(
          child: SizedBox(
            width: 200,
            child: Marquee(
              text: 'السلام عليكم ورحمه الله وبركاته',
               style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                      scrollAxis: Axis.horizontal,
              showFadingOnlyWhenScrolling: true,
              blankSpace: 30,


            ),
          ),
        ),


        /*Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedContainer(
                  duration: Duration(milliseconds:  600),
                  child: InkWell(
                    splashColor: Colors.white.withOpacity(0),
                    hoverColor: Colors.white.withOpacity(0),
                    focusColor: Colors.white.withOpacity(0),
                    highlightColor: Colors.white.withOpacity(0),
                    overlayColor:MaterialStateProperty.all(Colors.white.withOpacity(0)) ,

                    onTap: ()async{

                      if(x==0||x==1){setState((){x++;});}
                      else {setState((){x++;});
                       await  Future.delayed(const Duration(milliseconds: 600))
                           .then

                         ((value) {
                           if(word==list[0]||word==list[1]){setState((){x=0;word=list[list.indexOf(word)+1];});}
                           else{setState((){word='تم';});}

                         }

                       );}

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SleekCircularSlider(
                        appearance: CircularSliderAppearance(
                          customWidths: CustomSliderWidths(progressBarWidth: 15,handlerSize: 5,trackWidth: 5),
                        customColors: CustomSliderColors(
                          dynamicGradient: true,
                          hideShadow: true,

                          dotColor: color3.withOpacity(0),
                          shadowStep: 1,
                          shadowColor: Colors.white,
                            trackColors: [Colors.white,Colors.white],
                          progressBarColors: [color4,color5,color4,color5,color4],
                          shadowMaxOpacity: 10,


                        ),
                        size:200,
                        angleRange: 360,
                        animationEnabled: true,
                        counterClockwise: false,
                        infoProperties: InfoProperties(bottomLabelText: 'bota',topLabelText: 'toto',),
                        spinnerMode: false,
                            animDurationMultiplier: .5



                      ),
                        min: 0,
                        max: 3,
                        initialValue:x,
                        innerWidget: (c)=>Center(child: Pulse(infinite: true,child: Text(word,style: TextStyle(color: color3,fontSize: 20,fontWeight: FontWeight.w900),))),

                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedTextKit(animatedTexts: list.map((e) => _text(word: e)) .toList() ,),

           */


        /* AnimatedTextKit(
              animatedTexts: [
                FadeAnimatedText(
                  'Fade First',
                  textStyle: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                ),
                ScaleAnimatedText(
                  'Then Scale',
                  textStyle: TextStyle(fontSize: 70.0, fontFamily: 'Canterbury'),
                ),
              ],
            ),*//*


          ],
        ),*/
      ),
    );




  }

}
