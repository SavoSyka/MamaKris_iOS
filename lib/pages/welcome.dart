import 'package:flutter/material.dart';
import 'package:MamaKris/wave.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categories = [
      'Мам в декрете',
      'Студентов',
      'Пенсионеров',
      'Фрилансеров',
    ];

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: [
              SineWaveWidget(verticalOffset: 300),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 38),
                  child: Image.asset('images/logo_named.png'),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 32.0, top: 55.0, right: 20.0, bottom: 0.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 16,
                      fontFamily: 'Inter',
                      color: Color(0xFF343434)),
                  children: <TextSpan>[
                    TextSpan(text: 'MamaKris',
                        style: TextStyle(fontWeight: FontWeight.w900)),
                    TextSpan(
                        text: ' — это самая удобная платформа по поиску и размещению интересных вакансий и заданий для онлайн-заработка. Платформа создана для:'),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: EdgeInsets.only(
                  left: 28.0, top: 10.0, right: 28.0, bottom: 4.0),
              crossAxisCount: 2, // Задаём количество элементов в строке
              childAspectRatio: 3 / 1, // Пропорции табличек
              children: categories.map((category) =>
                  Container(
                    margin: EdgeInsets.only(
                        left: 4.0, top: 4.0, right: 4.0, bottom: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFF0ECD3), width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(category, style: TextStyle(fontSize: 16)),
                    ),
                  )).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 32.0, top: 21.0, right: 32.0, bottom: 6.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF93D56F),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Скругление углов
                ),
                // Задание минимальной ширины кнопки, double.infinity заставляет кнопку растянуться
                minimumSize: Size(double.infinity, 60), // Растягиваем кнопку на всю ширину с высотой 50
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/registration');
              },
              child: Text(
              'Продолжить',
                  style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700)
              ),
            ),
        ),

          Padding(
            padding: const EdgeInsets.only(
                left: 32.0, top: 6.0, right: 32.0, bottom: 32.0),
              child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB7B39A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Скругление углов
                ),
                // Задание минимальной ширины кнопки, double.infinity заставляет кнопку растянуться
                minimumSize: Size(double.infinity, 60), // Растягиваем кнопку на всю ширину с высотой 50
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                  'Назад',
                  style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700)
              ),
            ),
          ),
        ],
      ),
    );
  }
}