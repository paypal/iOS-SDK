//
//  GraphQLClient.swift
//  Card
//
//  Created by Andres Pelaez on 19/05/22.
//

import Foundation
import PaymentsCore

class GraphQLClient {
    
    private var environment: Environment
    private var jsonEncoder: JSONEncoder = JSONEncoder()
    private var urlSession: URLSession
    
    public init(environment: Environment) {
        self.environment = environment
        self.urlSession = URLSession.shared
    }

    func executeQuery<T: Decodable>(query: Query) async throws -> GraphQLQueryResponse<T> {
        var request = try createURLRequest(requestBody: query.requestBody())
        headers().forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        print("request: ", request)
        let (data, response) = try await urlSession.performRequest(with: request)
        _ = (response as? HTTPURLResponse)?.allHeaderFields["Paypal-Debug-Id"] as? String
        print(response)
        guard response is HTTPURLResponse else {
            return GraphQLQueryResponse(data: nil, extensions: nil, errors: nil)
        }
        let decoded: T = try parse(data: data)
        print("response: ", String(data: data, encoding: .utf8))
        return GraphQLQueryResponse(data: decoded, extensions: nil, errors: nil)
    }
    
    func parse<T: Decodable>(data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func createURLRequest(requestBody: String) throws -> URLRequest {
        var urlRequest = URLRequest(url: environment.graphqlURL)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.httpBody = requestBody.data(using: .utf8)
        print("request: ", requestBody)
        return urlRequest
    }
    
    func headers() -> Dictionary<String, String>{
        var headers = Dictionary<String, String>()
        headers["Content-type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["x-app-name"] = "nativecheckout"
        headers["Origin"] = "https://www.sandbox.paypal.com"
        return headers
    }
    
    let body = """
{"query":"query {\n   fundingEligibility(clientId: "AWuNAP9NxbCWU6BqlenVLTziw7cSzdbIm7Tkla0lLSI-Jupex0LW7noBnRParW4_t_pBVzv92HATEDw3"\n    intent: CAPTURE \n    currency: USD \n    enableFunding: [VENMO]) \n   {\n        venmo{\n            eligible\n            reasons\n        }\n        card{\n              eligible\n        }\n        paypal{\n              eligible\n              reasons\n        }\n        paylater{\n              eligible\n              reasons\n        }\n        credit{\n            eligible\n            reasons\n        }\n        \n   }\n}","variables":{}}
"""
    
}
