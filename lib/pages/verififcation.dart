// Файл verification.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:MamaKris/wave.dart';

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

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
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
      return Scaffold(
        body: SingleChildScrollView( // Добавляем прокрутку
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SineWaveWidget(verticalOffset: 300),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 38),
                  child: Image.asset('images/logo_named.png'),
                ),
              ),
              // Условие для отображения сообщения и кнопки
              if (!user.emailVerified) ...[
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Пожалуйста, проверьте свою почту и нажмите на ссылку для подтверждения.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF93D56F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          minimumSize: Size(double.infinity, 60),
                        ),
                        onPressed: () async {
                          await user.sendEmailVerification();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Письмо отправлено!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        child: Text(
                          'Отправить письмо повторно',
                            style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700)
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text('Почта подтверждена!', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                ),
              ],
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
      Navigator.pushReplacementNamed(context, '/choice');
    } else {
      setState(() {});
    }
  }
}
