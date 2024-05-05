import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:MamaKris/pages/conf.dart';
import 'package:MamaKris/payments.dart';



class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  String _selectedPrice = '1990';
  bool _isAgreed = false;

  void _updateSelectedPrice(String price) {
    setState(() {
      _selectedPrice = price;
    });
  }
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    double TextMultiply = min(width/360, height/800);
    double VerticalMultiply = height/800;
    double HorizontalMultiply = width/360;

    return Scaffold(
      backgroundColor: Color(0xFFF0ECD3),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
        Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 73*VerticalMultiply),
                child: SvgPicture .asset(
                  'images/logo.svg',
                  width: 220*HorizontalMultiply, // Ширина в пикселях
                  height: 224*VerticalMultiply, // Высота в пикселях
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 241*VerticalMultiply),
                child: SvgPicture .asset(
                  'images/grad.svg',
                  width: 360*HorizontalMultiply, // Ширина в пикселях
                  height: 124*HorizontalMultiply, // Высота в пикселях
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 283*VerticalMultiply, right:32*HorizontalMultiply, bottom:0), // Общий отступ для группы текстов
              child:  Align(
                alignment: Alignment.center,

                child: Text(
                'Оформи',
                style: TextStyle(fontSize: 40*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w800, color: const Color(0xFF343434),),
              ),
            ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 326*VerticalMultiply, right:32*HorizontalMultiply, bottom:0), // Общий отступ для группы текстов
              child:  Align(
                alignment: Alignment.center,

                child: Text(
                  'подписку',
                  style: TextStyle(fontSize: 40*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w800, color: const Color(0xFF343434),),
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 30*HorizontalMultiply, top: 383*VerticalMultiply, right:30*HorizontalMultiply, bottom:0), // Общий отступ для группы текстов
              child:  Align(
                alignment: Alignment.center,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(fontSize: 16 * TextMultiply, fontFamily: 'Inter1', fontWeight: FontWeight.w500, color: const Color(0xFF343434)), // Основной стиль текста
                    children: <TextSpan>[
                      TextSpan(text: 'Тебе откроется '), // Начало текста
                      TextSpan(text: 'полный', style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Inter',)), // Жирное выделение слова "полный"
                      TextSpan(text: ' доступ\nк банку вакансий и заданий\nна удаленке. С помощью\nприложения MamaKris ты легко\nнайдёшь работу мечты в онлайне.'), // Продолжение текста
                    ],
                  ),
                )

              ),
            ),

            SubscriptionOptions(onPriceSelected: _updateSelectedPrice),


        Padding(
          padding: EdgeInsets.only(left: 46*HorizontalMultiply, top: 646*VerticalMultiply , right:0, bottom:0),
          child:Align(
            alignment: Alignment.center,
          child: Row(
            children: [
            Transform.scale(
            scale: 1.3, // Увеличиваем размер в 1.5 раза
            child:Checkbox(
                value: _isAgreed,
                onChanged: (bool? value) {
                  setState(() {
                    _isAgreed = value!;
                  });
                },

                checkColor: Colors.black, // Цвет галочки
                activeColor: Colors.transparent, // Прозрачный фон активного чекбокса
                fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return Color(0xFFF0ECD3); // Цвет фона при выборе. Вместо Colors.white укажите цвет фона вашего виджета
                  }
                  return Color(0xFFF0ECD3); // Цвет фона по умолчанию. Вместо Colors.white укажите цвет фона вашего виджета
                }),
                side: MaterialStateBorderSide.resolveWith( // Определяем цвет и ширину границы
                      (states) => BorderSide(
                    color: Color(0xFF343434), // Цвет рамки
                    width: 2*TextMultiply, // Ширина рамки
                  ),
                ),
              ),
            ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w500, color: const Color(0xFF343434),),
                children: <TextSpan>[
                  TextSpan(text: 'Согласен с ',
                    style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w500, color: const Color(0xFF343434),),
                  ),
                  TextSpan(
                    text: 'Условиями подписки\n',
                    style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w500, color: const Color(0xFF343434),decoration: TextDecoration.underline,),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => SubscriptionTermsPage()),
                        // );
                      },
                  ),
                  TextSpan(text: ' и ',
                    style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w500, color: const Color(0xFF343434),),
                  ),
                  TextSpan(
                    text: 'Политикой конфиденциальности',
                    style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w500, color: const Color(0xFF343434),decoration: TextDecoration.underline,),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
                        );
                      },
                  ),
                ],
              ),
            ),
          ),
          ],
            ),
        ),
        ),
        Padding(
          padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 708*VerticalMultiply, right: 32*HorizontalMultiply, bottom:32*VerticalMultiply), // Общий отступ для группы текстов
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF93D56F), Color(0xFF659A57)], // Градиент от #93D56F до #659A57
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(30*TextMultiply), // Скругление углов
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // Прозрачный фон для отображения градиента
                shadowColor: Colors.transparent, // Убираем тень
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30*TextMultiply), // Скругление углов
                ),
                minimumSize: Size(double.infinity, 60*VerticalMultiply), // Растягиваем кнопку на всю ширину с высотой 60
                padding: EdgeInsets.only(top: 23*VerticalMultiply, bottom:23*VerticalMultiply),
              ),
              onPressed: () async {
                if (_isAgreed) { // Проверка, выбран ли чекбокс
                  print('pressed');
                  String message = await PaymentHelper.makePayment();
                  print(message); // Вывод результата в консоль или отображение в интерфейсе.
                } else {
                  // Показываем сообщение, если чекбокс не выбран
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Внимание!'),
                        content: const Text('Необходимо согласиться с политикой конфиденциальности и условиями подписки.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Закрытие диалогового окна
                            },
                            child: const Text('ОК'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },

              child: Text('ПОДПИСАТЬСЯ ЗА $_selectedPrice ₽',
                  style: TextStyle(fontSize: 14*TextMultiply, color: const Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700),
                ),
              ),
            ),
        ),
          ],
        ),
      ],
    ),
      ),
    );
  }
}
class SubscriptionOptions extends StatefulWidget {
  final Function(String) onPriceSelected;
  SubscriptionOptions({required this.onPriceSelected});

