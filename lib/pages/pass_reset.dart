import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MamaKris/wave.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _resetPassword() async {
    final String email = _emailController.text.trim();
    if (email.isEmpty) {
      // Показать ошибку, если поле пустое
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, введите адрес электронной почты')),
      );
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: email);
      // Уведомление пользователя о том, что инструкции были отправлены
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Инструкции для сброса пароля отправлены на $email')),
      );
    } catch (error) {
      // Обработка ошибок при отправке запроса на сброс
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при отправке запроса на сброс пароля: $error')),
      );
    }
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
    padding: EdgeInsets.only(top: 58*VerticalMultiply),
    child: SvgPicture.asset(
    'images/logo_named.svg',
    width: 220*HorizontalMultiply, // Ширина в пикселях
    height: 224*VerticalMultiply, // Высота в пикселях
    ),
    ),
    ),
          Padding(
            padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 370*VerticalMultiply, right:0, bottom:0), // Общий отступ для группы текстов
            child:  Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Сброс пароля',
                style: TextStyle(fontSize: 28*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w700, color: const Color(0xFF343434), height: 1,),
              ),
            ),
          ),


          Padding(
            padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 446*VerticalMultiply , right:0, bottom:0), // Общий отступ для группы текстов
            child:  Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'email',
                style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: const Color(0xFF343434), height: 1,),
              ),
            ),
          ),
            _buildEmailField(_emailController, 32*HorizontalMultiply, 466*VerticalMultiply),

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
                onPressed:  _resetPassword,
                child:  Text(
                  'СБРОСИТЬ ПАРОЛЬ',
                  style: TextStyle(fontSize: 14*TextMultiply, color: const Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
    ]
    )
        ]
    )
        )
    );
  }

  Widget _buildEmailField(TextEditingController controller, double Hpadding, double Vpadding) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    double TextMultiply = min(width/360, height/800);
    return Padding(
      padding:  EdgeInsets.only(left: Hpadding, top: Vpadding, right:Hpadding, bottom:0), // Общий отступ для группы текстов
      child: TextField(
        controller: controller,
        obscureText: false,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always, // Лейбл всегда над полем
          labelStyle: const TextStyle(color: Color(0xFF343434)), // Цвет лейбла
          // Устанавливаем толстую рамку
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12*TextMultiply),
            borderSide: BorderSide(color:const Color(0xFF343434), width: 2.0*TextMultiply), // Увеличиваем ширину рамки
          ),
          // Также применяем стиль рамки когда поле в фокусе
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12*TextMultiply),
            borderSide: BorderSide(color: const Color(0xFF343434), width: 2.0*TextMultiply), // Та же толщина рамки
          ),
          // Стиль рамки при вводе неверных данных
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12*TextMultiply),
            borderSide: BorderSide(color: Colors.red, width: 2.0*TextMultiply), // Можно изменить цвет/толщину для ошибок
          ),
        ),
      ),
    );
  }
}
