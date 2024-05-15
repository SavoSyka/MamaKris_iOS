import 'dart:math';
import 'package:flutter/material.dart';
import 'package:MamaKris/wave.dart'; // Убедитесь, что wave.dart содержит SineWaveWidget
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Добавьте этот импорт
import 'package:firebase_auth/firebase_auth.dart'; // Добавьте этот импорт
import 'package:MamaKris/google_sign.dart';
import 'package:MamaKris/pages/choice.dart';
import 'package:MamaKris/pages/tinder.dart';
import 'package:MamaKris/pages/search.dart';
import 'package:MamaKris/pages/job_create.dart';
import 'package:MamaKris/pages/employer_list.dart';
import 'package:MamaKris/apple_sign.dart';
class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    double TextMultiply = min(width/360, height/800);
    double VerticalMultiply = height/800;
    double HorizontalMultiply = width/360;

    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Изменено на start для размещения волны в верху
        children: <Widget>[
          Stack(
            children: [
              SineWaveWidget(verticalOffset: 340*VerticalMultiply),
              Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: EdgeInsets.only(top: 58*VerticalMultiply), // Отступ сверху
                    child: SvgPicture.asset(
                      "images/logo_named.svg",
                      width: 220*HorizontalMultiply, // Ширина в пикселях
                      height: 224*VerticalMultiply, // Высота в пикселях
                    )
                ),
              ),
            ],
          ),

          Expanded( // Используем Expanded для центрирования кнопок в оставшемся пространстве
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 40*VerticalMultiply, right:0, bottom:0), // Общий отступ для группы текстов
                    child:  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Добро',
                        style: TextStyle(fontSize: 40*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w800, color: Color(0xFF343434), height: 1,),
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 0, right:0, bottom:0), // Общий отступ для группы текстов
                    child:  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'пожаловать!',
                        style: TextStyle(fontSize: 40*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w500, color: Color(0xFF343434), height: 1,),
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 8*VerticalMultiply, right:0, bottom:0), // Общий отступ для группы текстов
                    child:  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Войдите или создайте аккаунт',
                        style: TextStyle(fontSize: 16*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600,height: 1,),
                      ),
                    ),
                  ),

                  Row(
                    children: <Widget>[
                      Expanded( // Растягиваем кнопку на всю доступную ширину в Row
                        child: Padding(
                          padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 28*VerticalMultiply, right: 32*HorizontalMultiply, bottom:0), // Общий отступ для группы текстов
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
                              onPressed: () {
                                Navigator.pushNamed(context, '/welcome');
                              },
                              child:  Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'СОЗДАТЬ АККАУНТ',
                                  style: TextStyle(fontSize: 14*TextMultiply, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],

                  ),
                  Row(
                    children: <Widget>[
                      Expanded( // Растягиваем кнопку на всю доступную ширину в Row
                        child: Padding(
                          padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 12*VerticalMultiply, right: 32*HorizontalMultiply, bottom:0), // Общий отступ для группы текстов
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
                                  'ВОЙТИ',
                                  style: TextStyle(fontSize: 14*TextMultiply, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700)
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:  EdgeInsets.only( top: 24*VerticalMultiply), // Общий отступ для группы текстов
                    child:  Align(
                      alignment: Alignment.center,
                      child: Text(
                        'или войдите с помощью:',
                        style: TextStyle(fontSize: 15*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w500, // Делаем текст более жирным
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 12 * VerticalMultiply), // Общий отступ для группы текстов
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Цвет фона кнопки
                          shape: CircleBorder(), // Форма кнопки - круглая
                          padding: EdgeInsets.all(14*TextMultiply), // Отступ внутри круглой кнопки
                        ),
                        child:  FaIcon(
                          FontAwesomeIcons.google,
                          color: Colors.white, // Цвет иконки
                          size: 26*TextMultiply, // Размер иконки
                        ),
                        onPressed: () async {
                          print('pressed');
                          final bool? isNewUser = await signInWithGoogle();
                          print('func done');
                          if (isNewUser == true) {
                            // Новый пользователь
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => ChoicePage()),
                                  (_) => false,
                            );
                          }
                          else if (isNewUser == false) {
                            // Пользователь уже существует, получаем дополнительные данные из Firestore
                            final User? user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              final uid = user.uid;
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
                                  );// Перенаправление на страницу поиска работы
                                }
                                else if (choice == 'ищу работу') {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => JobSearchPage()),
                                        (_) => false,
                                  ); // Перенаправление на страницу с вакансиями
                                }
                                else if (choice == 'есть вакансии') {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => JobsListPage()),
                                        (_) => false,
                                  ); // Перенаправление на страницу с вакансиями
                                } else {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => ChoicePage()),
                                        (_) => false,
                                  );                                }
                              } else {
                                // Документ не найден или не содержит выбора
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => ChoicePage()),
                                      (_) => false,
                                );                              }
                            } else {
                              print('Ошибка: пользователь не определён после входа через Google.');
                            }
                          } else {
                            // Ошибка аутентификации или отмена входа пользователем
                            print("Ошибка аутентификации или вход отменён пользователем");
                          }

                        },
                      ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // Цвет фона кнопки
                            shape: CircleBorder(), // Форма кнопки - круглая
                            padding: EdgeInsets.all(14 * TextMultiply), // Отступ внутри круглой кнопки
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.apple,
                            color: Colors.white, // Цвет иконки
                            size: 26 * TextMultiply, // Размер иконки
                          ),
                          onPressed: () async {
                            final bool? isNewUser = await signInWithApple();
                            if (isNewUser == true) {
                              // Новый пользователь
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => ChoicePage()),
                                    (_) => false,
                              );
                            } else if (isNewUser == false) {
                              // Пользователь уже существует
                              final User? user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                final uid = user.uid;
                                final docSnapshot = await FirebaseFirestore.instance.collection('choices').doc(uid).get();
                                final docSnapshot2 = await FirebaseFirestore.instance.collection('jobSearches').doc(uid).get();

                                if (docSnapshot.exists && docSnapshot.data()!.containsKey('choice')) {
                                  final choice = docSnapshot.data()!['choice'];
                                  if (choice == 'ищу работу' && docSnapshot2.exists && docSnapshot2.data()!.containsKey('employerId')) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => TinderPage()),
                                          (_) => false,
                                    );
                                  } else if (choice == 'ищу работу') {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => JobSearchPage()),
                                          (_) => false,
                                    );
                                  } else if (choice == 'есть вакансии') {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => JobsListPage()),
                                          (_) => false,
                                    );
                                  } else {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => ChoicePage()),
                                          (_) => false,
                                    );
                                  }
                                } else {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => ChoicePage()),
                                        (_) => false,
                                  );
                                }
                              } else {
                                print('Ошибка: пользователь не определён после входа через Apple.');
                              }
                            } else {
                              print("Ошибка аутентификации или вход отменён пользователем");
                            }
                          },
                        )
                          ],
                      ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 7 * VerticalMultiply), // Общий отступ для группы текстов
                    child: TextButton(
                      child:  Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Сбросить пароль',
                          style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w500, color: const Color(0xFF343434),decoration: TextDecoration.underline,),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/reset');
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}