import PaymentsCore

enum Environment: String {
    case sandbox
    case production

    var baseURL: String {
        switch self {
        case .sandbox:
            return "https://sdk-sample-merchant-server.herokuapp.com"
        case .production:
            return "https://sdk-sample-merchant-server.herokuapp.com"
        }
    }

    var paypalSDKEnvironment: PaymentsCore.Environment {
        switch self {
        case .sandbox:
            return .sandbox
        case .production:
            return .production
        }
    }
}
