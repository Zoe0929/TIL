//
//  NetworkResult.swift
//  Network_Practice
//
//  Created by 이지희 on 6/12/24.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidResponse
    case decodingError
    case serverError(statusCode: Int)
    case noData
}
