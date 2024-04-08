import 'package:flutter/material.dart';
import 'package:MamaKris/wave.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categories = [
      'Мам в декрете',
      'Студентов',
      'Пенсионеров',
      'Фрилансеров',
    ];
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    double TextMultiply = min(width/360, height/800);
    double VerticalMultiply = height/800;
    double HorizontalMultiply = width/360;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: [
              SineWaveWidget(verticalOffset: 340*VerticalMultiply),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 58*VerticalMultiply),
                  child: SvgPicture.asset(
                    "images/logo_named.svg",
                    width: 220*HorizontalMultiply, // Ширина в пикселях
                    height: 224*VerticalMultiply, // Высота в пикселях
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 5.0*HorizontalMultiply, top: 35*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 0.0),
                child:IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),

          Padding(
            padding:  EdgeInsets.only(
                left: 32.0*HorizontalMultiply, top: 90*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 0.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text:  TextSpan(
                  style: TextStyle(fontSize: 16*TextMultiply,
                      color: Color(0xFF343434)),
                  children: const <TextSpan>[
                    TextSpan(text: 'MamaKris',
                      style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Inter',
                      ),
                    ),
                    TextSpan(
                      text: ' — это самая удобная платформа по поиску и размещению интересных вакансий и заданий для онлайн-заработка. Платформа создана для:',
                      style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Inter1',height: 23/16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: EdgeInsets.only(
                  left: (32-8)*HorizontalMultiply, top: (20-8)*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 0.0),
              crossAxisCount: 2, // Задаём количество элементов в строке
              childAspectRatio: (3*HorizontalMultiply) / (1*VerticalMultiply), // Пропорции табличек
              children: categories.map((category) =>
                  Container(
                    margin: EdgeInsets.only(
                        left: 8.0*HorizontalMultiply, top: 8*VerticalMultiply, right: 0.0, bottom: 0.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFF0ECD3), width: 2),
                      borderRadius: BorderRadius.circular(12*TextMultiply),
                    ),
                    child: Center(
                      child: Text(category, style: TextStyle(fontSize: 13*TextMultiply, fontWeight: FontWeight.w600,)),
                    ),
                  )).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 32.0*HorizontalMultiply, top: 0, right: 32.0*HorizontalMultiply, bottom: 0),
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

                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/registration');
                },
                child: const Text(
                  'ПРОДОЛЖИТЬ',
                  style: TextStyle(fontSize: 14, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),


          Padding(
            padding:  EdgeInsets.only(
                left: 32.0*HorizontalMultiply, top: 12*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 32*VerticalMultiply),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB7B39A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12*TextMultiply), // Скругление углов
                ),
                // Задание минимальной ширины кнопки, double.infinity заставляет кнопку растянуться
                minimumSize: Size(double.infinity, 60*VerticalMultiply), // Растягиваем кнопку на всю ширину с высотой 60
                padding: EdgeInsets.only(top: 23*VerticalMultiply, bottom:23*VerticalMultiply),              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                  'НАЗАД',
                  style: TextStyle(fontSize: 14, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700)
              ),
            ),
          ),
        ],
      ),
    );
  }
}