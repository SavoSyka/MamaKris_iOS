import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:MamaKris/wave.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';


class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController(); // Для повторного ввода пароля
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _obscureText = true;
  bool _obscureTextConf = true;

  Future<bool?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(credential);

        // Возвращаем true, если пользователь новый, и false, если нет
        return userCredential.additionalUserInfo?.isNewUser;
      }
    } catch (e) {
      print(e);
    }
    return null; // В случае ошибки возвращаем null
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                SineWaveWidget(verticalOffset:  340*VerticalMultiply),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 58*VerticalMultiply),
                    child: SvgPicture .asset(
                      'images/logo_named.svg',
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
                Padding(
                  padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 370*VerticalMultiply, right:0, bottom:0), // Общий отступ для группы текстов
                  child:  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Пожалуйста,',
                      style: TextStyle(fontSize: 28*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w700, color: const Color(0xFF343434), height: 1,),
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 400*VerticalMultiply, right:0, bottom:0), // Общий отступ для группы текстов
                  child:  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'зарегистрируйтесь',
                      style: TextStyle(fontSize: 28*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w700, color: const Color(0xFF343434), height: 1,),
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 446*VerticalMultiply , right:0, bottom:0), // Общий отступ для группы текстов
                  child:  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'email',
                      style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: const Color(0xFF343434), height: 1,),
                    ),
                  ),
                ),
                _buildEmailField(emailController, 32*HorizontalMultiply, 466*VerticalMultiply),
                Padding(
                  padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 530*VerticalMultiply, right:0, bottom:0), // Общий отступ для группы текстов
                  child:  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'пароль',
                      style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: const Color(0xFF343434), height: 1,),
                    ),
                  ),
                ),
                _buildPassField(passwordController, _obscureText, 32*HorizontalMultiply, 550*VerticalMultiply, true),
                Padding(
                  padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: 619*VerticalMultiply, right:0, bottom:0), // Общий отступ для группы текстов
                  child:  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'подтвердите пароль',
                      style: TextStyle(fontSize: 13*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w600, color: const Color(0xFF343434), height: 1,),
                    ),
                  ),
                ),
                _buildPassField(confirmPasswordController, _obscureTextConf, 32*HorizontalMultiply, 639*VerticalMultiply, false),


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
                      onPressed:  _register,
                      child:  Text(
                        'ЗАРЕГИСТРИРОВАТЬСЯ',
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

  Future<void> _register() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пароли не совпадают! Пожалуйста, проверьте введённые пароли.'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Выйти из функции, если пароли не совпадают
    }

    // if (passwordController.text.length < 6) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text('Пароль слишком короткий! Минимальная длина пароля - 6 символов.'),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    //   return; // Выйти из функции, если пароль слишком короткий
    // }

    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        await userCredential.user!.sendEmailVerification();
        Navigator.pushReplacementNamed(context, '/verification');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Произошла ошибка. Пожалуйста, попробуйте ещё раз.';

      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Некорректный адрес электронной почты.';
          break;
        case 'weak-password':
          errorMessage = 'Пароль слишком простой.\nПожалуйста, используйте более сложный пароль.\nМинимальная длина пароля - 6 символов.';
          break;
        case 'email-already-in-use':
          errorMessage = 'Такой пользователь уже зарегистрирован.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Операция не разрешена. Пожалуйста, свяжитесь с поддержкой.';
          break;
        case 'too-many-requests':
          errorMessage = 'Слишком много запросов. Пожалуйста, попробуйте позже.';
          break;
        default:
          print('Необработанная ошибка: ${e.code}');
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print('Ошибка: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Непредвиденная ошибка. Пожалуйста, попробуйте ещё раз.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildEmailField(TextEditingController controller, double Hpadding, double Vpadding) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    double TextMultiply = min(width/360, height/800);
    return Padding(
      padding:  EdgeInsets.only(left: Hpadding, top: Vpadding, right:Hpadding, bottom:0), // Общий отступ для группы текстов
      child: TextField(
        controller: controller,
        obscureText: false,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always, // Лейбл всегда над полем
          labelStyle: const TextStyle(color: Color(0xFF343434)), // Цвет лейбла
          // Устанавливаем толстую рамку
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12*TextMultiply),
            borderSide: BorderSide(color:const Color(0xFF343434), width: 2.0*TextMultiply), // Увеличиваем ширину рамки
          ),
          // Также применяем стиль рамки когда поле в фокусе
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12*TextMultiply),
            borderSide: BorderSide(color: const Color(0xFF343434), width: 2.0*TextMultiply), // Та же толщина рамки
          ),
          // Стиль рамки при вводе неверных данных
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12*TextMultiply),
            borderSide: BorderSide(color: Colors.red, width: 2.0*TextMultiply), // Можно изменить цвет/толщину для ошибок
          ),
        ),
      ),
    );
  }

  Widget _buildPassField(TextEditingController controller, bool obscureText, double Hpadding, double Vpadding, bool type) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    double TextMultiply = min(width/360, height/800);

    return Padding(
      padding: EdgeInsets.only(left: Hpadding, top: Vpadding, right: Hpadding, bottom: 0), // Общий отступ для группы текстов
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always, // Лейбл всегда над полем
          labelStyle: const TextStyle(color: Color(0xFF343434)), // Цвет лейбла
          // Устанавливаем толстую рамку
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12*TextMultiply),
            borderSide: BorderSide(color:const Color(0xFF343434), width: 2.0*TextMultiply), // Увеличиваем ширину рамки
          ),
          // Также применяем стиль рамки когда поле в фокусе
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12*TextMultiply),
            borderSide: BorderSide(color: const Color(0xFF343434), width: 2.0*TextMultiply), // Та же толщина рамки
          ),
          // Стиль рамки при вводе неверных данных
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12*TextMultiply),
            borderSide: BorderSide(color: Colors.red, width: 2.0*TextMultiply), // Можно изменить цвет/толщину для ошибок
          ),          suffixIcon: IconButton(
          icon: Icon(
            // Изменяем иконку в зависимости от того, скрыт текст или нет
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFF343434),
          ),
          onPressed: () {
            // Переключаем состояние отображения текста при нажатии
            setState(() {
              if (type) {
                _obscureText = !_obscureText;
              }
              else {
                _obscureTextConf = !_obscureTextConf;
              };
            });
          },
        ),
          // Другие свойства InputDecoration...
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

}