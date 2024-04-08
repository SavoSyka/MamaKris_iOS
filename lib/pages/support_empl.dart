import 'package:flutter/material.dart';
import 'package:MamaKris/icon.dart';
import 'package:MamaKris/pages/conf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:MamaKris/pages/employer_list.dart';

class SupportEmplPage extends StatefulWidget {
  @override
  _SupportEmplPageState createState() => _SupportEmplPageState();

}
class _SupportEmplPageState extends State<SupportEmplPage> {
  int _selectedIndex = 2; // Индекс для отслеживания текущего выбранного элемента

  // Список виджетов для каждой страницы
  final List<Widget> _widgetOptions = [
    Text('Главная'), // Замените на ваш виджет для /tinder
    Text('Профиль'), // Замените на ваш виджет для /profile
    Text('Поддержка'), // Замените на ваш виджет для /support
  ];

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
        Navigator.pushReplacementNamed(context, '/profile_empl');
        break;
      case 2:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0ECD3),

        title: const Text(''),
      ),
      backgroundColor: const Color(0xFFF0ECD3),

      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: const Text('Поддержка.\nНапишите нам, если у Вас остались вопросы, замечания, предложения.'),
              trailing: const Icon(Icons.send),
              onTap: () => _launchURL('https://t.me/MamaKris_support_bot?start=help'),
                // Код для перехода в Telegram бота

            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: const Text('Политика конфиденциальности'),
              //trailing: const Icon(Icons.send),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgIcon('images/icons/main.svg'),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: SvgIcon('images/icons/profile.svg'),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: DoubleIcon(
              bottomIconAsset: 'images/icons/support-bg.svg',
              topIconAsset: 'images/icons/support.svg',
            ),
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
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Не удалось открыть $url';
    }
  }
}