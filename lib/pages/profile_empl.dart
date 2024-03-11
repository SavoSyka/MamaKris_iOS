import 'package:flutter/material.dart';

class ProfileEmplPage extends StatefulWidget {
  @override
  _ProfileEmplPageState createState() => _ProfileEmplPageState();

}
class _ProfileEmplPageState extends State<ProfileEmplPage> {
  int _selectedIndex = 1; // Индекс для отслеживания текущего выбранного элемента

  // Список виджетов для каждой страницы
  final List<Widget> _widgetOptions = [
    const Text('Главная'), // Замените на ваш виджет для /tinder
    const Text('Профиль'), // Замените на ваш виджет для /profile
    const Text('Поддержка'), // Замените на ваш виджет для /support
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/empl_list');
        break;
      case 1:
        Navigator.pushNamed(context, '/profile_empl');
        break;
      case 2:
        Navigator.pushNamed(context, '/support_empl');
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
            icon: Icon(Icons.account_circle_sharp),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Поддержка',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF93D56F),
        unselectedItemColor: Colors.grey, // Цвет неактивных элементов
        onTap: _onItemTapped,
      ),
    );
  }
}