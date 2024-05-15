import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MamaKris/wave.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChoicePage extends StatelessWidget {
  final CollectionReference collection = FirebaseFirestore.instance.collection('choices');

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFCFAEE),
      body: Stack( // Используем Stack для наложения элементов
        children: <Widget>[
          SineWaveWidget(verticalOffset: screenHeight / 2), // Волна на фоне
          Positioned( // Позиционируем кнопку "Ищу работу" на верху экрана
            top: 95, // Отступ сверху для размещения поверх волны
            left: 32, // Отступ слева
            right: 32, // Отступ справа
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB7B39A), // Фон кнопки
                foregroundColor: Colors.white, // Цвет текста кнопки
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: const Size(double.infinity, 60), // Растягиваем на всю ширину

              ),
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  String uid = user.uid;
                  await collection.doc(uid).set({'choice': 'ищу работу'});
                  Navigator.pushNamed(context, '/search');
                }
              },
              child: const Text(
                'Ищу работу',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const Positioned(
            top: 170, // Отступ сверху для размещения поверх волны
            left: 45, // Отступ слева
            right: 45, // Отступ справа
            child: Text(
              'Ищу работу, подработку или',
              textAlign: TextAlign.center, // Добавляем здесь
              style: TextStyle(fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.w500, color: Color(0xFF343434)),
            ),
          ),

          const Positioned(
            top: 200, // Отступ сверху для размещения поверх волны
            left: 45, // Отступ слева
            right: 45, // Отступ справа
            child: Text(
              'задания для онлайн-заработка',
              textAlign: TextAlign.center, // Добавляем здесь
              style: TextStyle(fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.w500, color: Color(0xFF343434)),
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 5,),
              child: SvgPicture.asset('images/logo.svg'),
            ),
          ),
       Positioned( // Позиционируем кнопку "Ищу работу" на верху экрана
        top: 580, // Отступ сверху для размещения поверх волны
        left: 32, // Отступ слева
        right: 32, // Отступ справа
        child:
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32), // Аналогично для второй кнопки
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB7B39A),
                foregroundColor: Colors.white, // Цвет текста кнопки

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: const Size(double.infinity, 60), // Растягиваем на всю ширину
              ),
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  String uid = user.uid;
                  await collection.doc(uid).set({'choice': 'есть вакансии'});
                  Navigator.pushNamed(context, '/job');
                }
              },
              child: const Text('Есть вакансии',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ),
      ),
          const Positioned(
            top: 650, // Отступ сверху для размещения поверх волны
            left: 58, // Отступ слева
            right: 58, // Отступ справа
            child: Text(
              'У  меня есть online-вакансия',
              textAlign: TextAlign.center, // Добавляем здесь
              style: TextStyle(fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.w500, color: Color(0xFF343434)),
            ),
          ),
          const Positioned(
            top: 675, // Отступ сверху для размещения поверх волны
            left: 58, // Отступ слева
            right: 58, // Отступ справа
            child: Text(
              'или задание',
              textAlign: TextAlign.center, // Добавляем здесь
              style: TextStyle(fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.w500, color: Color(0xFF343434)),
            ),
          ),
        ],
      ),
    );
  }
}
