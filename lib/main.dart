import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; // Добавьте этот импорт
import 'package:MamaKris/pages/favorite.dart';
import 'package:MamaKris/pages/login.dart'; // Импортируем login.dart
import 'package:MamaKris/pages/start.dart';
import 'package:MamaKris/pages/welcome.dart';
import 'package:MamaKris/pages/registration.dart';
import 'package:MamaKris/pages/home.dart';
import 'package:MamaKris/pages/verififcation.dart';
import 'package:MamaKris/pages/choice.dart';
import 'package:MamaKris/pages/job_create.dart';
import 'package:MamaKris/pages/search.dart';
import 'package:MamaKris/pages/tinder.dart';
import 'package:MamaKris/pages/support.dart';
import 'package:MamaKris/pages/profile.dart';
import 'package:MamaKris/pages/employer_list.dart';
import 'package:MamaKris/pages/profile_empl.dart';
import 'package:MamaKris/pages/support_empl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MamaKris',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('ru', ''), // Russian, no country code
      ],
      // Удаляем initialRoute и routes
      // Добавляем onGenerateRoute
      onGenerateRoute: (settings) {
        // Получаем имя маршрута
        final name = settings.name;
        // Возвращаем MaterialPageRoute в зависимости от имени маршрута
        switch (name) {
          case '/':
            return MaterialPageRoute(builder: (context) => StartPage());
          case '/login':
            return MaterialPageRoute(builder: (context) => LoginPage());
          case '/welcome':
            return MaterialPageRoute(builder: (context) => WelcomePage());
          case '/registration':
            return MaterialPageRoute(builder: (context) => RegistrationPage());
          case '/job':
            return MaterialPageRoute(builder: (context) => JobPage());
          case '/search':
            return MaterialPageRoute(builder: (context) => JobSearchPage());
          case '/home':
           return MaterialPageRoute(builder: (context) => HomePage());
          case '/tinder':
            return MaterialPageRoute(builder: (context) => TinderPage());
          case '/support':
            return MaterialPageRoute(builder: (context) => SupportPage());
          case '/support_empl':
            return MaterialPageRoute(builder: (context) => SupportEmplPage());
          case '/profile':
            return MaterialPageRoute(builder: (context) => ProfilePage());
          case '/profile_empl':
            return MaterialPageRoute(builder: (context) => ProfileEmplPage());
          case '/empl_list':
            return MaterialPageRoute(builder: (context) => JobsListPage());
          case '/projects':
            return MaterialPageRoute(builder: (context) => FavoritePage());
          case '/choice':
          // // Проверяем, подтверждена ли почта пользователя
            final emailVerified =
                FirebaseAuth.instance.currentUser?.emailVerified ?? false;
            // Если да, то показываем HomePage
            if (emailVerified) {
              return MaterialPageRoute(builder: (context) => ChoicePage());
            } else {
              // Если нет, то показываем VerificationPage
              return MaterialPageRoute(builder: (context) => VerificationPage());
            }
          case '/verification':
            return MaterialPageRoute(builder: (context) => VerificationPage());
          default:
          // Если имя маршрута неизвестно, то показываем страницу с ошибкой
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(
                  child: Text('Страница не найдена'),
                ),
              ),
            );
        }
      },
    );
  }
}
