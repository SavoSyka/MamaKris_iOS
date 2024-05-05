import 'dart:math';
import 'package:MamaKris/pages/employer_list.dart';
import 'package:MamaKris/pages/thx_empl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MamaKris/wave.dart';

class JobPage extends StatefulWidget {
  final Map<String, dynamic>? jobData; // Добавляем параметр для передачи данных вакансии

  JobPage({this.jobData});

  @override
  _JobPageState createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  final _formKey = GlobalKey<FormState>();
  final CollectionReference collection = FirebaseFirestore.instance.collection('jobs');

  // Создаем контроллеры для управления текстовыми полями
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactLinkController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();



  double _sliderValue =  log(1000) / ln10;
  bool _isChecked = false;
  final _controller = TextEditingController();

  final int minSalary = 1000;
  final int maxSalary = 1000000;
  final int step = 100; // Шаг ползунка


  String _jobType = 'разовое задание';
  String _sphere = 'Дизайн';
  String _provider = 'Telegram';

  @override
  void initState() {
    super.initState();

    // Устанавливаем начальные значения для полей из переданных данных, если они есть
    if (widget.jobData != null) {
      _titleController.text = widget.jobData!['title'] ?? '';
      _descriptionController.text = widget.jobData!['description'] ?? '';
      _contactLinkController.text = widget.jobData!['contactLink'] ?? '';
      _nameController.text = widget.jobData!['name'] ?? '';
      _jobType = widget.jobData!['jobType'] ?? _jobType;
      _sphere = widget.jobData!['sphere'] ?? _sphere;
      _provider = widget.jobData!['provider'] ?? _provider;

      //_sliderValue = widget.jobData!['salary'] ?? _sliderValue; //TODO ошибка возможно надо следить за чекбоксом
    }
  }

