import UIKit

#if canImport(PaymentsCore)
import PaymentsCore
#endif

#if canImport(PayPalCheckout)
@_implementationOnly import PayPalCheckout
#endif

public typealias PayPalCheckoutCompletion = (PayPalCheckoutResult) -> Void

/// PayPal Paysheet to handle PayPal transaction
public class PayPalClient {

    private let config: CoreConfig
    private let returnURL: String

    lazy var paypalCheckoutConfig: CheckoutConfig = {
        CheckoutConfig(
            clientID: config.clientID,
            returnUrl: returnURL,
            environment: config.environment.toPayPalCheckoutEnvironment()
        )
    }()

    public init(config: CoreConfig, returnURL: String) {
        self.config = config
        self.returnURL = returnURL
    }

    /// Present PayPal Paysheet and start a PayPal transaction
    /// - Parameters:
    ///   - orderID: the order ID for the transaction
    ///   - presentingViewController: the ViewController to present PayPalPaysheet on, if not provided, the Paysheet will be presented on your top-most ViewController
    ///   - completion: Completion block to handle buyer's approval, cancellation, and error.
    public func start(orderID: String, presentingViewController: UIViewController? = nil, completion: PayPalCheckoutCompletion? = nil) {
        setupPayPalCheckoutConfig(orderID: orderID, completion: completion)
        Checkout.start(presentingViewController: presentingViewController)
    }

    func setupPayPalCheckoutConfig(orderID: String, completion: PayPalCheckoutCompletion? = nil) {
        paypalCheckoutConfig.createOrder = { action in
            action.set(orderId: orderID)
        }

        paypalCheckoutConfig.onApprove = { approval in
            completion?(.success(result: PayPalResult(approvalData: approval.data)))
        }

        paypalCheckoutConfig.onCancel = {
            completion?(.cancellation)
        }

        paypalCheckoutConfig.onError = { errorInfo in
            completion?(.failure(error: PayPalError.payPalCheckoutError(errorInfo)))
        }

        Checkout.set(config: paypalCheckoutConfig)
    }
}