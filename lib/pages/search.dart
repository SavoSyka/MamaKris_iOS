import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MamaKris/wave.dart';

class JobSearchPage extends StatefulWidget {
  @override
  _JobSearchPageState createState() => _JobSearchPageState();
}

class _JobSearchPageState extends State<JobSearchPage> {
  final CollectionReference collection = FirebaseFirestore.instance.collection('jobSearches');
  final _formKey = GlobalKey<FormState>();
  bool _openToPermanent = false;
  bool _openToTemporary = false;
  String _sphere = 'Маркетинг';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создание вакансии'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SineWaveWidget(verticalOffset: 120),
              const Padding(
                padding: EdgeInsets.only(top: 10.0, left: 32.0, right: 52.0, bottom: 8),
                child: Text(
                  'Разместить заявку на поиск работы',
                  style: TextStyle(fontSize: 36, fontFamily: 'Inter', fontWeight: FontWeight.w900, color: Color(0xFF343434)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0, left: 32.0, right: 52.0, bottom: 2),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Формат сотрудничества',
                    style: TextStyle(fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.w900, color: Color(0xFF343434)),
                  ),
                ),
              ),

              CheckboxListTile(
                title: const Text('Постоянная занятость',
                  style: TextStyle(fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: Color(0xFF343434)),
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
              CheckboxListTile(
                title: const Text('Разовая подработка',
                  style: TextStyle(fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: Color(0xFF343434)),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 18),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          await collection.add({
                            'openToPermanent': _openToPermanent,
                            'openToTemporary': _openToTemporary,
                            'sphere': _sphere,
                            'employerId': user.uid,
                          });
                          Navigator.pushNamed(context, '/tinder');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF93D56F),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    child: const Text('Разместить', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String currentValue, List<String> options, String label, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 10.0),
      child: DropdownButtonFormField<String>(
        value: currentValue,
        onChanged: onChanged,
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          labelStyle: const TextStyle(color: Color(0xFF343434)),
        ),
      ),
    );
  }
}