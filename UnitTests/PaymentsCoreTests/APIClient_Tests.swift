import XCTest
@testable import PaymentsCore
@testable import TestShared

class APIClient_Tests: XCTestCase {

    // MARK: - Helper Properties
    
    let successURLResponse = HTTPURLResponse(url: URL(string: "www.test.com")!, statusCode: 200, httpVersion: "https", headerFields: [:])
    let config = CoreConfig(clientID: "", environment: .sandbox)
    let accessTokenRequest = AccessTokenRequest(clientID: "")
    
    var mockURLSession: URLSessionMock!
    var apiClient: APIClient!
    
    // MARK: - Test lifecycle
    
    override func setUp() {
        super.setUp()
        
        mockURLSession = URLSessionMock()
        mockURLSession.cannedError = nil
        mockURLSession.cannedURLResponse = nil
        mockURLSession.cannedData = nil
        
        apiClient = APIClient(urlSession: mockURLSession, environment: .sandbox)
    }
    
    
    // TODO: This test is specific to AccessToken, move it out of this file.
    func testFetch_whenAccessTokenSuccessResponse_returnsValidAccessToken() {
        let expect = expectation(description: "Get mock response for access token request")

        let jsonResponse = """
        {
            "scope": "fake-scope",
            "access_token": "fake-token",
            "token_type": "fake-bearer",
            "expires_in": 1,
            "nonce": "fake-nonce"
        }
        """

        mockURLSession.cannedURLResponse = successURLResponse
        mockURLSession.cannedData = jsonResponse.data(using: String.Encoding.utf8)!

        apiClient.fetch(endpoint: accessTokenRequest) { result, _ in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.accessToken, "fake-token")
                XCTAssertEqual(response.nonce, "fake-nonce")
                XCTAssertEqual(response.scope, "fake-scope")
                XCTAssertEqual(response.tokenType, "fake-bearer")
                XCTAssertEqual(response.expiresIn, 1)
            case .failure(_):
                XCTFail("Expect success response")
            }

            expect.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testFetch_whenServerError_returnsConnectionError() {
        let expect = expectation(description: "should vend error to client call site")
        let serverError = NSError(
            domain: URLError.errorDomain,
            code: NSURLErrorBadServerResponse,
            userInfo: nil
        )

        mockURLSession.cannedError = serverError

        apiClient.fetch(endpoint: accessTokenRequest) { result, _ in
            guard case .failure(.connectionIssue) = result else {
                XCTFail("")
                return
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testFetch_whenNoResponseData_returnsMissingDataError() {
        let expect = expectation(description: "Get mock response for access token request")


        mockURLSession.cannedURLResponse = successURLResponse

        apiClient.fetch(endpoint: accessTokenRequest) { result, _ in
            guard case .failure(.noResponseData) = result else {
                XCTFail()
                return
            }

            expect.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testFetch_whenNoURLResponse_returnsInvalidURLResponseError() {
        let expect = expectation(description: "Get mock response for access token request")

        mockURLSession.cannedURLResponse = nil

        apiClient.fetch(endpoint: accessTokenRequest) { result, _ in
            guard case .failure(.invalidURLResponse) = result else {
                XCTFail()
                return
            }

            expect.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testFetch_whenInvalidData_returnsParseError() {
        let expect = expectation(description: "Get mock response for access token request")

        let jsonResponse = """
        {
            "test": "wrong response format"
        }
        """

        mockURLSession.cannedURLResponse = successURLResponse
        mockURLSession.cannedData = jsonResponse.data(using: String.Encoding.utf8)!

        apiClient.fetch(endpoint: accessTokenRequest) { result, _ in
            guard case .failure(.parsingError) = result else {
                XCTFail()
                return
            }

            expect.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    // TODO: Get more granual here. Also, do we want to move this check for
    // non-success status code above data parsing in our source code?
    func testFetch_whenBadStatusCode_returnsUnknownError() {
        let expect = expectation(description: "Get mock response for access token request")
        
        let jsonResponse = """
        { "some": "json" }
        """

        mockURLSession.cannedData = jsonResponse.data(using: String.Encoding.utf8)!
        
        mockURLSession.cannedURLResponse = HTTPURLResponse(
            url: URL(string: "www.fake.com")!,
            statusCode: 500,
            httpVersion: "1",
            headerFields: [:]
        )
                
        apiClient.fetch(endpoint: accessTokenRequest) { result, _ in
            guard case .failure(.unknown) = result else {
                XCTFail()
                return
            }
            
            expect.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

//    func testFetch_withRequestExpectingEmptyResponse_vendsSuccessResult() {
//        let expect = expectation(description: "Get empty response type for mock request")
//        let emptyRequest = EmptyRequestResponseMock()
//
//        URLProtocolMock.requestResponses.append(emptyRequest)
//
//        apiClient.fetch(endpoint: emptyRequest) { result, _ in
//            guard case .success = result else {
//                XCTFail("Expected successful empty response")
//                return
//            }
//            expect.fulfill()
//        }
//        waitForExpectations(timeout: 1)
//    }

//    func testFetch_withNoResponseMock_vendsNoReponseError() {
//        let expect = expectation(description: "Should receive bad URLResponse error")
//        let noReponseRequest = NoReponseRequestMock()
//
//        URLProtocolMock.requestResponses.append(noReponseRequest)
//
//        apiClient.fetch(endpoint: noReponseRequest) { result, _ in
//            guard case .failure(.invalidURLResponse) = result else {
//                XCTFail("Expected bad URLResponse error")
//                return
//            }
//            expect.fulfill()
//        }
//        waitForExpectations(timeout: 1)
//    }

//    func testFetch_withNoURLRequest_vendsNoURLRequestError() {
//        let expect = expectation(description: "Should receive noURLRequest error")
//
//        // Mock request whose API object does not vend a URLRequest
//        let noURLRequest = NoURLRequestMock()
//
//        URLProtocolMock.requestResponses.append(noURLRequest)
//
//        apiClient.fetch(endpoint: noURLRequest) { result, _ in
//            guard case .failure(.noURLRequest) = result else {
//                XCTFail("Expected bad URLResponse error")
//                return
//            }
//            expect.fulfill()
//        }
//        waitForExpectations(timeout: 1)
//    }
}
