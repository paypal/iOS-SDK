import Foundation
import AuthenticationServices
@testable import PaymentsCore

class MockWebAuthenticationSession: WebAuthenticationSession {

    var cannedResponseURL: URL?
    var cannedErrorResponse: Error?

    override func start(url: URL, context: ASWebAuthenticationPresentationContextProviding, completion: @escaping (URL?, Error?) -> Void) {
        completion(cannedResponseURL, cannedErrorResponse)
    }
}
