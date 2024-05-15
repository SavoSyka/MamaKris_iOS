import UIKit
import Flutter
import Firebase
import Cloudpayments

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    //var window: UIWindow?
    var demoViewController: DemoViewController? // Добавляем свойство для DemoViewController
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Инициализация Firebase
        FirebaseApp.configure()
        GeneratedPluginRegistrant.register(with: self)
        
        // Инициализация DemoViewController
        demoViewController = DemoViewController()
        
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
                self?.startPayment(result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    func startPayment(result: FlutterResult) {
        if let demoVC = demoViewController {
                    demoVC.run()
                    result("Payment process started")
                } else {
                    result(FlutterError(code: "NO_DEMO_VC", message: "DemoViewController is not initialized", details: nil))
                }
    }
}
