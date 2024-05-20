import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart'; // Добавьте этот импорт
import 'package:firebase_auth/firebase_auth.dart';

// это важный файл и не надо его случайно удалять
Future<String> getInitialRoute() async {
  await Firebase.initializeApp();
  User? user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    // Пользователь не вошел
    return '/welcome';
  } else {
    // Проверяем, вошел ли пользователь через Google
    bool isGoogleUser = user.providerData.any((provider) => provider.providerId == 'google.com');

    // Проверяем, подтверждена ли почта пользователя
    bool isEmailVerified = user.emailVerified;


    if (isGoogleUser || isEmailVerified) {
      // Пользователь вошел через Google или его email подтвержден
      final docSnapshot = await FirebaseFirestore.instance.collection('choices').doc(user.uid).get();
      final docSnapshot2 = await FirebaseFirestore.instance.collection('jobSearches').doc(user.uid).get();

      if (docSnapshot.exists && docSnapshot.data()!.containsKey('choice')) {
        final choice = docSnapshot.data()!['choice'];
        if (choice == 'ищу работу' && docSnapshot2.exists) {
          return '/tinder'; // Перенаправляем на страницу поиска работы
        }
        else if (choice == 'ищу работу') {
          print('Содержимое docSnapshot: ${docSnapshot.data()}');
          print(user.uid);
          print('Содержимое docSnapshot2: ${docSnapshot2.data()}');
          return '/search'; // Перенаправляем на страницу поиска работы
        }
        else if (choice == 'есть вакансии') {
          return '/empl_list'; // Перенаправляем на страницу с вакансиями
        }
      }
      return '/choice'; // Перенаправляем на страницу выбора, если не удалось определить выбор пользователя
    } else {
      // Email пользователя не подтвержден и вход не через Google
      return '/verification'; // Перенаправляем на страницу верификации
    }
  }
}
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _checkStatusAndNavigate(context); // Вызываем проверку при построении виджета
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Показываем индикатор загрузки
      ),
    );
  }

  Future<void> _checkStatusAndNavigate(BuildContext context) async {
    String routeName = await getInitialRoute(); // Используем функцию для получения начального маршрута
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.of(context).pushReplacementNamed(routeName); // Перенаправляем на нужную страницу
    }
  }
}
