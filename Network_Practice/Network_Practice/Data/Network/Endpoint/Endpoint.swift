//
//  Endpoint.swift
//  Network_Practice
//
//  Created by 이지희 on 6/12/24.
//

import Foundation

import Alamofire

enum UserAPI: APIEndpoint {
    case getUser(id: Int)

    var baseURL: URL {
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }

    var path: String {
        switch self {
        case .getUser(let id):
            return "/users/\(id)"
        }
    }

    var method: HTTPMethod {
        return .get
    }

    var headers: HTTPHeaders? {
        return nil
    }

    var parameters: Parameters? {
        return nil
    }
}