  @override
  _SubscriptionOptionsState createState() => _SubscriptionOptionsState();
}

class _SubscriptionOptionsState extends State<SubscriptionOptions> {
  int _selectedOptionIndex = 1;



  List<Map<String, String>> options = [
    {'title': 'month', 'price': '499'},
    {'title': 'half', 'price': '1990'},
    {'title': 'year', 'price': '2350'},
  ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    double TextMultiply = min(width/360, height/800);
    double VerticalMultiply = height/800;
    double HorizontalMultiply = width/360;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: options.asMap().entries.map((entry) {
        int idx = entry.key;
        Map<String, String> option = entry.value;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedOptionIndex = idx;
              widget.onPriceSelected(option['price']!);
            });
          },
          child: Padding(
            padding: EdgeInsets.only(top: 522*VerticalMultiply, right: 8*HorizontalMultiply),

            child: Container(
              width: 93*HorizontalMultiply,
            height: 92*VerticalMultiply,
            decoration: BoxDecoration(
              color:  Color(0xFFFFFFFF),

              boxShadow: [
                _selectedOptionIndex == idx ? BoxShadow(
                    color:  Color(0xFF93D56F), // Цвет тени
                    spreadRadius: 3*TextMultiply, // Размер "рамки" вокруг контейнера
                    blurRadius: 0, // Степень размытия тени, 0 означает отсутствие размытия
                    offset: Offset(0, 0), // Смещение тени, (0, 0) означает, что тень равномерно распределена вокруг контейнера
                  ) : const BoxShadow(
                  color: Colors.transparent, // Прозрачный цвет для "тени", когда элемент не выбран
                  spreadRadius: 0,
                  blurRadius: 0,
                  offset: Offset(0, 0),
                ),
              ],
              borderRadius: BorderRadius.circular(16*TextMultiply),
            ),

            child: option['title'] == 'month'? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center, // Выравнивание дочерних элементов по центру по горизонтали
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16*VerticalMultiply, ),
                  child: Text('1 месяц',
                    textAlign: TextAlign.center, // Выравнивание текста по центру горизонтали
                    style: TextStyle(height: 0.001, fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: const Color(0xFF343434),),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: (45-16)*VerticalMultiply, bottom: 0 ), // Адаптируйте отступы по необходимости
                  child: Text('499 ₽', // Пример текста для второго Padding
                    textAlign: TextAlign.center, // Выравнивание текста по центру горизонтали
                    style: TextStyle(height: 0.001, fontSize: 15*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w700, color: const Color(0xFF343434),),
                  ),
                ),
              ],
            ) : option['title'] == 'half'?Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16*VerticalMultiply, ),
                  child: Text('6 месяцев',

                    textAlign: TextAlign.center, // Выравнивание текста по центру горизонтали
                    style: TextStyle(height: 0.001, fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: const Color(0xFF343434),),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: (45-16)*VerticalMultiply, bottom: 0 ), // Адаптируйте отступы по необходимости
                  child: Text('1990 ₽', // Пример текста для второго Padding
                    textAlign: TextAlign.center, // Выравнивание текста по центру горизонтали
                    style: TextStyle(height: 0.001, fontSize: 15*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w700, color: const Color(0xFF343434),),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: (65-45)*VerticalMultiply, ), // Адаптируйте отступы по необходимости
                  child: Text('332 ₽ / месяц', // Пример текста для второго Padding
                    textAlign: TextAlign.center, // Выравнивание текста по центру горизонтали
                    style: TextStyle(height: 0.001, fontSize: 11*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: const Color(0xFF3434347A),),
                  ),
                ),
              ],
            ) : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center, // Выравнивание дочерних элементов по центру по горизонтали
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16*VerticalMultiply, ),
                  child: Text('1 год',
                    textAlign: TextAlign.center, // Выравнивание текста по центру горизонтали
                    style: TextStyle(height: 0.001, fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: const Color(0xFF343434),),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: (45-16)*VerticalMultiply, bottom: 0 ), // Адаптируйте отступы по необходимости
                  child: Text('2350 ₽', // Пример текста для второго Padding
                    textAlign: TextAlign.center, // Выравнивание текста по центру горизонтали
                    style: TextStyle(height: 0.001, fontSize: 15*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w700, color: const Color(0xFF343434),),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: (65-45)*VerticalMultiply, ), // Адаптируйте отступы по необходимости
                  child: Text('196 ₽ / месяц', // Пример текста для второго Padding
                    textAlign: TextAlign.center, // Выравнивание текста по центру горизонтали
                    style: TextStyle(height: 0.001, fontSize: 11*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: const Color(0xFF3434347A),),
                  ),
                ),
              ],
            )
          ),
        ),
        );
      }).toList(),
    );
  }
}
class SubscriptionOption extends StatelessWidget {
  final String title;
  final String price;
  final bool isSelected;
  final VoidCallback onSelect;

  const SubscriptionOption({
    required this.title,
    required this.price,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.green[700]! : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text('$title - $price'),
      ),
    );
  }
}

