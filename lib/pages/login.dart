import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MamaKris/wave.dart';

import 'package:MamaKris/pages/choice.dart';
import 'package:MamaKris/pages/job_create.dart';
import 'package:MamaKris/pages/search.dart';
import 'package:MamaKris/pages/tinder.dart';

class LoginPage extends StatefulWidget{

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Создайте экземпляр FirebaseAuth
  bool _obscureText = true;



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
                    child: SvgPicture .asset(
                      'images/logo_named.svg',
                      width: 220*HorizontalMultiply, // Ширина в пикселях
                      height: 224*VerticalMultiply, // Высота в пикселях
                    ),
                  ),
                ),

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
                  padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 380*VerticalMultiply, right:0, bottom:0), // Общий отступ для группы текстов
                  child:  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Пожалуйста,',
                      style: TextStyle(fontSize: 32*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w700, color: const Color(0xFF343434), height: 1,),
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 412*VerticalMultiply, right:0, bottom:0), // Общий отступ для группы текстов
                  child:  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'войдите',
                      style: TextStyle(fontSize: 32*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w700, color: const Color(0xFF343434), height: 1,),
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 466*VerticalMultiply , right:0, bottom:0), // Общий отступ для группы текстов
                  child:  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'email',
                      style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: const Color(0xFF343434), height: 1,),
                    ),
                  ),
                ),
                _buildEmailField(_emailController,  false, 32*HorizontalMultiply, 487*VerticalMultiply), //email
                Padding(
                  padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 561*VerticalMultiply, right:0, bottom:0), // Общий отступ для группы текстов
                  child:  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'пароль',
                      style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: const Color(0xFF343434), height: 1,),
                    ),
                  ),
                ),

                _buildPassField(_passwordController,  _obscureText, 32*HorizontalMultiply, 582*VerticalMultiply),//pass
                Row(
                  children: <Widget>[
                    Expanded( // Растягиваем кнопку на всю доступную ширину в Row
                      child: Padding(
                        padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 708*VerticalMultiply, right: 32*HorizontalMultiply, bottom:0), // Общий отступ для группы текстов
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF93D56F), // верхний цвет
                                Color(0xFF659A57)  // нижний цвет
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(12*TextMultiply),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 60*VerticalMultiply), // Задаем ширину (бесконечность для максимальной ширины) и высоту кнопки
                              backgroundColor: Colors.transparent, // Прозрачный цвет
                              shadowColor: Colors.transparent, // Убираем тень
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12*TextMultiply),
                              ),
                              padding: EdgeInsets.only(top: 23*VerticalMultiply, bottom:23*VerticalMultiply),
                            ),
                            onPressed: _login,
                            child:  Align(
                            alignment: Alignment.center,
                            child: Text(
                              'ВОЙТИ',
                              style: TextStyle(fontSize: 14*TextMultiply, color: const Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700),
                            ),
                          ),
                          ),
                        ),
                      ),
                    ),
                  ],

                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _login() async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        // Получаем UID аутентифицированного пользователя
        final uid = userCredential.user!.uid;

        // Получаем документ пользователя из коллекции 'choices' в Firestore
        final docSnapshot = await FirebaseFirestore.instance.collection('choices').doc(uid).get();
        final docSnapshot2 = await FirebaseFirestore.instance.collection('jobSearches').doc(uid).get();

        // Проверяем, содержит ли документ информацию о выборе пользователя
        if (docSnapshot.exists && docSnapshot.data()!.containsKey('choice')) {
          final choice = docSnapshot.data()!['choice'];

          // Перенаправляем пользователя в зависимости от его выбора
          if (choice == 'ищу работу' && docSnapshot2.exists && docSnapshot2.data()!.containsKey('employerId')) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => TinderPage()),
                  (_) => false,
            );
            // Перенаправление на страницу поиска работы
          }
          else if (choice == 'ищу работу') {
            Navigator.pushNamed(context, '/search'); // Перенаправление на страницу с вакансиями
          }
          else if (choice == 'есть вакансии') {
            Navigator.pushNamed(context, '/empl_list'); // Перенаправление на страницу с вакансиями
          }
          else {
            // Если не удало  сь определить выбор, перенаправляем на страницу по умолчанию
            Navigator.pushNamed(context, '/choice');
          }
        } else {
          // Если в документе нет информации о выборе, перенаправляем на страницу по умолчанию
          Navigator.pushNamed(context, '/choice');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Аутентификация не удалась.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Произошла ошибка. Пожалуйста, попробуйте ещё раз.';

      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Некорректный адрес электронной почты.';
          break;
        case 'user-disabled':
          errorMessage = 'Пользователь был отключен.';
          break;
        case 'user-not-found':
          errorMessage = 'Пользователь не найден.';
          break;
        case 'wrong-password':
          errorMessage = 'Неправильный пароль.';
          break;
        case 'invalid-credential':
          errorMessage = 'Учетные данные неверны. Пожалуйста, проверьте и попробуйте снова.';
          break;
        case 'network-request-failed':
          errorMessage = 'Проблема сетевого соединения. Проверьте ваше интернет-соединение.';
          break;
        default:
          print('Необработанная ошибка: ${e.code}');
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print('Ошибка: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Непредвиденная ошибка. Пожалуйста, попробуйте ещё раз.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  Widget _buildEmailField(TextEditingController controller,  bool obscureText, double Hpadding, double Vpadding) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    double TextMultiply = min(width/360, height/800);

    return Padding(
      padding:  EdgeInsets.only(left: Hpadding, top: Vpadding, right:Hpadding, bottom:0), // Общий отступ для группы текстов
      child: TextField(
        controller: controller,
        obscureText: obscureText,
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
        keyboardType: obscureText ? TextInputType.text : TextInputType.emailAddress,
      ),
    );
  }

  Widget _buildPassField(TextEditingController controller, bool obscureText, double Hpadding, double Vpadding) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    double TextMultiply = min(width/360, height/800);

    return Padding(
      padding: EdgeInsets.only(left: Hpadding, top: Vpadding, right: Hpadding, bottom: 0), // Общий отступ для группы текстов
      child: TextField(
        controller: controller,
        obscureText: obscureText,
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
          ),          suffixIcon: IconButton(
          icon: Icon(
            // Изменяем иконку в зависимости от того, скрыт текст или нет
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFF343434),
          ),
          onPressed: () {
            // Переключаем состояние отображения текста при нажатии
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
          // Другие свойства InputDecoration...
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }
}