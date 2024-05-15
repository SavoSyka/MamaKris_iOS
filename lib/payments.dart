import 'package:flutter/services.dart';

class PaymentHelper {
  static const platform = MethodChannel('com.mama.kris/payments');

  // Функция для вызова метода startPayment на нативной стороне.
  static Future<String> makePayment() async {
    try {
      final String result = await platform.invokeMethod('startPayment');
      return result;
    } on PlatformException catch (e) {
      return "Failed to make payment: ${e.message}";
    }
  }
}
