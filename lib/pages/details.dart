import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import 'package:MamaKris/wave.dart';
import 'package:MamaKris/icon.dart';
import 'package:MamaKris/pages/subscription.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:MamaKris/pages/tinder.dart';

class JobDetailsPage extends StatefulWidget {
  final Map<String, dynamic> jobData;

  const JobDetailsPage({Key? key, required this.jobData}) : super(key: key);

  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Не удалось открыть $url';
    }
  }

  Future<void> _makePhoneCall(String phoneNumber, BuildContext context) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    print(await canLaunchUrl(phoneUri));
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
        print(await canLaunchUrl(phoneUri));
      } else {
        // Если не удалось, копируем номер телефона в буфер обмена
        await Clipboard.setData(ClipboardData(text: phoneNumber));
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('Адрес электронной почты скопирован: $phoneNumber'))
        // );
        showOverlayMessage(context, 'Номер телефона скопирован: $phoneNumber');

      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Ошибка открытия звонка: $e'))
      // );
      showOverlayMessage(context, 'Ошибка открытия звонка: $e');

    }
  }

  Future<void> _sendEmail(String email, BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email, // Адрес электронной почты
      query: 'subject=${Uri.encodeComponent('Отклик на вакансию')}&body=${Uri.encodeComponent('Здраствуйте, пишу Вам по вакансии из приложения MamaKris.')}', // Тема и тело письма
    );
    print(await canLaunchUrl(emailUri));
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      }
      else {
        // Если не удалось, копируем адрес электронной почты в буфер обмена
        await Clipboard.setData(ClipboardData(text: email));
        // ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('Адрес электронной почты скопирован: $email'))
        // );
        showOverlayMessage(context, 'Адрес электронной почты скопирован: $email');
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Ошибка отправки письма: $e'))
      // );
      showOverlayMessage(context, 'Ошибка отправки письма: $e');

    }
  }

  void showOverlayMessage(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );

    overlay?.insert(overlayEntry);

    // Удалить сообщение через 3 секунды
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }


  void _getContacts() {
    String employerContacts = widget.jobData['contactLink'] ?? 'Нет контактов';
    String employerName = widget.jobData['name'] ?? 'Неизвестно';
    String contactProvider = widget.jobData['provider'] ?? 'nan';

    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    double TextMultiply = min(width/360, height/800);
    double VerticalMultiply = height/800;
    double HorizontalMultiply = width/360;



    String employerContactsBackub = employerContacts;
    // Формируем контактную ссылку в зависимости от провайдера
    if (contactProvider == 'Telegram') {
      employerContacts = 'https://t.me/$employerContacts';
    } else if (contactProvider == 'WhatsApp') {
      employerContacts = 'https://wa.me/$employerContacts';  // WhatsApp использует формат номера телефона без префиксов
    } else if (contactProvider == 'VK') {
      employerContacts = 'https://vk.com/$employerContacts';
    } else if (contactProvider == 'Электронная почта') {
      employerContacts = employerContacts;
    }
    else {
      employerContacts = employerContacts;
    }
    String providerIconPath;
    switch (contactProvider) {
      case 'Telegram':
        providerIconPath = 'images/providers/telegram.svg';
        break;
      case 'WhatsApp':
        providerIconPath = 'images/providers/whatsapp.svg';
        break;
      case 'VK':
        providerIconPath = 'images/providers/vk.svg';
        break;
      case 'Телефон':
        providerIconPath = 'images/providers/phone.svg';
        break;
      case 'Электронная почта':
        providerIconPath = 'images/providers/email.svg';
        break;
      default:
        providerIconPath = 'images/logo.svg'; // Путь к иконке по умолчанию
        break;
    }
    String buttonText;
    Function()? buttonAction;

    if (contactProvider == 'Телефон') {
      buttonText = 'ПОЗВОНИТЬ';
      buttonAction = () => _makePhoneCall(employerContacts, context);
    }
    else if (contactProvider == 'Электронная почта'){
      buttonText = 'НАПИСАТЬ';
      buttonAction = () => _sendEmail(employerContacts, context);

    }

    else {
      buttonText = 'НАПИСАТЬ';
      buttonAction = () => _launchURL(employerContacts);
    }
    // Показываем BottomSheet с контактами
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.6, // Высота модального окна как 50% от высоты экрана
          child: Container(
            padding:  EdgeInsets.all(16*TextMultiply),
            width: MediaQuery.of(context).size.width,
            decoration:  BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20*TextMultiply),
                topRight: Radius.circular(20*TextMultiply),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Уменьшаем размер колонки до минимума, необходимого для содержимого
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 40*VerticalMultiply),
                  child: Text(
                      employerName,
                      style: TextStyle(fontSize: 24*TextMultiply, color: Color(0xFF343434), fontFamily: 'Inter', fontWeight: FontWeight.w700)
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 45*VerticalMultiply),
                    child: SvgPicture.asset(
                      providerIconPath,
                      width: 112*HorizontalMultiply, // Ширина в пикселях
                      height: 112*VerticalMultiply, // Высота в пикселях
                    ),

                  ),
                ),
                SizedBox(height: 10*VerticalMultiply),

                Text(
                    employerContactsBackub,
                    style: TextStyle(fontSize: 14*TextMultiply, color: Color(0xFF343434), fontFamily: 'Inter1', fontWeight: FontWeight.w500)
                ),
                SizedBox(height: 35*VerticalMultiply),

                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Закрываем модальное окно
                  },
                  child: const Text('Закрыть', style: TextStyle(color: Colors.blue)),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: 32*HorizontalMultiply, top: (5)*VerticalMultiply, right: 32*HorizontalMultiply, bottom:32*VerticalMultiply), // Общий отступ для группы текстов
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
                      onPressed: buttonAction,
                      child:  Text(buttonText,
                          style: TextStyle(fontSize: 14*TextMultiply, color: Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700)
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    double TextMultiply = min(width/360, height/800);
    double VerticalMultiply = height/800;
    double HorizontalMultiply = width/360;
    int _selectedIndex = 1; // Индекс для отслеживания текущего выбранного элемента

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });

      switch(index) {
        case 0:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => TinderPage()),
                (_) => false,
          );
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/projects');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/profile');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/support');
          break;
      }
    }


    return Scaffold(
      body:Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,

                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        SineWaveWidget(verticalOffset: 206*VerticalMultiply),


                        Padding(
                          padding:  EdgeInsets.only(
                              left: 28*HorizontalMultiply, top: 82*VerticalMultiply, right: 28*HorizontalMultiply, bottom: 0),

                          child: Text(
                            '${widget.jobData!['title']}',
                            style: TextStyle(fontSize: 24*TextMultiply, fontFamily: 'Inter', fontWeight: FontWeight.w700, color: Color(0xFF343434)),
                            textAlign: TextAlign.left, // Добавляем здесь
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(
                              left: 32.0*HorizontalMultiply, top: 238.0*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 0),
                          child: Text(
                            ' ${widget.jobData!['description']}',
                            style: TextStyle(fontSize: 16*TextMultiply, fontFamily: 'Inter1', fontWeight: FontWeight.w500, color: Color(0xFF343434)),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding:  EdgeInsets.only(
                            left: 32.0*HorizontalMultiply, top: 30*VerticalMultiply, right: 32.0*HorizontalMultiply, bottom: 0),
                        child: Text(
                          ' Примерная оплата: ${widget.jobData!['salary']}₽',
                          style: TextStyle(fontSize: 16*TextMultiply, fontFamily: 'Inter1', fontWeight: FontWeight.w500, color: Color(0xFF343434)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      height: 120*VerticalMultiply,
                    )


                  ]
              ),
            ),
            Padding(
                padding:  EdgeInsets.only(left: 32.0*HorizontalMultiply, top: 632*VerticalMultiply , right: 32.0*HorizontalMultiply, bottom: 0),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF93D56F), Color(0xFF659A57)], // Градиент от #93D56F до #659A57
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(30*TextMultiply), // Скругление углов
                      ),

                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.jobData.containsKey('contactLink') && widget.jobData['contactLink'] != null) {
                            _getContacts(); // Используем контакты непосредственно из `widget.jobData`
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Ошибка: Контактные данные недоступны.'))
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, // Прозрачный фон для отображения градиента
                          shadowColor: Colors.transparent, // Убираем тень
                          //foregroundColor: Colors.white, // Цвет иконки
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30*TextMultiply), // Закругленные углы
                          ),
                          minimumSize:  Size(144*TextMultiply, 60*TextMultiply), // Минимальный размер кнопки
                          padding: EdgeInsets.symmetric(vertical: 15*TextMultiply),

                        ),
                        child:  Text(
                          'КОНТАКТ',
                          style: TextStyle(fontSize: 14*TextMultiply, color: const Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700),
                        ),                      ),
                    ),

                    ElevatedButton(
                      onPressed: () =>   Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD1CEB9), // Цвет фона кнопки
                        foregroundColor: Colors.white, // Цвет иконки
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30*TextMultiply), // Закругленные углы
                        ),
                        minimumSize:  Size(144*TextMultiply, 60*TextMultiply), // Минимальный размер кнопки

                      ),
                      child:  Text(
                        'НАЗАД',
                        style: TextStyle(fontSize: 14*TextMultiply, color: const Color(0xFFFFFFFF), fontFamily: 'Inter', fontWeight: FontWeight.w700),
                      ),                    ),
                  ],
                )

            ),

          ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgIcon('images/icons/main.svg'),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: DoubleIcon(
              bottomIconAsset: 'images/icons/projects-bg.svg',
              topIconAsset: 'images/icons/projects.svg',
            ),            label: 'Проекты',
          ),
          BottomNavigationBarItem(
            icon: SvgIcon('images/icons/profile.svg'),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: SvgIcon('images/icons/support.svg',
            ),
            label: 'Поддержка',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black, // Цвет выбранного элемента
        unselectedItemColor: Colors.black, // Цвет не выбранного элемента
        onTap: _onItemTapped,
      ),
    );
  }
}
