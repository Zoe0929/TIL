//
//  Repository.swift
//  Network_Practice
//
//  Created by 이지희 on 6/12/24.
//

import Foundation

// Repository Interface : 데이터 소스를 추상화하는 인터페이스
protocol TestRepository {
    func getUser(id: Int) async throws -> User
}

class MockRepository: TestRepository {
    var mockUser: User?
    var error: Error?

    func getUser(id: Int) async throws -> User {
        if let error = error {
            throw error
        }
        
        guard let user = mockUser else {
            throw NetworkError.noData
        }
        
        return user
    }
}
