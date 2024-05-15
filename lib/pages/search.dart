import 'dart:math';
import 'package:MamaKris/pages/thx_ee.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MamaKris/wave.dart';
import 'package:MamaKris/pages/tinder.dart';
import 'package:flutter/gestures.dart';
import 'package:MamaKris/pages/conf.dart';

class JobSearchPage extends StatefulWidget {
  final Map<String, dynamic>? jobSearchData;

  JobSearchPage({this.jobSearchData});

  @override
  _JobSearchPageState createState() => _JobSearchPageState();
}

class _JobSearchPageState extends State<JobSearchPage> {
  bool _isAgreed = false;
  bool _isAgreed2 = false;
  final CollectionReference collection = FirebaseFirestore.instance.collection('jobSearches');
  final _formKey = GlobalKey<FormState>();
  bool _openToPermanent = false;
  bool _openToTemporary = false;
  String _sphere = 'Все вакансии интересны, так как только изучаю рынок онлайна и первый раз смотрю в сторону онлайн заработка.';
  final TextEditingController _phoneController = TextEditingController();
  int _viewedAdsCount = 0;
  bool _hasSubscription = true;//TODO: после добавления оплатьы поменять на false

  @override
  void initState() {
    super.initState();
    print("Предоставленные данные: ${widget.jobSearchData}");

    // Заполнение полей, если данные уже существуют
    if (widget.jobSearchData != null) {
      _openToPermanent = widget.jobSearchData!['openToPermanent'] ?? false;
      _openToTemporary = widget.jobSearchData!['openToTemporary'] ?? false;
      _sphere = widget.jobSearchData!['sphere'] ?? _sphere;
      _phoneController.text = widget.jobSearchData!['phone'] ?? '';
      _viewedAdsCount = widget.jobSearchData!['viewedAdsCount'] ?? 0;
      _hasSubscription = widget.jobSearchData!['hasSubscription'] ?? true;//TODO: после добавления оплатьы поменять на false
      _isAgreed = widget.jobSearchData!['isAgreed'] ?? false;
      _isAgreed2 = widget.jobSearchData!['isAgreed'] ?? false;

    }
  }

