import UIKit
import Cloudpayments

class DemoViewController: BaseViewController {
    private var viewModels = PaymentViewModel.getViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    // Метод для вызова из AppDelegate
    func run() {
        print("Running payment process...")
        PaymentViewModel.saving(viewModels)
        
        guard let apiUrl = getText(.api),
              let publicId = getText(.publicId),
              let amount = getText(.amount),
              let currency = getText(.currency),
              let invoiceId = getText(.invoiceId),
              let description = getText(.description),
              let account = getText(.accountId),
              let email = getText(.email) else {
            return
        }
        
        let paymentData = PaymentData()
            .setAmount(amount)
            .setCurrency(currency)
            .setApplePayMerchantId("your_merchant_id_here")
            .setCardholderName("CP SDK")
            .setIpAddress("98.21.123.32")
            .setInvoiceId(invoiceId)
            .setDescription(description)
            .setAccountId(account)
            .setEmail(email)

        let configuration = PaymentConfiguration(
            publicId: publicId,
            paymentData: paymentData,
            delegate: self,
            uiDelegate: self,
            scanner: nil,
            requireEmail: false,
            useDualMessagePayment: false,
            disableApplePay: true,
            apiUrl: apiUrl
        )

        // Отображение платежной формы
        PaymentForm.present(with: configuration, from: self)
    }

    func getText(_ type: PaymentViewModelType) -> String? {
        for value in viewModels {
            if value.type == type { return value.text }
        }
        return nil
    }
}

// Расширения для протоколов PaymentDelegate и PaymentUIDelegate
extension DemoViewController: PaymentDelegate {
    func onPaymentFinished(_ transactionId: Int64?) {
        print("Transaction finished with ID: \(transactionId ?? 0)")
    }
    
    func onPaymentFailed(_ errorMessage: String?) {
        print("Transaction failed with error: \(errorMessage ?? "Unknown error")")
    }
}

extension DemoViewController: PaymentUIDelegate {
    func paymentFormWillDisplay() { print("Payment form will display") }
    func paymentFormDidDisplay() { print("Payment form did display") }
    func paymentFormWillHide() { print("Payment form will hide") }
    func paymentFormDidHide() { print("Payment form did hide") }
}
