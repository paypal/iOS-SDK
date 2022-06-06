//
//  Query.swift
//  Card
//
//  Created by Andres Pelaez on 19/05/22.
//

import Foundation

protocol GraphQLQuery {
    var query: String {get}
    var variables: [String: Any] {get}
    func requestBody() throws -> Data
}
