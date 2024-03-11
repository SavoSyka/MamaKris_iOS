import 'package:flutter/material.dart';
import 'package:MamaKris/wave.dart'; // Убедитесь, что wave.dart содержит SineWaveWidget

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Изменено на start для размещения волны в верху
        children: <Widget>[
          Stack(
            children: [
              SineWaveWidget(verticalOffset: 300), // Ваша волна
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 38), // Отступ сверху в 50 пикселей
                  child: Image.asset('images/logo_named.png'),
                ),
              )
            ],
          ),
          Expanded( // Используем Expanded для центрирования кнопок в оставшемся пространстве
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 32.0, top: 0.0, right: 20.0, bottom: 0.0), // Отступ со всех сторон
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Добро',
                        style: TextStyle(fontSize: 40, fontFamily: 'Inter', fontWeight: FontWeight.w800, color: Color(0xFF343434))
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 32.0, top: 0.0, right: 20.0, bottom: 5.0), // Отступ со всех сторон
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'пожаловать!',
                        style: TextStyle(fontSize: 40, fontFamily: 'Inter', fontWeight: FontWeight.w800, color: Color(0xFF343434)),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 32.0, top: 0.0, right: 20.0, bottom: 5.0), // Отступ со всех сторон
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Войдите или создайте аккаунт',
                        style: TextStyle(fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.w700, // Делаем текст более жирным
                        ),
                      ),
                    ),
                  ),

                  Row(
                    children: <Widget>[
                      Expanded( // Растягиваем кнопку на всю доступную ширину в Row
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 6.0), // Отступы по бокам
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF93D56F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Создать аккаунт',
                              style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700)
                            ),
                          ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/welcome');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded( // Растягиваем кнопку на всю доступную ширину в Row
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 6.0), // Отступы по бокам
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB7B39A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                  'Войти',
                                  style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700)
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
