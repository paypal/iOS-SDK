//
//  File.swift
//  
//
//  Created by Karthik Gangineni on 5/25/22.
//

import Foundation

enum APIResult<T>{
    case success(T)
    case failure(GraphQLError)
}
