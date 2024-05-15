import UIKit
import Flutter
import Firebase
import Cloudpayments

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    private var paymentManager: PaymentManager?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Инициализация Firebase
        FirebaseApp.configure()
        GeneratedPluginRegistrant.register(with: self)

        // Проверка и инициализация контроллера
        guard let controller = window?.rootViewController as? FlutterViewController else {
            fatalError("rootViewController is not type FlutterViewController")
        }

        // Настройка канала для обмена данными с Flutter
        let methodChannel = FlutterMethodChannel(name: "com.mama.kris/payments",
                                         binaryMessenger: controller.binaryMessenger)

        // Настройка обработчика метода startPayment
        methodChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "startPayment" {
                self?.paymentManager?.startPayment(result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        })

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
     func startPayment(result: FlutterResult) {
        result("payment process began...")
//         let paymentData = PaymentData()
//             .setAmount("100") // Cумма платежа в валюте, максимальное количество не нулевых знаков после запятой: 2
//             .setCurrency("RUB") // Валюта
//             .setDescription("Корзина цветов") // Описание оплаты в свободной форме
//             .setAccountId("111") // Обязательный идентификатор пользователя для создания подписки и получения токена
//             .setIpAddress("98.21.123.32") // IP-адрес плательщика
//             .setInvoiceId("123") // Номер счета или заказа
//             .setEmail("test@cp.ru") // E-mail плательщика, на который будет отправлена квитанция об оплате

//         let configuration = PaymentConfiguration.init(
//             publicId: "pk_baafe7639956b99ea9fefcac62b9a", // Ваш Public_id из личного кабинета
//             paymentData: paymentData, // Информация о платеже
//             delegate: self, // Вывод информации о завершении платежа
//             uiDelegate: self, // Вывод информации о UI
//             scanner: nil, // Сканер банковских карт
//             requireEmail: false, // Обязательный email, (по умолчанию false)
//             useDualMessagePayment: true, // Использовать двухстадийную схему проведения платежа, (по умолчанию используется одностадийная схема)
//             disableApplePay: false, // Выключить Apple Pay, (по умолчанию Apple Pay включен)
//             successRedirectUrl: "", // Ваш deeplink для редиректа из приложения банка после успешной оплаты, (если ничего не передано, по умолчанию используется URL адрес вашего сайта)
//             failRedirectUrl: "" //  Ваш deeplink для редиректа из приложения банка после неуспешной оплаты, (если ничего не передано, по умолчанию используется URL адрес вашего сайта)
//         )
    }


}
