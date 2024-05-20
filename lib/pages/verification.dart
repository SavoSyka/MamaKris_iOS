
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:MamaKris/wave.dart';
import 'package:MamaKris/pages/choice.dart';

class VerificationPage extends StatefulWidget {
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  late User user;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    user.sendEmailVerification();

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    double TextMultiply = min(width/360, height/800);
    double VerticalMultiply = height/800;
    double HorizontalMultiply = width/360;

    return Scaffold(
      body: SingleChildScrollView( // Добавляем прокрутку
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                SineWaveWidget(verticalOffset:  340*VerticalMultiply),
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
                // Условие для отображения сообщения и кнопки
                if (!user.emailVerified) ...[
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

                  Padding(
                    padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 530*VerticalMultiply, right:32*HorizontalMultiply, bottom:0), // Общий отступ для группы текстов
                    child:  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Пожалуйста, проверьте свою почту и нажмите на ссылку для подтверждения.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: const Color(0xFF343434), height: 1,),
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
                        onPressed: () async {
                          await user.sendEmailVerification();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Письмо отправлено!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child:  Text(
                          'ОТПРАВИТЬ ПИСЬМО ПОВТОРНО',
                          style: TextStyle(fontSize: 14*TextMultiply, color: const Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ]// Замените SubscribePage() на страницу, на которую хотите перейти
                else ...[
                  const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text('Почта подтверждена!', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );

  }

  Future<void> checkEmailVerified() async {
    user = FirebaseAuth.instance.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ChoicePage()), // Замените SubscribePage() на страницу, на которую хотите перейти
            (_) => false,
      );

    } else {
      setState(() {});
    }
  }
}