  void _saveJobSearch() async {
    print('begin_save');
    if (!_openToPermanent && !_openToTemporary) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, выберите хотя бы один формат сотрудничества.')),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Получаем текущего пользователя
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка: Пользователь не найден')),
        );
        return;
      }

      // Создаем данные для сохранения
      Map<String, dynamic> jobSearchData = {
        'openToPermanent': _openToPermanent,
        'openToTemporary': _openToTemporary,
        'sphere': _sphere,
        'employerId': user.uid,
        'viewedAdsCount': _viewedAdsCount,
        'hasSubscription': _hasSubscription,
        'phone': _phoneController.text,
        'isAgreed': _isAgreed2,
      };

      try {
        // Если данные уже существуют, обновляем
        if (widget.jobSearchData != null && widget.jobSearchData!.containsKey('id')) {
          await collection.doc(widget.jobSearchData!['id']).update(jobSearchData);
        } else {
          // Создаем новую запись
          await collection.doc(user.uid).set(jobSearchData, SetOptions(merge: true));
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ThxPage()),
              (_) => false,
        );
      } catch (e, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Произошла ошибка при сохранении')));
        print("Ошибка при сохранении данных: $e");
        print("Stack trace: $stackTrace");
      }
    }
  }

  //
  //
  //     // Получение текущего идентификатора пользователя
  //     String? userId = FirebaseAuth.instance.currentUser?.uid;
  //
  //     if (userId == null) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Ошибка: Пользователь не найден')),
  //       );
  //       return;
  //     }
  //
  //     // Создание данных для сохранения
  //     Map<String, dynamic> jobSearchData = {
  //       'openToPermanent': _openToPermanent,
  //       'openToTemporary': _openToTemporary,
  //       'sphere': _sphere,
  //       'employerId': userId,
  //       'viewedAdsCount': _viewedAdsCount,
  //       'hasSubscription': _hasSubscription,
  //       'phone': _phoneController.text,
  //     };
  //
  //     try {
  //       // Проверка на существование данных в `widget.jobSearchData`
  //       if (widget.jobSearchData != null && widget.jobSearchData!.containsKey('id')) {
  //         // Обновить существующую запись по её идентификатору
  //         await collection.doc(widget.jobSearchData!['id']).update(jobSearchData);
  //       } else {
  //         // Создать новую запись для текущего пользователя
  //         await collection.doc(userId).set(jobSearchData, SetOptions(merge: true));
  //       }
  //
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => ThxPage()),
  //             (_) => false,
  //       );
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Произошла ошибка при сохранении')));
  //       print(e);
  //     }
  //   }
  // }



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
                  ["Все вакансии интересны, так как только изучаю рынок онлайна и первый раз смотрю в сторону онлайн заработка",
                    "Дизайн",
                    "Разработка и IT",
                    "Тексты и переводы",
                    "Обработка фото и монтаж видео",
                    "Копирайтинг, контент, рерайтинг",
                    "SEO и трафик",
                    "SMM: Социальные сети, блоги, реклама",
                    "Продажи, HR, рекрутинг",
                    "Продюсирование",
                    "Криптовалюты, блокчейн",
                    "Маркетинг",
                    "Маркетплейсы",
                    "Менеджмент",
                    "Методология",
                    "Модератор, тестировщик",
                    "Нейросети",
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
              padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: (350+128)*VerticalMultiply, right:0, bottom:0), // Общий отступ для группы текстов
              child:  Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Номер телефона',
                  style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: const Color(0xFF343434), height: 1,),
                ),
              ),
            ),
            _buildTextField(_phoneController, 'Телефон', false, (371+128)*VerticalMultiply, 32*HorizontalMultiply, 295*HorizontalMultiply, 60*VerticalMultiply, 1, 15),
          Visibility(
            visible: !_isAgreed,
            replacement: Container(), // Показываем, если _isAgreed == false
            child:
            Padding(
              padding: EdgeInsets.only(left: 46*HorizontalMultiply, top: 646*VerticalMultiply , right:0, bottom:0),
              child:Align(
                alignment: Alignment.center,
                child: Row(
                  children: [
                   Checkbox(
                        value: _isAgreed2,
                        onChanged: (bool? value) {
                          setState(() {
                            _isAgreed2 = value!;
                          });
                        },

                        checkColor: Colors.white, // Цвет галочки
                        activeColor: const Color(0xFF93D56F),

                        // side: MaterialStateBorderSide.resolveWith( // Определяем цвет и ширину границы
                        //       (states) => BorderSide(
                        //     color: Color(0xFF343434), // Цвет рамки
                        //     width: 2*TextMultiply, // Ширина рамки
                        //   ),
                        // ),
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
                  print(_isAgreed2);
                  print(_isAgreed);

                  if (_isAgreed2){
                    print('gere');
                    //_isAgreed = _isAgreed2;
                    _saveJobSearch();
                    }
                  else {
                    // Показываем сообщение, если чекбокс не выбран
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Внимание!'),
                          content: const Text('Необходимо согласиться с политикой конфиденциальности'),
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


  Widget _buildTextField(TextEditingController controller, String label, bool obscureText, double Vpadding, double Hpadding, double wdth, double hght, int maxLines, int maxLength) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    double TextMultiply = min(width/360, height/800);
    return Padding(
      padding:  EdgeInsets.only(top: Vpadding, right: Hpadding, left: Hpadding),
      child: Container(
        constraints: BoxConstraints(
          minWidth: wdth, // Минимальная ширина
          maxWidth: wdth, // Максимальная ширина
          minHeight: hght,
          maxHeight: hght,
        ),
        width: wdth, // Фиксированная ширина
        height: hght, // Фиксированная высота
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          maxLines: maxLines, // Разрешить перенос текста на следующую строку
          maxLength: maxLength,
          keyboardType: TextInputType.multiline, // Установить тип клавиатуры для многострочного ввода
          decoration: InputDecoration(
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 32.0), // Уменьшенные отступы
            floatingLabelBehavior: FloatingLabelBehavior.always, // Лейбл всегда над полем
            labelStyle: const TextStyle(color: Color(0xFF343434)), // Цвет лейбла
            // Устанавливаем толстую рамку
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12*TextMultiply),
              borderSide: const BorderSide(color:Color(0xFF343434), width: 2.0), // Увеличиваем ширину рамки
            ),
            // Также применяем стиль рамки когда поле в фокусе
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12*TextMultiply),
              borderSide: const BorderSide(color: Color(0xFF343434), width: 2.0), // Та же толщина рамки
            ),
            // Стиль рамки при вводе неверных данных
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12*TextMultiply),
              borderSide: const BorderSide(color: Colors.red, width: 2.0), // Можно изменить цвет/толщину для ошибок
            ),
          ),
        ),
      ),
    );
  }

}


