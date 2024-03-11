import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();

}
class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 2; // Индекс для отслеживания текущего выбранного элемента

  // Список виджетов для каждой страницы
  final List<Widget> _widgetOptions = [
    Text('Главная'), // Замените на ваш виджет для /tinder
    Text('Проекты'), // Замените на ваш виджет для /projects
    Text('Профиль'), // Замените на ваш виджет для /profile
    Text('Поддержка'), // Замените на ваш виджет для /support
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });


    switch(index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/tinder');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/projects');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/support');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        // Отображение виджета, соответствующего текущему выбранному элементу
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_sharp),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag_sharp),
            label: 'Проекты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Поддержка',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF93D56F),
        unselectedItemColor: Colors.grey, // Цвет неактивных элементов+
        onTap: _onItemTapped,
      ),
    );
  }
}