import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MamaKris/wave.dart'; // Убедитесь, что wave.dart содержит SineWaveWidget

class RegistrationPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Добавляем прокрутку для поддержки маленьких экранов
        child: Column(
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
            const Padding(
              padding: EdgeInsets.only(
                  left: 32.0, top: 70.0, right: 32.0, bottom: 22.0),
              child: Text(
                'Пожалуйста, зарегистрируйтесь',
                style: TextStyle(fontSize: 32,
                    color: Color(0xFF343434),
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.left,
              ),
            ),
            _buildTextField(emailController, 'Email', false),
            _buildTextField(passwordController, 'Пароль', true),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF93D56F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  minimumSize: Size(double.infinity, 60), // Растягиваем кнопку на всю ширину с отступами
                ),
                onPressed: () async {
                  try {
                    // Регистрация пользователя с помощью email и пароля
                    final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    // Проверка, успешно ли прошла регистрация
                    if (userCredential.user != null) {
                      // Регистрация прошла успешно
                      print('Пользователь успешно зарегистрирован!');

                      // Отправка письма с подтверждением на email пользователя
                      await userCredential.user!.sendEmailVerification();

                      // Перенаправление пользователя на страницу верификации
                      Navigator.pushReplacementNamed(context, '/verification');
                    } else {
                      // Регистрация не удалась
                      print('Регистрация не удалась.');
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'email-already-in-use') {
                      // Email уже используется
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Такой пользователь уже зарегистрирован!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    // Обработка других ошибок
                    print('Ошибка: $e');
                  }
                },
                child: const Text(
                  'Зарегистрироваться',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
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
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always, // Лейбл всегда над полем
          labelStyle: TextStyle(color: Color(0xFF343434)), // Цвет лейбла
          // Устанавливаем толстую рамку
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color:Color(0xFF343434), width: 2.0), // Увеличиваем ширину рамки
          ),
          // Также применяем стиль рамки когда поле в фокусе
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF343434), width: 2.0), // Та же толщина рамки
          ),
          // Стиль рамки при вводе неверных данных
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2.0), // Можно изменить цвет/толщину для ошибок
          ),
        ),
        keyboardType: obscureText ? TextInputType.text : TextInputType.emailAddress,
      ),
    );
  }

}
