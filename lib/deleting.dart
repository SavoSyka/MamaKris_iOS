import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:MamaKris/pages/start.dart';





void deleteUser(BuildContext context) async {
  try {
    await FirebaseAuth.instance.currentUser!.delete();
    // Пользователь успешно удален, можете перенаправить на экран входа или на главный экран
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => StartPage()), // Замените SubscribePage() на страницу, на которую хотите перейти
          (_) => false,
    );   } on FirebaseAuthException catch (e) {
    if (e.code == 'requires-recent-login') {
      // Если с момента последнего входа прошло слишком много времени, Firebase требует повторного входа
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Ошибка'),
            content: Text('Для удаления аккаунта необходимо недавнее подтверждение входа. Пожалуйста, войдите в аккаунт заново и попробуйте еще раз.'),
            actions: <Widget>[
              TextButton(
                child: Text('ОК'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => StartPage()), // Замените SubscribePage() на страницу, на которую хотите перейти
                        (_) => false,
                  );                 },
              ),
            ],
          );
        },
      );
    } else {
      // Обработка других ошибок
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Ошибка'),
            content: Text('Произошла ошибка при удалении аккаунта: ${e.message}'),
            actions: <Widget>[
              TextButton(
                child: Text('ОК'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