  @override
  void dispose() {
    // Очищаем контроллеры при уничтожении виджета
    _titleController.dispose();
    _descriptionController.dispose();
    _contactLinkController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // Функция для сохранения вакансии
  void _saveJob() async {
    if (_formKey.currentState!.validate()) {
      // Проверяем, что пользователь выбрал тип работы
      if (_jobType != 'once' && _jobType != 'const') {
        // Если тип работы не выбран, показываем сообщение об ошибке
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пожалуйста, выберите тип работы')),
        );
        return; // Прерываем выполнение метода
      }

      _formKey.currentState!.save(); // Сохраняем форму

      Map<String, dynamic> jobData = {
        'jobType': _jobType,
        'sphere': _sphere,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'contactLink': _contactLinkController.text,
        'name' : _nameController.text,
        'employerId': FirebaseAuth.instance.currentUser?.uid,
        'status': 'checking',
        'created_at': FieldValue.serverTimestamp(), // Добавляет текущую метку времени сервера
        'salary': ((pow(10, _sliderValue) / step).round() * step).toString(),
        'provider': _provider,
      };

      try {
        if (widget.jobData != null) {
          // Редактирование существующей вакансии
          await collection.doc(widget.jobData!['id']).update(jobData);
        } else {
          // Добавление новой вакансии
          await collection.add(jobData);
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ThxEmplPage()), // Замените SubscribePage() на страницу, на которую хотите перейти
              (_) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Произошла ошибка при сохранении')));
        print(e);
      }
    }
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
                    left: 32.0*HorizontalMultiply, top: 158*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 0.0),
                child: Text(
                  'Разместить',
                  textAlign: TextAlign.left, // Добавляем здесь
                  style: TextStyle(fontSize: 32*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w700, color: Color(0xFF343434)),
                ),
              ),
            Padding( // Позиционируем кнопку "Ищу работу" на верху экрана
              padding: EdgeInsets.only(
                  left: 32.0*HorizontalMultiply, top: 190*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 0.0),
              child: Text(
                'задание',
                textAlign: TextAlign.left, // Добавляем здесь
                style: TextStyle(fontSize: 32*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w700, color: Color(0xFF343434)),
              ),
            ),

          Padding( // Позиционируем кнопку "Ищу работу" на верху экрана
            padding: EdgeInsets.only(
                left: 4*HorizontalMultiply, top: 246*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 0.0),
            child: Align(
              alignment: Alignment.centerLeft,
            child: ListTile(
                title:  Text('Разовое задание',
                  style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: Color(0xFF343434)),
                ),
                leading: Radio<String>(
                  value: 'once',
                  groupValue: _jobType,
                  onChanged: (value) => setState(() => _jobType = value!),
                  activeColor: const Color(0xFF93D56F), // Цвет выбранного состояния

                ),
                //contentPadding:  EdgeInsets.only(top: 246*VerticalMultiply, left: 62*HorizontalMultiply), // Уменьшенные вертикальные отступы
              ),
          ),
          ),
            Padding( // Позиционируем кнопку "Ищу работу" на верху экрана
              padding: EdgeInsets.only(
                  left: 4*HorizontalMultiply, top: (144+128)*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 0.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ListTile(
                  title:  Text('Постоянная занятость',
                    style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: Color(0xFF343434)),
                  ),
                  leading: Radio<String>(
                    value: 'const',
                    groupValue: _jobType,
                    onChanged: (value) => setState(() => _jobType = value!),
                    activeColor: const Color(0xFF93D56F), // Цвет выбранного состояния

                  ),
                  //contentPadding:  EdgeInsets.only(top: 246*VerticalMultiply, left: 62*HorizontalMultiply), // Уменьшенные вертикальные отступы
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: (202+128)*VerticalMultiply , right:0, bottom:0), // Общий отступ для группы текстов
              child:  Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Название',
                  style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: const Color(0xFF343434), height: 1,),
                ),
              ),
            ),


              _buildTextField(_titleController, 'Название задания', false, (223+128) * VerticalMultiply, 32*HorizontalMultiply, 295*HorizontalMultiply, 60*VerticalMultiply,2, 35),

            Padding(
              padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: (291+128)*VerticalMultiply , right:0, bottom:0), // Общий отступ для группы текстов
              child:  Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Описание',
                  style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: const Color(0xFF343434), height: 1,),
                ),
              ),
            ),


              _buildTextField(_descriptionController, 'Описание задания', false, (312+128)*VerticalMultiply, 32*HorizontalMultiply,295*HorizontalMultiply, 82*VerticalMultiply,50, 5000),


            Padding(
              padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: (408+128)*VerticalMultiply , right:0, bottom:0), // Общий отступ для группы текстов
              child:  Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Сфера',
                  style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: const Color(0xFF343434), height: 1,),
                ),
              ),
            ),

              _buildDropdownField(
                'sphere',
                  _sphere,
                  [ "Дизайн",
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
                  (429+128)*VerticalMultiply, 32*HorizontalMultiply
              ),




            Padding(
              padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: (482+128)*VerticalMultiply , right:0, bottom:0), // Общий отступ для группы текстов
              child:  Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Как с Вами связаться?',
                  style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: const Color(0xFF343434), height: 1,),
                ),
              ),
            ),

            _buildDropdownField(
                'provider',
                _provider,
                [ "Telegram",
                  "WhatsApp",
                  "VK",
                  "Электронная почта",
                  "Телефон",

                ],
                'Выберите провайдера',
                    (newValue) {
                  setState(() {
                    _provider = newValue!;
                  });
                },
                (503+128)*VerticalMultiply, 32*HorizontalMultiply
            ),

            Padding(
              padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: (555+128)*VerticalMultiply , right:0, bottom:0), // Общий отступ для группы текстов
              child:  Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ссылка на контакт',
                  style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: const Color(0xFF343434), height: 1,),
                ),
              ),
            ),


            _buildTextField(_contactLinkController, 'Ссылка на контакт', false, (576+128)*VerticalMultiply, 32*HorizontalMultiply, 295*HorizontalMultiply, 60*VerticalMultiply, 2, 50),

            Padding(
              padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: (645+128)*VerticalMultiply , right:0, bottom:0), // Общий отступ для группы текстов
              child:  Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Как к Вам обращаться?',
                  style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: const Color(0xFF343434), height: 1,),
                ),
              ),
            ),


            _buildTextField(_nameController, 'Имя', false, (666+128)*VerticalMultiply, 32*HorizontalMultiply, 295*HorizontalMultiply, 60*VerticalMultiply, 2, 50),









            Padding(
              padding:  EdgeInsets.only(left: 8*HorizontalMultiply, top: (720+128)*VerticalMultiply , right:32*HorizontalMultiply, bottom:0), // Общий отступ для группы текстов
              child: Column(
                children: <Widget>[
                  CheckboxListTile(
                    title: Text('Указать размер оплаты',
                      style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: const Color(0xFF343434), height: 1,),
                    ),
                    value: _isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading, // Чекбокс слева от текста
                    activeColor: const Color(0xFF93D56F),
                    checkColor: Colors.white, // Цвет галочки
                  ),
                  if (_isChecked)
                    Padding(
                      padding:  EdgeInsets.only(left: 24*HorizontalMultiply, top: 0 , right:0, bottom:0),
                    child: Slider(
                      min: log(minSalary) / ln10,
                      max: log(maxSalary) / ln10,
                      divisions: 1000000,
                      value: _sliderValue,
                      onChanged: (value) {
                        setState(() {
                          _sliderValue = value;
                          int salary = (pow(10, value) / step).round() * step;
                          _controller.text = salary.toString();
                        });
                      },
                      activeColor: const Color(0xFF93D56F),
                      inactiveColor: Colors.grey, // Цвет неактивной части ползунка
                    ),
    ),
                  if (_isChecked)
                    Padding(
                      padding:  EdgeInsets.only(left: 24*HorizontalMultiply, top: 0 , right:0, bottom:0),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: TextField(
                            controller: _controller,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey), // Цвет неактивной полосы
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black), // Цвет активной полосы при фокусе
                              ),
                            ),
                            onChanged: (value) {
                              int? salary = int.tryParse(value);
                              if (salary != null && salary >= minSalary) {
                                salary = salary.clamp(minSalary, maxSalary);
                                setState(() {
                                  _controller.text = salary.toString();
                                });
                              }
                              else {
                                if (salary != null) {
                                  _controller.text = value.toString();
                                }
                                else {
                                  _controller.text = '';
                                }
                              }
                            },
                            onSubmitted: (value) {
                              int salary = (int.tryParse(value) ?? minSalary);
                              if (salary != null && salary >= minSalary) {
                                salary = salary.clamp(minSalary, maxSalary);
                                setState(() {
                                  _sliderValue = log(salary) / ln10;
                                });
                              }
                              else{
                                //TODO: предупреждение что слишком мало бабок платите
                              }
                            },
                          ),
                        ),
                        //Text(' ₽'),
                      ],
                    ),
    ),
                ],
              ),
            ),









            Padding(
            padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: (865+128)*VerticalMultiply, right: 32*HorizontalMultiply, bottom:32*VerticalMultiply), // Общий отступ для группы текстов
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
                onPressed: _saveJob,
                child:  Text('РАЗМЕСТИТЬ',
                    style: TextStyle(fontSize: 14*TextMultiply, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700)
                ),
              ),
            ),
          ),
            ],
          ),
            ],////////////////////
          ),
        ),
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
  bool isTextOverflowing(String text, TextStyle style, double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: maxWidth);

    return textPainter.didExceedMaxLines;
  }



  Widget _buildDropdownField(String type, String currentValue, List<String> options, String label, Function(String?) onChanged, double Vpadding, double Hpadding) {
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
          value: type == 'sphere' ? _sphere : _provider,
        onChanged: (newValue) {
          setState(() {
            if ( type == 'sphere') {
              _sphere = newValue!;
            }
            else{
              _provider = newValue!;
            }
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
            borderRadius: BorderRadius.circular(12*TextMultiply),
            borderSide: const BorderSide(color: Color(0xFF343434), width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12*TextMultiply),
            borderSide: const BorderSide(color: Color(0xFF343434), width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12*TextMultiply),
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