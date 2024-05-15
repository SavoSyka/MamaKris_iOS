import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MamaKris/wave.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:MamaKris/icon.dart';
import 'package:MamaKris/deleting.dart';
import 'package:MamaKris/pages/start.dart';
import 'package:MamaKris/pages/employer_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:MamaKris/pages/profile.dart';
import 'package:MamaKris/pages/search.dart';

class ProfileEmplPage extends StatefulWidget {
  @override
  _ProfileEmplPageState createState() => _ProfileEmplPageState();

}
class _ProfileEmplPageState extends State<ProfileEmplPage> {
  int _selectedIndex = 1; // Индекс для отслеживания текущего выбранного элемента


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => JobsListPage()),
              (_) => false,
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/support_empl');
        break;
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

    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                  children: [
                    SineWaveWidget(verticalOffset:  285*VerticalMultiply),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 48*VerticalMultiply),
                        child: SvgPicture .asset(
                          'images/logo_named.svg',
                          width: 200*HorizontalMultiply, // Ширина в пикселях
                          height: 200*VerticalMultiply, // Высота в пикселях
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //       left: 5.0*HorizontalMultiply, top: 35*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 0.0),
                    //   child:IconButton(
                    //     icon: Icon(Icons.arrow_back),
                    //     onPressed: () {
                    //       Navigator.pop(context);
                    //     },
                    //   ),
                    // ),    Я убрал эту стрелку назад потому что при смене роли мы чистим стэк страниц и это дает возможность полностью все убить под чистую очистив стэк
                    Padding(
                      padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 310*VerticalMultiply, right:32*HorizontalMultiply, bottom:0), // Общий отступ для группы текстов
                      child:  Align(
                        alignment: Alignment.center,
                        child: user != null ?
                        Text(' ${user.email}', style: TextStyle(fontSize: 15*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w700, color: const Color(0xFF343434), height: 1,),
                        ) :
                        Text('Пользователь не вошел в систему', style: TextStyle(fontSize: 16*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w700, color: const Color(0xFF343434), height: 1,),
                        ),

                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 32 * HorizontalMultiply,
                          top: 424 * VerticalMultiply,
                          right: 32 * HorizontalMultiply,
                          bottom: 0), // Общий отступ для группы текстов
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFB7B39A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                12 * TextMultiply),
                          ),
                          padding: EdgeInsets.only(top: 23 * (height / 800),
                              bottom: 23 * (height / 800)),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                              'СМЕНИТЬ РОЛЬ',
                              style: TextStyle(
                                  fontSize: 14 * TextMultiply,
                                  color: Color(0xFFFFFFFF),
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700)
                          ),
                        ),
                        onPressed: () => updateRole(context),

                      ),
                    ),

                    Padding(
                      padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 496*VerticalMultiply, right: 32*HorizontalMultiply, bottom:32*VerticalMultiply), // Общий отступ для группы текстов
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
                          ),          onPressed: () async {
                          // Выход из аккаунта
                          await FirebaseAuth.instance.signOut();

                          // Перенаправление на экран входа или на начальный экран приложения
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => StartPage()), // Замените SubscribePage() на страницу, на которую хотите перейти
                                (_) => false,
                          );                        },
                          child:  Text(
                            'ВЫЙТИ ИЗ АККАУНТА',
                            style: TextStyle(fontSize: 14*TextMultiply, color: const Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 568*VerticalMultiply, right: 32*HorizontalMultiply, bottom:0), // Общий отступ для группы текстов
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
                              'СБРОСИТЬ ПАРОЛЬ',
                              style: TextStyle(fontSize: 14*TextMultiply, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700)
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/reset');
                        },
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 640*VerticalMultiply, right: 32*HorizontalMultiply, bottom:0), // Общий отступ для группы текстов
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF55567),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12*TextMultiply),
                          ),
                          padding: EdgeInsets.only(top: 23*(height/800), bottom:23*(height/800)),
                        ),
                        child:  Align(
                          alignment: Alignment.center,
                          child: Text(
                              'УДАЛИТЬ АККАУНТ',
                              style: TextStyle(fontSize: 14*TextMultiply, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700)
                          ),
                        ),
                        onPressed: () {
                          deleteUser(context);
                        },
                      ),
                    ),


                  ]
              ),
            ]
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgIcon('images/icons/main.svg'),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: DoubleIcon(
              bottomIconAsset: 'images/icons/profile-bg.svg',
              topIconAsset: 'images/icons/profile.svg',
            ),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: SvgIcon('images/icons/support.svg'),
            label: 'Поддержка',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black, // Цвет выбранного элемента
        unselectedItemColor: Colors.black, // Цвет не выбранного элемента
        onTap: _onItemTapped,
      ),
    );
  }
  final CollectionReference collection = FirebaseFirestore.instance.collection(
      'choices');

  void updateRole(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(
              'Ошибка: Пользователь не аутентифицирован. Пожалуйста, войдите в систему.'))
      );
      return;
    }

    String uid = user.uid;
    DocumentSnapshot snapshot = await collection.doc(uid).get();
    DocumentSnapshot jobSnapshot = await FirebaseFirestore.instance.collection('jobSearches').doc(uid).get();

    String currentRole = snapshot.exists && snapshot.data() != null
        ? (snapshot.data()! as Map<String, dynamic>)['choice'] ?? 'ищу работу'
        : 'ищу работу';

    String newRole = currentRole == 'ищу работу'
        ? 'есть вакансии'
        : 'ищу работу';

    collection.doc(uid).set({'choice': newRole}, SetOptions(merge: true))
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Роль успешно изменена на: $newRole'))
      );
      // Добавляем навигацию на новую страницу в зависимости от новой роли
      if (newRole == 'ищу работу') {        // работодатель --> работник
        if (jobSnapshot.exists) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
                (_) => false,
          );
        }
        else{
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => JobSearchPage()),
                (_) => false,
          );
        }
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ProfileEmplPage()),
              (_) => false,
        );
      }
    })
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при смене роли: $error'))
      );
    });
  }
}