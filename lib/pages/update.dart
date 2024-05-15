import 'dart:math';
import 'package:MamaKris/wave.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UpdateAppPage extends StatelessWidget {
  final String appStoreUrl; // URL для перехода в магазин приложений
  final String playStoreUrl; // URL для перехода в Play Market

  UpdateAppPage({required this.appStoreUrl, required this.playStoreUrl});

  @override
  Widget build(BuildContext context) {
    // Определение URL в зависимости от платформы
    String url = Theme.of(context).platform == TargetPlatform.iOS ? appStoreUrl : playStoreUrl;
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
                    Padding(
                      padding: EdgeInsets.only(
                          left: 5.0*HorizontalMultiply, top: 35*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 0.0),
                      child:IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 58*VerticalMultiply),
                        child: SvgPicture .asset(
                          'images/logo_named.svg',
                          width: 220*HorizontalMultiply, // Ширина в пикселях
                          height: 224*VerticalMultiply, // Высота в пикселях
                        ),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 400*VerticalMultiply, right:32*HorizontalMultiply, bottom:0), // Общий отступ для группы текстов
                      child:  Align(
                        alignment: Alignment.center,

                        child: Text('Доступна новая версия приложения. Пожалуйста, обновите приложение для продолжения использования.', style: TextStyle(fontSize: 16*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w700, color: const Color(0xFF343434), height: 1,),
                        ),

                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 708*VerticalMultiply, right: 32*HorizontalMultiply, bottom:32*VerticalMultiply), // Общий отступ для группы текстов
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF93D56F), Color(0xFF659A57)], // Градиент от #93D56F до #659A57
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(12*TextMultiply), // Скругление углов
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, // Прозрачный фон для отображения градиента
                            shadowColor: Colors.transparent, // Убираем тень
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12*TextMultiply), // Скругление углов
                            ),
                            minimumSize: Size(double.infinity, 60*VerticalMultiply), // Растягиваем кнопку на всю ширину с высотой 60
                            padding: EdgeInsets.only(top: 23*VerticalMultiply, bottom:23*VerticalMultiply),
                          ),
                          onPressed: () => _launchURL(url),
                          child:  Text(
                            'ОБНОВИТЬ',
                            style: TextStyle(fontSize: 14*TextMultiply, color: const Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),

                  ]
              ),
            ]
        ),
      ),
    );
  }
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Не удалось открыть $url';
    }
  }
}