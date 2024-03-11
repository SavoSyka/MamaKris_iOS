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

  String _jobType = 'разовое задание';
  String _sphere = 'Маркетинг';
  @override
  void initState() {
    super.initState();

    // Устанавливаем начальные значения для полей из переданных данных, если они есть
    if (widget.jobData != null) {
      _titleController.text = widget.jobData!['title'] ?? '';
      _descriptionController.text = widget.jobData!['description'] ?? '';
      _contactLinkController.text = widget.jobData!['contactLink'] ?? '';
      _jobType = widget.jobData!['jobType'] ?? _jobType;
      _sphere = widget.jobData!['sphere'] ?? _sphere;
    }
  }

  @override
  void dispose() {
    // Очищаем контроллеры при уничтожении виджета
    _titleController.dispose();
    _descriptionController.dispose();
    _contactLinkController.dispose();
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
        'employerId': FirebaseAuth.instance.currentUser?.uid,
      };

      try {
        if (widget.jobData != null) {
          // Редактирование существующей вакансии
          await collection.doc(widget.jobData!['id']).update(jobData);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Вакансия обновлена')));
        } else {
          // Добавление новой вакансии
          await collection.add(jobData);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Вакансия добавлена')));
        }

        Navigator.pushReplacementNamed(context, '/empl_list');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Произошла ошибка при сохранении')));
        print(e);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SineWaveWidget( verticalOffset: 120),
              const Padding( // Позиционируем кнопку "Ищу работу" на верху экрана
                padding: EdgeInsets.only(
                    left: 32.0, top: 0.0, right: 32.0, bottom: 5.0),
                child: Text(
                  'Разместить задание',
                  textAlign: TextAlign.left, // Добавляем здесь
                  style: TextStyle(fontSize: 36, fontFamily: 'Inter', fontWeight: FontWeight.w900, color: Color(0xFF343434)),
                ),
              ),
              ListTile(
                title: const Text('Разовое задание',
                  style: TextStyle(fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: Color(0xFF343434)),
                ),
                leading: Radio<String>(
                  value: 'once',
                  groupValue: _jobType,
                  onChanged: (value) => setState(() => _jobType = value!),
                  activeColor: const Color(0xFF93D56F), // Цвет выбранного состояния

                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 32), // Уменьшенные вертикальные отступы
              ),
              ListTile(
                title: const Text('Постоянная занятость',
                  style: TextStyle(fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: Color(0xFF343434)),
                ),
                leading: Radio<String>(
                  value: 'const',
                  groupValue: _jobType,
                  onChanged: (value) => setState(() => _jobType = value!),
                  activeColor: const Color(0xFF93D56F), // Цвет выбранного состояния

                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 32), // Уменьшенные вертикальные отступы
              ),

              _buildTextField(_titleController, 'Название задания', false),
              _buildTextField(_descriptionController, 'Описание задания', false),
              _buildDropdownField(
                  _sphere,
                  ['Маркетинг', 'Контент-менеджмент', 'Копирайтинг'],
                  'Выберите сферу',
                      (newValue) {
                    setState(() {
                      _sphere = newValue!;
                    });
                  }
              ),

              _buildTextField(_contactLinkController, 'Ссылка на контакт', false),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0), // Задаём отступы по бокам
            child: SizedBox(
              width: double.infinity, // Задаём ширину во весь экран
              child: ElevatedButton(
                onPressed: _saveJob,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF93D56F),
                  minimumSize: const Size(double.infinity, 60), // Растягиваем кнопку на всю ширину с высотой 50
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Добавляем скругление углов кнопки
                  ),
                ),
                child: const Text('Разместить',
                    style: TextStyle(fontSize: 18, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700)
                ),
              ),
            ),
          ),
              
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTextField(TextEditingController controller, String label, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 32.0), // Уменьшенные отступы
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always, // Лейбл всегда над полем
          labelStyle: const TextStyle(color: Color(0xFF343434)), // Цвет лейбла
          // Устанавливаем толстую рамку
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color:Color(0xFF343434), width: 2.0), // Увеличиваем ширину рамки
          ),
          // Также применяем стиль рамки когда поле в фокусе
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF343434), width: 2.0), // Та же толщина рамки
          ),
          // Стиль рамки при вводе неверных данных
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2.0), // Можно изменить цвет/толщину для ошибок
          ),
        ),
        keyboardType: obscureText ? TextInputType.text : TextInputType.emailAddress,
      ),
    );
  }
  Widget _buildDropdownField(String currentValue, List<String> options, String label, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: currentValue,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 32.0), // Уменьшенные отступы
          labelText: label,
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
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

}