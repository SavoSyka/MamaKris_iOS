import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green,
        sliderTheme: SliderThemeData(
          activeTrackColor: Colors.green,
          inactiveTrackColor: Colors.green[100],
          thumbColor: Colors.green,
          overlayColor: Colors.green.withAlpha(32),
        ),
        checkboxTheme: CheckboxThemeData(
          checkColor: MaterialStateProperty.all(Colors.white),
          fillColor: MaterialStateProperty.all(Colors.green),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
      home: SalarySlider(),
    );
  }
}

class SalarySlider extends StatefulWidget {
  @override
  _SalarySliderState createState() => _SalarySliderState();
}

class _SalarySliderState extends State<SalarySlider> {
  double _sliderValue =  log(1000) / ln10;
  bool _isChecked = false;
  final _controller = TextEditingController();

  final int minSalary = 1000;
  final int maxSalary = 1000000;
  final int step = 100; // Шаг ползунка

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Зарплата'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CheckboxListTile(
              title: Text('Хотите указать размер оплаты труда?'),
              value: _isChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isChecked = value ?? false;
                });
              },
            ),
            if (_isChecked)
              Slider(
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
              ),
            if (_isChecked)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
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
                  Text(' ₽'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}