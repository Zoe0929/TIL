//
//  RespositoryImpl.swift
//  Network_Practice
//
//  Created by 이지희 on 6/12/24.
//

import Foundation

// 실제 데이터 소스 접근 구현부
class MockRepositoryImpl: TestRepository {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func getUser(id: Int) async throws -> User {
        let endpoint = UserAPI.getUser(id: id)
        return try await networkService.request(endpoint, responseType: User.self)
    }
}
