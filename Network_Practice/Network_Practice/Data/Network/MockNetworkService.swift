//
//  MockSession.swift
//  Network_Practice
//
//  Created by 이지희 on 6/12/24.
//

import Foundation

import Alamofire

class MockNetworkService: NetworkServiceProtocol {
    var mockData: Data?
    var error: Error?
    
    func request<T: Decodable>(_ endpoint: APIEndpoint, responseType: T.Type) async throws -> T {
        // Mock 데이터를 로드합니다.
        if let error = error {
            throw error
        }
        
        guard let data = mockData else {
            throw NetworkError.noData
        }
        
        // T 타입으로 변환합니다.
        guard let data = try? JSONEncoder().encode(data),
              let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return decodedData
    }
}

