//
//  Error.swift
//  Card
//
//  Created by Andres Pelaez on 19/05/22.
//

struct GraphQLError: Codable {
    let message: String
    let extensions: [Extension]?
}
