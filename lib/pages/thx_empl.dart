import 'dart:math';
import 'package:flutter/material.dart';
import 'package:MamaKris/wave.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ThxEmplPage extends StatefulWidget {
  @override
  _ThxEmplPageState createState() => _ThxEmplPageState();
}

class _ThxEmplPageState extends State<ThxEmplPage> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    double TextMultiply = min(width/360, height/800);
    double VerticalMultiply = height/800;
    double HorizontalMultiply = width/360;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                SineWaveWidget(verticalOffset:  340*VerticalMultiply),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: (340-128/2)*VerticalMultiply),
                    child: SvgPicture .asset(
                      'images/thx.svg',
                      width: 128*HorizontalMultiply, // Ширина в пикселях
                      height: 128*VerticalMultiply, // Высота в пикселях
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: (496-92/2)*VerticalMultiply),
                    child: SvgPicture .asset(
                      'images/thx_empl.svg',
                      width: 296*HorizontalMultiply, // Ширина в пикселях
                      height: 92*VerticalMultiply, // Высота в пикселях
                    ),
                  ),

                ),
                Padding(
                  padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 676*VerticalMultiply, right: 32*HorizontalMultiply, bottom:0), // Общий отступ для группы текстов
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB7B39A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12*TextMultiply),
                      ),
                      padding: EdgeInsets.only(top: 23*(height/800), bottom:23*(height/800)),
                    ),
                    child:  Align(
                      alignment: Alignment.center,
                      child: Text(
                          'НА ГЛАВНУЮ',
                          style: TextStyle(fontSize: 14*TextMultiply, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700)
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/empl_list');
                    },
                  ),
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }



}
