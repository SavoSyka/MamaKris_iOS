import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MamaKris/wave.dart';
import 'package:MamaKris/pages/tinder.dart';

class JobSearchPage extends StatefulWidget {
  @override
  _JobSearchPageState createState() => _JobSearchPageState();
}

class _JobSearchPageState extends State<JobSearchPage> {
  final CollectionReference collection = FirebaseFirestore.instance.collection('jobSearches');
  final _formKey = GlobalKey<FormState>();
  bool _openToPermanent = false;
  bool _openToTemporary = false;
  String _sphere = 'Пока не знаю, первый раз смотрю в мир онлайн-заработка';

  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    double TextMultiply = min(width/360, height/800);
    double VerticalMultiply = height/800;
    double HorizontalMultiply = width/360;
    return Scaffold(

      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,

            children: <Widget>[
          Stack(
          children: [
            SineWaveWidget( verticalOffset: 128*VerticalMultiply),

          Padding( // Позиционируем кнопку "Ищу работу" на верху экрана
            padding: EdgeInsets.only(
                left: 5.0*HorizontalMultiply, top: 35*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 0.0),
            child:IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
            Padding( // Позиционируем кнопку "Ищу работу" на верху экрана
              padding: EdgeInsets.only(
                  left: 32.0*HorizontalMultiply, top: (30+128)*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 0.0),
              child: Text(
                'Разместить',
                textAlign: TextAlign.left, // Добавляем здесь
                style: TextStyle(fontSize: 32*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w700, color: Color(0xFF343434)),
              ),
            ),
            Padding( // Позиционируем кнопку "Ищу работу" на верху экрана
              padding: EdgeInsets.only(
                  left: 32.0*HorizontalMultiply, top: (30+128+32)*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 0.0),
              child: Text(
                'заявку на поиск',
                textAlign: TextAlign.left, // Добавляем здесь
                style: TextStyle(fontSize: 32*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w700, color: Color(0xFF343434)),
              ),
            ),
            Padding( // Позиционируем кнопку "Ищу работу" на верху экрана
              padding: EdgeInsets.only(
                  left: 32.0*HorizontalMultiply, top: (30+128+32*2)*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 0.0),
              child: Text(
                'работы',
                textAlign: TextAlign.left, // Добавляем здесь
                style: TextStyle(fontSize: 32*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w700, color: Color(0xFF343434)),
              ),
            ),
            Padding( // Позиционируем кнопку "Ищу работу" на верху экрана
              padding: EdgeInsets.only(
                  left: 32.0*HorizontalMultiply, top: (156+128)*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 0.0),
              child: Text(
                'Формат сотрудничества',
                textAlign: TextAlign.left, // Добавляем здесь
                style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: Color(0xFF343434)),
              ),
            ),
            Padding( // Позиционируем кнопку "Ищу работу" на верху экрана
              padding: EdgeInsets.only(
                  left: 10.0*HorizontalMultiply, top: (170+128)*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 0.0),
              child: CheckboxListTile(
                title:  Text('Разовая подработка',
                  style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: Color(0xFF343434)),
                ),
                value: _openToTemporary,
                onChanged: (bool? value) {
                  setState(() {
                    _openToTemporary = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: const Color(0xFF93D56F), // Цвет фона чекбокса при активации
                checkColor: Colors.white, // Цвет галочки в чекбоксе
              ),
            ),
          Padding( // Позиционируем кнопку "Ищу работу" на верху экрана
            padding: EdgeInsets.only(
                left: 10.0*HorizontalMultiply, top: (198+128)*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 0.0),
            child: CheckboxListTile(
                title:  Text('Постоянная занятость',
                  style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: Color(0xFF343434)),
                ),
                value: _openToPermanent,
                onChanged: (bool? value) {
                  setState(() {
                    _openToPermanent = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: const Color(0xFF93D56F), // Цвет фона чекбокса при активации
                checkColor: Colors.white, // Цвет галочки в чекбоксе
              ),
          ),
            Padding(
              padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: (265+128)*VerticalMultiply, right:0, bottom:0), // Общий отступ для группы текстов
              child:  Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Сфера деятельности',
                  style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: const Color(0xFF343434), height: 1,),
                ),
              ),
            ),
              _buildDropdownField(
                  _sphere,
                  ["Пока не знаю, первый раз смотрю в мир онлайн-заработка",
                    "Дизайн",
                    "Разработка и IT",
                    "Тексты и переводы",
                    "Обработка фото и монтаж видео",
                    "Копирайтинг, контент, рерайтинг",
                    "SEO и трафик",
                    "SMM: Социальные сети, блоги, реклама",
                    "Продажи, HR, рекрутинг",
                    "Маркетинг",
                    "Менеджмент",
                    "Методология",
                    "Модератор, тестировщик",
                    "Психология, коучинг, кураторство",
                    "Административные задачи",
                    "Творческие и креативные задачи",
                    "Репетиторство",
                    "Консалтинг",
                    "Общие задачи",
                    "Очумелые ручки (торты, шитье на заказ, вязание, любой hand made)"
                  ],
                  'Выберите сферу',
                      (newValue) {
                    setState(() {
                      _sphere = newValue!;
                    });
                  },
                  (286+128)*VerticalMultiply, 32*HorizontalMultiply
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          await collection.doc(user.uid).set({
                            'openToPermanent': _openToPermanent,
                            'openToTemporary': _openToTemporary,
                            'sphere': _sphere,
                            'employerId': user.uid,
                            'viewedAdsCount': 0,
                            'hasSubscription': true, // TODO: после добавления оплаты сменитть на false
                          },  SetOptions(merge: true));
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => TinderPage()), // Замените SubscribePage() на страницу, на которую хотите перейти
                                (_) => false,
                          );                        }
                      }
                    },
                      child:  Text('РАЗМЕСТИТЬ',
                          style: TextStyle(fontSize: 14*TextMultiply, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700)
                      ),
                    ),
                ),
              ),
            ],),],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String currentValue, List<String> options, String label, Function(String?) onChanged, double Vpadding, double Hpadding) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    double TextMultiply = min(width/360, height/800);
    double VerticalMultiply = height/800;
    double HorizontalMultiply = width/360;

    return Padding(
        padding: EdgeInsets.only(top: Vpadding, right: Hpadding, left: Hpadding),
    child: SizedBox(
    width: 295*HorizontalMultiply, // Фиксированная ширина
    height: 60*VerticalMultiply, // Фиксированная высота
    child: DropdownButtonFormField<String>(
          isExpanded: true,
          value: _sphere,
          onChanged: (newValue) {
            setState(() {
              _sphere = newValue!;
            });
          },
          selectedItemBuilder: (BuildContext context) {
            return options.map<Widget>((String value) {
              return Text(
                value,
                overflow: TextOverflow.ellipsis, // Только для выбранного элемента
              );
            }).toList();
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 32.0), // Уменьшенные отступы
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: const TextStyle(color: Color(0xFF343434)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF343434), width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF343434), width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF343434), width: 2.0),
            ),
          ),
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                softWrap: true, // Перенос строки для элементов в раскрытом списке
              ),
            );
          }).toList(),
        )
    ),
    );
  }
}