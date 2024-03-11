import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MamaKris/wave.dart';

class ChoicePage extends StatelessWidget {
  final CollectionReference collection = FirebaseFirestore.instance.collection('choices');

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFFCFAEE),
      body: Stack( // Используем Stack для наложения элементов
        children: <Widget>[
          SineWaveWidget(verticalOffset: screenHeight / 2), // Волна на фоне
          Positioned( // Позиционируем кнопку "Ищу работу" на верху экрана
            top: 95, // Отступ сверху для размещения поверх волны
            left: 32, // Отступ слева
            right: 32, // Отступ справа
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB7B39A), // Фон кнопки
                foregroundColor: Colors.white, // Цвет текста кнопки
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
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
          const Positioned( // Позиционируем кнопку "Ищу работу" на верху экрана
            top: 170, // Отступ сверху для размещения поверх волны
            left: 62, // Отступ слева
            right: 62, // Отступ справа
            child: Text(
              'Ищу работу, подработку или задания для онлайн-заработка',
              textAlign: TextAlign.center, // Добавляем здесь
              style: TextStyle(fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.w500, color: Color(0xFF343434)),
            ),
          ),

          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 5,),
              child: Image.asset('images/logo_named.png'),
            ),
          ),
       Positioned( // Позиционируем кнопку "Ищу работу" на верху экрана
        top: 522, // Отступ сверху для размещения поверх волны
        left: 32, // Отступ слева
        right: 32, // Отступ справа
        child:
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32), // Аналогично для второй кнопки
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB7B39A),
                foregroundColor: Colors.white, // Цвет текста кнопки

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
                minimumSize: Size(double.infinity, 60), // Растягиваем на всю ширину
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
          const Positioned( // Позиционируем кнопку "Ищу работу" на верху экрана
            top: 600, // Отступ сверху для размещения поверх волны
            left: 72, // Отступ слева
            right: 72, // Отступ справа
            child: Text(
              'У  меня есть online-вакансия или задание',
              textAlign: TextAlign.center, // Добавляем здесь
              style: TextStyle(fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.w500, color: Color(0xFF343434)),
            ),
          ),
        ],
      ),
    );
  }
}
