import Foundation
import PaymentsCore

extension Environment {

    // swiftlint:disable force_unwrapping
    public var payPalBaseURL: URL {
        switch self {
        case .sandbox:
            return URL(string: "https://sandbox.paypal.com")!
        case .production:
            return URL(string: "https://paypal.com")!
        }
    }
    // swiftlint:enable force_unwrapping
}
